section .text
    global _start

_start:
    xor     rax, rax
    mov     rdi, binsh
    xor     rsi, rsi
    xor     rdx, rdx
    mov     rax, 59             ; execve syscall number
    syscall

section .data
binsh:
    db '/bin/sh', 0
