assume cs:code

code segment
start:
    mov ah, 1
    mov al, 2
    int 7cH

    mov ax, 4c00H
    int 21H
code ends

end start