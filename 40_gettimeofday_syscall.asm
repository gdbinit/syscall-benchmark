;
; Test for gettimeofday syscall
;

%define SYSCALL_CLASS_SHIFT             24
%define SYSCALL_CLASS_MASK              (0xFF << SYSCALL_CLASS_SHIFT)
%define SYSCALL_NUMBER_MASK             (~SYSCALL_CLASS_MASK)
%define SYSCALL_CLASS_UNIX              2
%define SYSCALL_CONSTRUCT_UNIX(syscall_number) \
            ((SYSCALL_CLASS_UNIX << SYSCALL_CLASS_SHIFT) | \
             (SYSCALL_NUMBER_MASK & (syscall_number)))

%define SYS_exit                        1
%define SYS_gettimeofday                116

BITS 64
DEFAULT REL

global _main

section .text

_main:
    ; sizeof(struct timeval) = 16
	sub rsp, 0x10
	mov r15, TOTAL_EXECS
	
gettime:
    ; gettimeofday(struct timeval *restrict tp, void *restrict tzp);
    mov rax, SYSCALL_CONSTRUCT_UNIX(SYS_gettimeofday)
    mov rdi, rsp
    mov rsi, 0
    syscall
    test rax, rax
    jnz bad

	dec r15
	jnz gettime
    
    xor rdi, rdi
    jmp exit
bad:
    mov rdi, 1
exit:		
    ; exit(0)
    mov rax, SYSCALL_CONSTRUCT_UNIX(SYS_exit)
    syscall
