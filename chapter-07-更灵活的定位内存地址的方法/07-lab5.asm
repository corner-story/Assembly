assume cs:code
; 将data段中的前三个字母改为大写

stack segment
    dw 0, 0, 0, 0, 0, 0, 0, 0, 0
stack ends

data segment
    db "1. display      "
    db "2. brows        "
    db "3. replace      "
    db "4. modify       "
data ends

code segment
start:
    mov ax, stack
    mov ss, ax
    mov sp, 10H

    mov ax, data
    mov ds, ax

    mov bx, 0
    mov cx, 4
s0: 
    push cx
    mov si, 3
    mov cx, 3
s1: 
    mov al, ds:[bx+si]
    and al, 11011111b
    mov ds:[bx+si], al
    inc si
    loop s1

    add bx, 10H
    pop cx
    loop s0

    mov ax, 4c00H
    int 21H
code ends


end start