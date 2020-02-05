assume cs:code

data segment
    db "Hello, world!", "$"
data ends

code segment
start:

    ; 设置光标位置
    mov ah, 2
    mov bh, 0
    mov dh, 23
    mov dl, 78
    int 10H

    mov ax, data
    mov ds, ax
    mov dx, 0

    mov ax, 0900H
    int 21H

    mov ax, 4c00H
    int 21H
code ends

end start