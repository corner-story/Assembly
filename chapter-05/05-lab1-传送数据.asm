assume cs:cscodes
; 向内存0:200-0:23f传送数据0-63
cscodes segment 
    mov ax, 0020H
    mov ds, ax

    mov bx, 0
    mov cx, 64
    mov dl, 0

s:  mov ds:[bx], dl
    inc dl
    inc bx
    loop s

    mov ax, 4c00H
    int 21H
cscodes ends

end