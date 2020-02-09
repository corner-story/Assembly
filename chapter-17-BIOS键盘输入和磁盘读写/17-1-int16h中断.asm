assume cs:code

code segment
start:
    mov ah, 0
    int 16H

    mov ah, 1
    cmp al, 'r'
    je red
    cmp al, 'g'
    je green
    cmp al, 'b'
    je blue
    jmp short return
red:
    shl ah, 1
green:
    shl ah, 1
blue:
    mov bx, 0B800H
    mov es, bx
    mov di, 1
    mov cx, 25*80
s:
    and byte ptr es:[di], 11111000b
    or es:[di], ah
    add di, 2
    loop s
return:
    mov ax, 4c00H
    int 21H
code ends

end start