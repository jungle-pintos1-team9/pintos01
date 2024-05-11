#ifndef USERPROG_SYSCALL_H
#define USERPROG_SYSCALL_H

//global lock
static struct lock filesys_lock;

void syscall_init (void);

#endif /* userprog/syscall.h */
