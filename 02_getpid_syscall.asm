;
; Test calling getpid() via syscall                                   
;

%define SYSCALL_CLASS_SHIFT             24
%define SYSCALL_CLASS_MASK              (0xFF << SYSCALL_CLASS_SHIFT)
%define SYSCALL_NUMBER_MASK             (~SYSCALL_CLASS_MASK)
%define SYSCALL_CLASS_UNIX              2
%define SYSCALL_CONSTRUCT_UNIX(syscall_number) \
            ((SYSCALL_CLASS_UNIX << SYSCALL_CLASS_SHIFT) | \
             (SYSCALL_NUMBER_MASK & (syscall_number)))

%define SYS_exit                        1
%define SYS_write                       4
%define SYS_getpid                      20

BITS 64
DEFAULT REL

global _main

section .text

_main:
    ; TOTAL_EXECS is passed by the build script
    mov r15, TOTAL_EXECS

getpid:
    mov rax, SYSCALL_CONSTRUCT_UNIX(SYS_getpid)
    syscall

    dec r15
    jnz getpid

    ; exit(0)
    xor rdi, rdi
    mov rax, SYSCALL_CONSTRUCT_UNIX(SYS_exit)
    syscall
