assume cs:code

; si和di的作用和bx相同, 可以用做偏移寄存器
; si和di不能用作8位寄存器

data segment 
    db "welcome to masm!"
    db "################"
data ends

code segment
start:
    mov ax, data
    mov ds, ax

    mov si, 0
    mov cx, 8
s:  
    mov ax, [si]
    mov [si+16], ax

    add si, 2
    loop s


    mov ax, 4c00H
    int 21H
code ends

end start