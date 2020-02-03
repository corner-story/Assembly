assume cs:code

; jmp 16位寄存器
; (ip) = (register)


code segment
start:
    mov dx, 0
    mov ax, offset des
    jmp ax
    add dx, 1
    add dx, 2 
des:
    inc dx

    mov ax, 4c00H
    int 21H
code ends

end start