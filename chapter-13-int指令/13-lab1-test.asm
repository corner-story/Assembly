assume cs:code

data segment
    db "Hello world!", 0
data ends 

code segment
start:

    mov dh, 10
    mov dl, 10
    mov cl, 2

    mov ax, data
    mov ds, ax
    mov si, 0

    int 7cH

    mov ax, 4c00H
    int 21H
code ends

end start