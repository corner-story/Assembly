assume cs:code

code segment
start:
    mov ax, 0B800H
    mov es, ax
    mov si, 12*80*2

    mov ah, 2
    mov al, '!'
    mov bx, offset s - offset finish
    mov cx, 80

s:
    mov es:[si], ax
    add si, 2
    int 7cH
finish:
    mov ax, 4c00H
    int 21H
code ends

end start