;
; Test for the lseek syscall
;

%define SYSCALL_CLASS_SHIFT             24
%define SYSCALL_CLASS_MASK              (0xFF << SYSCALL_CLASS_SHIFT)
%define SYSCALL_NUMBER_MASK             (~SYSCALL_CLASS_MASK)
%define SYSCALL_CLASS_UNIX              2
%define SYSCALL_CONSTRUCT_UNIX(syscall_number) \
            ((SYSCALL_CLASS_UNIX << SYSCALL_CLASS_SHIFT) | \
             (SYSCALL_NUMBER_MASK & (syscall_number)))

%define SYS_exit                        1
%define SYS_open                        5
%define SYS_close                       6
%define SYS_lseek                       199

BITS    64
DEFAULT    REL

global _main

section .text

_main:

	; r14 = open("/tmp/lseek_test_file", O_WRONLY)
	mov rax, SYSCALL_CONSTRUCT_UNIX(SYS_open)
	mov rdi, filename
	mov rsi, 0
	mov rdx, 0
	syscall
	mov r14, rax
	cmp rax, 2
    jle bad

	sub rsp, 4
	mov DWORD [rsp], 0
	mov r15, TOTAL_EXECS
	
lseek:
	; lseek(fd, 4, SEEK_SET);
	mov rax, SYSCALL_CONSTRUCT_UNIX(SYS_lseek)
	mov rdi, r14
	mov rsi, 4
	mov rdx, 0
	syscall
    
    cmp rax, 4
    jne bad

    mov rax, SYSCALL_CONSTRUCT_UNIX(SYS_lseek)
    mov rdi, r14
    mov rsi, 0
    mov rdx, 0
    syscall
    
    test rax, rax
    jnz bad
		
	dec r15
	jnz lseek

	; close(fd)
	mov rax, SYSCALL_CONSTRUCT_UNIX(SYS_close)
	mov rdi, r14
	syscall
    ; exit(0)
    xor rdi, rdi
    jmp exit

bad:
    mov rdi, 1
exit:		
    ; exit()
    mov rax, SYSCALL_CONSTRUCT_UNIX(SYS_exit)
    syscall

section .data

filename: db "/tmp/lseek_test_file", 0
.len: equ $ - filename
