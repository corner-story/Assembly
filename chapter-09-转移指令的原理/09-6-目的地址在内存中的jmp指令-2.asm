assume cs:code

data segment
    dd 12345678H
data ends

code segment
start:  
    mov ax, data
    mov ds, ax
    mov bx, 0
    mov ds:[bx], bx
    mov ds:[bx+2], cs

    jmp dword ptr ds:[0]

    mov ax, 4c00H
    int 21H
code ends

end start

; jmp dword ptr abcd
; cs=cd, ip=ab