assume cs:code

code segment
start:
    mov ax, 8
    mov bx, 0

    ; 端口读
    out 70H, al
    in al, 71H

    mov ah, al

    mov cl, 4
    shr ah, cl

    and al, 00001111b

    mov bx, ax
    mov ax, 4c00H
    int 21H

code ends

end start