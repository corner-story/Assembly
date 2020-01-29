assume cs:code

; 使用 两层循环 + 栈 完成lab2

data segment 
    db "ibm     "
    db "des     "
    db "dos     "
    db "vax     "
data ends

stack segment
    dw 0, 0, 0, 0, 0, 0, 0, 0
stack ends

code segment
start:
    mov ax, stack
    mov ss, ax
    mov sp, 10H

    mov ax, data
    mov ds, ax

    mov bx, 0
    mov cx, 4
s0: 
    push cx                           ; 外层循环
    mov si, 0                         ; 进入内层循环时先保存cx, 使用栈
    mov cx, 3
s1: 
    mov al, ds:[bx+si]
    and al, 11011111b
    mov ds:[bx+si], al
    inc si
    loop s1

    add bx, 8                        ; 外层循环变量
    pop cx                           ; 从栈中恢复cx
    loop s0

    mov ax, 4c00H
    int 21H
code ends

end start