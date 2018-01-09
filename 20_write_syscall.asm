;
; Test for write syscall
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
%define SYS_open                        5
%define SYS_close                       6

BITS    64
DEFAULT    REL

global _main

section .text

_main:

	; r14 = open("/dev/null", O_WRONLY)
	mov rax, SYSCALL_CONSTRUCT_UNIX(SYS_open)
	mov rdi, filename
	mov rsi, 1
	mov rdx, 0
	syscall
	mov r14, rax
	cmp rax, 2
    jle bad

	sub rsp, 4
	mov DWORD [rsp], 0
	mov r15, TOTAL_EXECS
		
write:
	; write(fd, &data, sizeof(data));
	mov rax, SYSCALL_CONSTRUCT_UNIX(SYS_write)
	mov rdi, r14
	mov rsi, rsp
	mov rdx, 4
	syscall
	cmp rax, 4 ; should return 4
    jne bad

	dec r15
	jnz write
		
	; close(fd)
	mov rax, SYSCALL_CONSTRUCT_UNIX(SYS_close)
	mov rdi, r14
	syscall
    
    ; exit(0)
    xor rdi, rdi
    jmp exit

bad:
    ; exit(1)
    mov rdi, 1
exit:
    ; exit()
    mov rax, SYSCALL_CONSTRUCT_UNIX(SYS_exit)
    syscall

section .data

filename: db "/dev/null", 0
.len: equ $ - filename
