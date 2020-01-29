assume cs:code

data segment
    db "1. file     "
    db "2. edit     "
    db "3. search   "
    db "4. view     "
    db "5. options  "
    db "6. help     "  
data ends

code segment
start:
    mov ax, data
    mov ds, ax

    mov si, 0
    mov cx, 6
s:
    mov al, ds:[si+3]
    and al, 11011111b
    mov ds:[si+3], al

    add si, 12
    loop s

    mov ax, 4c00H
    int 21H
code ends

end start