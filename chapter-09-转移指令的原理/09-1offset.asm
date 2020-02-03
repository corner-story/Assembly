assume cs:code

code segment
s0:
    mov ax, cs
    mov si, offset s0
    mov di, offset s1
    mov ax, cs:[si]
    mov cs:[di], ax
s1: 
    nop
    nop

    mov ax, 4c00H
    int 21H

code ends

end s0