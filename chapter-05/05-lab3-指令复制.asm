assume cs:cscodes
; 将指令当做数据转移到另外一个段

cscodes segment 
    mov ax, cs
    mov ds, ax

    mov ax, 0020H
    mov es, ax

    mov bx, 0
    mov cx, 17H

s:  mov al, ds:[bx]
    mov es:[bx], al
    inc bx
    loop s

    mov ax, 4c00H
    int 21H
cscodes ends

end