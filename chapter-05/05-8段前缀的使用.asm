assume cs:cscodes

; 使用段前缀

cscodes segment
    mov ax, 0020H
    mov ds, ax

    mov ds:[0], al
    mov ds:[1], al
    mov ds:[2], al

    mov ax, 0021H
    mov es, ax

    mov bx, 0
    mov cx, 3

s:  mov al, ds:[bx]
    mov es:[bx], al
    inc bx
    loop s

    mov ax, 4c00H
    int 21H
cscodes ends

end