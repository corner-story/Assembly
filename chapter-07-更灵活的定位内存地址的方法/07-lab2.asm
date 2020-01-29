assume cs:code

data segment
    db "ibm     "
    db "des     "
    db "dos     "
    db "vax     "
data ends

code segment
start:
    mov ax, data
    mov ds, ax

    mov si, 0
    mov cx, 4
s:
    mov ax, ds:[si]
    and ah, 11011111b
    and al, 11011111b
    mov ds:[si], ax

    mov al, ds:[si+2]
    and al, 11011111b
    mov ds:[si+2], al

    add si, 8
    loop s

    mov ax, 4c00H
    int 21H
code ends

end start