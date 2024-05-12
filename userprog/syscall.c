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
#include "userprog/process.h"
#include "threads/synch.h"


void syscall_entry (void);
void syscall_handler (struct intr_frame *);

/* helper functions */
static bool check_address(void *addr);
void get_argument(void *esp, int *arg, int count);
struct list_elem* find_fd_elem(int fd); // returns corresponding fd_elem for the given fd

/* syscall handler functions */
void halt (void) NO_RETURN;
void exit (int status) NO_RETURN;
tid_t fork (const char *thread_name);
int exec (const char *file);
int wait (tid_t);
bool create (const char *file, unsigned initial_size);
bool remove (const char *file);
int open (const char *file);
int filesize (int fd);
int read (int fd, void *buffer, unsigned length);
int write (int fd, const void *buffer, unsigned length);
void seek (int fd, unsigned position);
unsigned tell (int fd);
void close (int fd);

int dup2(int oldfd, int newfd);






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
	if (!check_address((f->rsp))) //stack pointer가 유저영역인지 확인
		thread_exit();

	switch(f->R.rax) // R: general purpose register, userstack에 저장되어있는 시스템 콜 넘버
	{
		case SYS_HALT:
			halt();
			break;
		case SYS_EXIT:
			exit((int)f->R.rdi);
			// thread_exit();
			break;
		case SYS_FORK:
			memcpy(&thread_current()->parent_tf, f, sizeof(struct intr_frame));
			f->R.rax = fork(f->R.rdi);
			break;
		case SYS_EXEC:
			f->R.rax = exec(f->R.rdi);
			break;
		case SYS_WAIT:
			f->R.rax = wait(f->R.rdi);
			break;
		case SYS_TELL:
			// wait
			break;
		case SYS_SEEK:
			// wait
			break;

		case SYS_CREATE:
			f->R.rax = create(f->R.rdi, f->R.rsi); //filename, count
			break;
		case SYS_REMOVE:
			f->R.rax = remove(f->R.rdi);
			break;

		case SYS_OPEN:
			f->R.rax = open(f->R.rdi);
			break;
		case SYS_FILESIZE:
			f->R.rax = filesize(f->R.rdi);
			break;
		case SYS_CLOSE:
			close(f->R.rdi);
			break;
		case SYS_READ:
			f->R.rax = read(f->R.rdi, f->R.rsi, f->R.rdx);
			break;
		case SYS_WRITE:
			f->R.rax = write(f->R.rdi, f->R.rsi, f->R.rdx);
			break;
		default:
			thread_exit();
	}
	// printf("syscall returned successfully\n");
	// printf("f.Rax %d\n",f->R.rax);
}


/* syscall functions definition */

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
	//something wrong
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

		lock_acquire(&filesys_lock);
        open_file = filesys_open(file); // file pointer return. 배열의 빈자리에 *file 넣어주고 해당 index return실패시 -1
        if (open_file!=NULL){

            // create fd_elem
            struct file_descriptor *fd_entry = (struct file_descriptor *)malloc(sizeof(struct file_descriptor));
            fd_entry->fd = curr->next_fd;
            fd_entry->file = open_file;

			curr->next_fd++; //increment next_fd by 1 
            // curr->fd_available[fd]=false;
            // put into fd_table
            list_push_back(&curr->fd_table, &fd_entry->elem);
			lock_release(&filesys_lock);
            return fd_entry->fd;
        }
		lock_release(&filesys_lock);
        return -1; //open failed
    } else { 
        exit(-1); // call not valid
    }

}

void close (int fd){
    if (fd>1 && fd<MAX_FILE){
		lock_acquire(&filesys_lock);
		struct list_elem *fd_elem =	find_fd_elem(fd);
		if (fd_elem){
			struct file_descriptor* fd_entry = list_entry(fd_elem, struct file_descriptor, elem);
			file_close(fd_entry->file);
			list_remove(&fd_entry->elem);
			free(fd_entry);
			lock_release(&filesys_lock);
			return;
		}
    }
    exit(-1);
}


int filesize(int fd){  
	if (fd>1){
		struct list_elem *fd_elem =	find_fd_elem(fd);
		if (fd_elem){
			struct file *target_file = list_entry(fd_elem, struct file_descriptor, elem)->file;
			return file_length(target_file);
		} else {
			return -1;
		}
	} else {
		exit(-1);
	}
}

/* read size bytes from the file open as fd into buffer */
int read (int fd, void *buffer, unsigned size)
{
	if (buffer && check_address(buffer)){
		lock_acquire(&filesys_lock);
		if (fd==0){ //read input from keyboard -> do I have to implement synchronization??
			int read_size = 0;
			char *temp_buf = buffer;
			for (int i=0; i<size;i++){
				*temp_buf = input_getc();
				read_size++;
				if (*temp_buf == '\0')
					break;
				temp_buf++;
			}
			lock_release(&filesys_lock);
			return read_size;
		} else {
			struct list_elem *fd_elem =	find_fd_elem(fd);
			if (fd_elem){
				struct file *file = list_entry(fd_elem, struct file_descriptor, elem)->file;
				lock_release(&filesys_lock);
				return file_read(file, buffer, size);
			} 
			lock_release(&filesys_lock);
			return -1; //failed to read file associated with the given fd

		}

	} else {
		exit(-1);
	}
}

int write (int fd, const void *buffer, unsigned size)
{
	if (buffer && check_address(buffer)){
		int write_size = 0;
		lock_acquire(&filesys_lock);

		if(fd==1){ //stdout case -> print to console
			putbuf(buffer, size);
			write_size = size;
		} else {
			struct list_elem *fd_elem =	find_fd_elem(fd);
			if (fd_elem){
				struct file *file = list_entry(fd_elem, struct file_descriptor, elem)->file;
				write_size = file_write(file, buffer, size);
			} else {
				lock_release(&filesys_lock);
				return -1;
			}
		}
		lock_release(&filesys_lock);
		return write_size;
	} else {
		exit(-1);
	}

}


tid_t fork (const char *thread_name){
	if (!check_address(thread_name))
		exit(-1);
	lock_acquire(&filesys_lock);
	tid_t  child_tid = process_fork(thread_name, &thread_current()->parent_tf);
	lock_release(&filesys_lock);
	if (child_tid ==TID_ERROR){
		return -1;
	} else if (child_tid==0){ //child process
		return 0;
	} else {
		return child_tid;
	}
}


/* waits for child(tid) to exit and retreive the child's exit status. */
int wait (tid_t child_tid)
{	
	int result = process_wait(child_tid);

	if (result<0)
		return result;

	// search for child thread and sema_down on sema_wait
	struct list_elem *child = list_begin(&thread_current()->child_list);
	struct thread *child_t;
	while (child){
		child_t = list_entry(child, struct thread, child_elem);
		if (child_t->tid==child_tid){
			break;
		}
		child = child->next;
	}
	// sema_down(&child_t->sema_wait);	
	return result;
}


int exec (const char *file)
{

}

void seek (int fd, unsigned position){

}

unsigned tell (int fd){

}







/* --- helper functions defined ---*/
/* check address validity: is in userland? */
static bool
check_address(void *addr) {
	if (is_kernel_vaddr(addr) || pml4_get_page(thread_current()->pml4, addr) == NULL) {
		// printf("address is in kernel or not allocated");
		return false;
	}
	// printf("check_address: valid user address");
	return true;
}


/* find fd_elem of of an open file associated with the given fd */
/* returns null if no open file is found */
struct list_elem* find_fd_elem(int fd)
{
	struct thread *curr = thread_current();
    if (fd>1){
		// search through fd_table
		struct list_elem *fd_elem;
		if(!list_empty(&curr->fd_table)){
			fd_elem=list_begin(&curr->fd_table);
			while(fd_elem!=list_end(&curr->fd_table)){
				if( list_entry(fd_elem, struct file_descriptor, elem)->fd==fd)
					return fd_elem;
			}
		}
    }
    return NULL;
}
