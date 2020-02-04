assume cs:code

data segment
    db 1, 8, 2, 4, 8, 21, 8, 38
data ends

code segment
start:
    mov ax, data
    mov ds, ax
    mov bx, 0
    mov ax, 0

    mov cx, 8
s:
    cmp byte ptr ds:[bx], 8
    jb s_if
    jmp short s_end
s_if:
    inc ax
s_end:
    inc bx
    loop s

    mov ax, 4c00H
    int 21H


code ends

end start