assume cs:code

data segment
    db 0, 0, 0
data ends

code segment
start:
    mov ax, data
    mov ds, ax
    mov bx, 0
    jmp word ptr ds:[bx+1]

    mov ax, 4c00H
    int 21H
code ends

end start

; jmp word ptr 内存地址
; (ip) = 内存地址中的数据