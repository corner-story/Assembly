assume cs:code

data segment
    db "lambdafate", 0
data ends

code segment
start:
    mov ax, data
    mov ds, ax
    mov si, 0

    int 7cH

    or byte ptr ds:[si], 00100000b

    mov ax, 4c00H
    int 21H
code ends

end start
