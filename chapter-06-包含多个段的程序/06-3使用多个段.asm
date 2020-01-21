assume cs:code, ds:data, ss:stack

data segment
    dw 1111H, 2222H, 3333H, 4444H
data ends

stack segment
    dw 0, 0, 0, 0
stack ends

code segment
start:
    ; 设置数据寄存器
    mov ax, data
    mov ds, ax

    ; 设置栈寄存器
    mov ax, stack
    mov ss, ax
    mov sp, 08H

    mov bx, 0
    mov cx, 4
s0: push ds:[bx]
    add bx, 2
    loop s0

    mov bx, 0
    mov cx, 4
s1: pop ds:[bx]
    add bx, 2
    loop s1

    mov ax, 4c00H
    int 21H
code ends

; 指明程序运行入口
end start   

