#include "userprog/syscall.h"
#include <stdio.h>
#include <syscall-nr.h>
#include "threads/interrupt.h"
#include "threads/thread.h"
#include "threads/loader.h"
#include "userprog/gdt.h"
#include "threads/flags.h"
#include "intrinsic.h"
#include "threads/init.h"
#include "filesys/filesys.h"
#include "threads/palloc.h"

void syscall_entry (void);
void syscall_handler (struct intr_frame *);

/* helper functions */
static bool check_address(void *addr);
void get_argument(void *esp, int *arg, int count);
struct list_elem* find_fd_elem(int fd); // returns corresponding fd_elem for the given fd

/* syscall handler functions */
void halt(void); //void shutdown_power_off(void)
void exit(int status); //void thread_exit(void)

// file system related functions
bool create(const char *file, unsigned initial_size); // bool filesys_create(const char *name, off_t initial_size)
bool remove(const char *file); // bool filesys_remove(const char *name)
int open(const char *file); // open file and return file descriptor to tread calling syscall
void close (int fd); // close associated file to the given fd
int read (int fd, void *buffer, unsigned size);
int write(int fd, void *buffer, unsigned size);
int filesize(int fd);





/* System call.
 *
 * Previously system call services was handled by the interrupt handler
 * (e.g. int 0x80 in linux). However, in x86-64, the manufacturer supplies
 * efficient path for requesting the system call, the `syscall` instruction.
 *
 * The syscall instruction works by reading the values from the the Model
 * Specific Register (MSR). For the details, see the manual. */

#define MSR_STAR 0xc0000081         /* Segment selector msr */
#define MSR_LSTAR 0xc0000082        /* Long mode SYSCALL target */
#define MSR_SYSCALL_MASK 0xc0000084 /* Mask for the eflags */

void
syscall_init (void) {
	write_msr(MSR_STAR, ((uint64_t)SEL_UCSEG - 0x10) << 48  |
			((uint64_t)SEL_KCSEG) << 32);
	write_msr(MSR_LSTAR, (uint64_t) syscall_entry);

	/* The interrupt service rountine should not serve any interrupts
	 * until the syscall_entry swaps the userland stack to the kernel
	 * mode stack. Therefore, we masked the FLAG_FL. */
	write_msr(MSR_SYSCALL_MASK,
			FLAG_IF | FLAG_TF | FLAG_DF | FLAG_IOPL | FLAG_AC | FLAG_NT);
	
	lock_init(&filesys_lock); //initialize global lock on filesys -> protect filesystem related codes
}

/* The main system call interface */
// check the validation of the pointers in the parameter list
// the pointers supplied by the user must point to user area / not valid addr -> pagefault
// copy args on the user stack to the kernel
// save return value of system call at eax register
void
syscall_handler (struct intr_frame *f) {
	//syscall: userlevel -> kernel level
	//stack pointer가 유저영역인지 확인
	// printf("systemcall!");
	// printf("");
	// struct threaed *curr = thread_current();

	if (!check_address((f->rsp)))
		thread_exit();
	
	switch(f->R.rax) // R: general purpose register, userstack에 저장되어있는 시스템 콜 넘버
	{
		case SYS_HALT: //0
			halt();
			break;
		case SYS_EXIT: //1
			exit((int)f->R.rdi);
			thread_exit();
			break;

		case SYS_CREATE:
			f->R.rax = create(f->R.rdi, f->R.rsi); //filename, count
			break;
		case SYS_REMOVE:
			f->R.rax = remove(f->R.rdi);
			break;
		
		case SYS_OPEN:
			f->R.rax = open(f->R.rdi);
			// printf("open result(fd): %d\n",f->R.rax);
			break;
		case SYS_CLOSE:
			close(f->R.rdi);
			break;
		case SYS_WRITE:
			printf("%s", f->R.rsi);
			break;
		case SYS_EXEC:
			// exec();
			break;
		case SYS_WAIT:
			break;

	}
}



void halt(void){
    power_off();
}

void exit(int status){ 
    thread_current()->exit_status = status;
    printf("%s: exit(%d)\n", thread_name(), status);
    thread_exit();
}

bool create(const char *file, unsigned initial_size){  // bool filesys_create(const char *name, off_t initial_size)
	if (file && check_address(file)){ //filename exists & in userland
		return filesys_create(file, initial_size);
    }
	// something wrong
    exit(-1);
}


bool remove(const char *file){ // bool filesys_remove(const char *name)
    if (file && check_address(file)){
        return filesys_remove(file);
    } else {
        exit(-1);
    }
}

int open (const char *file){ //returns fd or -1 if not successful
    if (file && check_address(file)){
        struct thread *curr = thread_current();
        struct file *open_file;
        // printf("---file: %s\n", file);

        open_file = filesys_open(file); // file pointer return. 배열의 빈자리에 *file 넣어주고 해당 index return실패시 -1
        if (open_file!=NULL){
            // // allocate fd
            // int fd=2;
            // while(!curr->fd_available[fd] && fd<MAX_FILE){
            //     fd++;
            // }
            // if (fd==MAX_FILE){
            //     return -1;
            // }

            // create fd_elem
            struct file_descriptor *fd_entry = (struct file_descriptor *)malloc(sizeof(struct file_descriptor));
            fd_entry->fd = curr->next_fd;
            fd_entry->file = open_file;

			curr->next_fd++; //increment next_fd by 1 
            // curr->fd_available[fd]=false;
            // put into fd_table
            list_push_back(&curr->fd_table, &fd_entry->elem);
            return fd_entry->fd;
        } 
        return -1; //open failed
    } else { 
        exit(-1); // call not valid
    }

}

void close (int fd){
    if (fd>1 && fd<MAX_FILE){
		struct list_elem *fd_elem =	find_fd_elem(fd);
		if (fd_elem){
			struct file_descriptor* fd_entry = list_entry(fd_elem, struct file_descriptor, elem);
			file_close(fd_entry->file);
			list_remove(&fd_entry->elem);
			free(fd_entry);
		}
		// // search through open file(s)
		// struct list_elem *fd_elem;
		// if(!list_empty(&curr->fd_table)){
		// 	fd_elem=list_begin(&curr->fd_table);
		// 	//close files and free fd_table // TODO: close refactoring
		// 	while(fd_elem!=list_end(&curr->fd_table)){
		// 		struct file_descriptor *fd_entry = list_entry(fd_elem, struct file_descriptor, elem);
		// 		if (fd_entry->file==fd){
		// 			file_close(fd_entry->file);
		// 		}
		// 		struct list_elem *next_fd_elem = fd_elem->next;
		// 		list_remove(&fd_entry->elem);
		// 		free(fd_entry);
		// 		fd_elem = next_fd_elem;
		// 		break;
		// 	}
		// }
    }
    return;
}



//return fd_elem for the given fd (NULL if failed)
struct list_elem* find_fd_elem(int fd){
	struct thread *curr = thread_current();
    if (fd>1){
		// search through fd_table
		struct list_elem *fd_elem;
		if(!list_empty(&curr->fd_table)){
			fd_elem=list_begin(&curr->fd_table);
			while(fd_elem!=list_end(&curr->fd_table)){
				// struct file_descriptor *fd_entry = list_entry(fd_elem, struct file_descriptor, elem);
				// if (fd_entry->file==fd){
				// 	return fd_elem;
				// }
				if( list_entry(fd_elem, struct file_descriptor, elem)->fd==fd)
					return fd_elem;
			}
		}
    }
    return NULL;
}

int filesize(int fd){
	struct list_elem *fd_elem =	find_fd_elem(fd);
	struct file *target_file = list_entry(fd_elem, struct file_descriptor, elem)->file;
	return file_length(target_file);

}

int read (int fd, void *buffer, unsigned size)
{
	//is lock implemented in
/* 파일에 동시 접근이 일어날 수 있으므로 Lock 사용 */
/* 파일 디스크립터를 이용하여 파일 객체 검색 */
/* 파일 디스크립터가 0일 경우 키보드에 입력을 버퍼에 저장 후
버퍼의 저장한 크기를 리턴 (input_getc() 이용) */
/* 파일 디스크립터가 0이 아닐 경우 파일의 데이터를 크기만큼 저
장 후 읽은 바이트 수를 리턴 */
}

int write(int fd, void *buffer, unsigned size)
{
/* 파일에 동시 접근이 일어날 수 있으므로 Lock 사용 */
/* 파일 디스크립터를 이용하여 파일 객체 검색 */
/* 파일 디스크립터가 1일 경우 버퍼에 저장된 값을 화면에 출력
후 버퍼의 크기 리턴 (putbuf() 이용) */
/* 파일 디스크립터가 1이 아닐 경우 버퍼에 저장된 데이터를 크기
만큼 파일에 기록후 기록한 바이트 수를 리턴 */
}










/* --- helper functions defined ---*/
/* check address validity */
// check if the pointer points below PHYS_BASE ??
static bool
check_address(void *addr) {
	if (is_kernel_vaddr(addr) || pml4_get_page(thread_current()->pml4, addr) == NULL) {
		// printf("address is in kernel or not allocated");
		return false;
	}
	// printf("check_address: valid user address");
	return true;
}

// kernel: 32bit, user: 64bit?

/* pass args in userstack to kernel */
void get_argument(void *esp, int *arg, int count){
	//get file name
	int *user_stack = (int *)esp;

	for (int i=0; i<count; i++){
		arg[i] = user_stack[i];
	}
	//get file size

}



// check the validity of a user-provided pointer



// a process can hold a lock and ask for malloc -> 그치...똑같은 메모리 동시에 할당하면 안되니까....
// before terminating process it has to fee resources it is holding


// get_user
// put_user
