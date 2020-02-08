assume cs:code

code segment
start:
    mov ah, 3
    int 7cH

    mov ax, 4c00H
    int 21H
code ends

end start