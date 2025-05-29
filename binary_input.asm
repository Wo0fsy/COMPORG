section .data
    prompt      db "Enter a number (0 to quit): ", 0
    output_msg  db "Binary: ", 0
    newline     db 10, 0

section .bss
    input       resb 20
    binary_buf  resb 33    ; 32 bits + null terminator

section .text
    global _start

_start:
main_loop:
    ; Display prompt
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, 27
    int 0x80

    ; Read user input
    mov eax, 3
    mov ebx, 0
    mov ecx, input
    mov edx, 20
    int 0x80

    ; Null-terminate (replace newline)
    mov byte [ecx + eax - 1], 0

    ; Convert to integer
    mov ecx, input
    call str_to_int     ; EAX = input number

    ; Check for exit condition
    cmp eax, 0
    je exit

    ; Display "Binary: "
    mov eax, 4
    mov ebx, 1
    mov ecx, output_msg
    mov edx, 8
    int 0x80

    ; Convert and print binary
    push eax            ; Save number
    call print_binary
    pop eax

    ; Print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    jmp main_loop

; -------------------------------
; Convert string (in ECX) to integer (EAX)
str_to_int:
    xor eax, eax        ; Result
    xor ebx, ebx        ; Digit
    xor edx, edx        ; Sign flag
    mov bl, [ecx]
    cmp bl, '-'
    jne .parse
    inc ecx
    mov dl, 1           ; Set sign flag

.parse:
    mov bl, [ecx]
    cmp bl, 0
    je .done
    sub bl, '0'
    cmp bl, 9
    ja .done
    imul eax, eax, 10
    add eax, ebx
    inc ecx
    jmp .parse

.done:
    cmp dl, 1
    jne .finish
    neg eax
.finish:
    ret

; -------------------------------
; Convert EAX to binary string and print it
print_binary:
    mov edi, binary_buf + 32
    mov ecx, 32
    mov ebx, eax        ; Copy of number

.loop:
    dec edi
    shl ebx, 1
    jc .bit1
    mov byte [edi], '0'
    jmp .next

.bit1:
    mov byte [edi], '1'

.next:
    loop .loop

    ; Print binary_buf
    mov eax, 4
    mov ebx, 1
    mov ecx, binary_buf
    mov edx, 32
    int 0x80
    ret

; -------------------------------
exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80
