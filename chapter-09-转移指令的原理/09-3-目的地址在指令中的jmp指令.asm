assume cs:code

; jmp far ptr 标号
; 同时修改cs和ip寄存器

code segment
start:
    mov ax, 0
    jmp far ptr des
    db 256 dup (0)

des:
    inc ax

    mov ax, 4c00H
    int 21H
code ends

end start