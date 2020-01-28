assume cs:code

a segment 
    dw 1, 2, 3, 4, 5, 6, 7, 8, 9, 0ah, 0bh, 0ch, 0dh, 0eh, 0fh, 0ffh
a ends

b segment 
    dw 0, 0, 0, 0, 0, 0, 0, 0
b ends

code segment 
start:
    mov ax, b
    mov ss, ax
    mov sp, 10H
    
    mov ax, a
    mov ds, ax
    mov bx, 0

    mov cx, 8
s:  
    push ds:[bx]
    add bx, 02H
    loop s

    mov ax, 4c00H
    int 21H
code ends

end start 
