;
; Test for an empty function call
;

%define SYSCALL_CLASS_SHIFT             24
%define SYSCALL_CLASS_MASK              (0xFF << SYSCALL_CLASS_SHIFT)
%define SYSCALL_NUMBER_MASK             (~SYSCALL_CLASS_MASK)
%define SYSCALL_CLASS_UNIX              2

; call mask for 64 bit syscalls
%define SYSCALL_CONSTRUCT_UNIX(syscall_number) \
            ((SYSCALL_CLASS_UNIX << SYSCALL_CLASS_SHIFT) | \
             (SYSCALL_NUMBER_MASK & (syscall_number)))

%define SYS_exit                        1

BITS 64
DEFAULT REL

global _main

section .text

_main:
    ; TOTAL_EXECS is passed by the build script
    mov r15, TOTAL_EXECS
        
call_func:
    call func
        
    dec r15
    jnz call_func
        
    ; exit(0)
    xor rdi, rdi
    mov rax, SYSCALL_CONSTRUCT_UNIX(SYS_exit)
    syscall
    
func:
    push   rbp
    mov    rbp, rsp
    mov    rax, 0
    pop    rbp
    ret
