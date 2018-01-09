;
; Test for read syscall
;

%define SYSCALL_CLASS_SHIFT             24
%define SYSCALL_CLASS_MASK              (0xFF << SYSCALL_CLASS_SHIFT)
%define SYSCALL_NUMBER_MASK             (~SYSCALL_CLASS_MASK)
%define SYSCALL_CLASS_UNIX              2
%define SYSCALL_CONSTRUCT_UNIX(syscall_number) \
            ((SYSCALL_CLASS_UNIX << SYSCALL_CLASS_SHIFT) | \
             (SYSCALL_NUMBER_MASK & (syscall_number)))

%define SYS_exit                        1
%define SYS_read                        3
%define SYS_open                        5
%define SYS_close                       6

; NASM directive, not compiled
; Use RIP-Relative addressing for x64
BITS    64
DEFAULT    REL

global _main

section .text

_main:
    ; open("/dev/zero", O_RDONLY);
	mov rax, SYSCALL_CONSTRUCT_UNIX(SYS_open)
	mov rdi, filename
	mov rsi, 0
	mov rdx, 0
	syscall
	mov r14, rax
    cmp rax, 2
    jle bad

    ; TOTAL_EXECS is passed by the build script
	mov r15, TOTAL_EXECS
    sub rsp, 4
		
read:
	; read(fd, &data, sizeof(data));
	mov rax, SYSCALL_CONSTRUCT_UNIX(SYS_read)
	mov rdi, r14
	mov rsi, rsp
	mov rdx, 4
	syscall

	cmp rax, 4 ; read should return 4
    jne bad

	dec r15
	jnz read
		
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

filename: db "/dev/zero", 0
.len: equ $ - filename
