assume cs:code

data segment
    db "lambdafate", 0
data ends

code segment
start:
    mov ax, data
    mov ds, ax
    mov si, 0

    mov ax, 0B800H
    mov es, ax
    mov di, (12*80+36)*2
    mov ah, 00000100b
    mov bx, offset s - offset finish
s:
    mov al, ds:[si]
    cmp al, 0
    je finish

    mov es:[di], ax
    inc si
    add di, 2
    int 7cH
finish:
    mov ax, 4c00H
    int 21H

code ends

end start