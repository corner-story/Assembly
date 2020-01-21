assume cs:code
; 在代码段中使用栈把数据翻转

code segment
    dw 1111H, 2222H, 3333H, 4444H
    dw 0, 0, 0, 0  ;定义栈空间

start:
    mov ax, cs
    mov ss, ax

    mov sp, 10H
    mov bx, 0

    mov cx, 4
s0: push cs:[bx]
    add bx, 2
    loop s0

    mov bx, 0
    mov cx, 4

s1: pop cs:[bx]
    add bx, 2
    loop s1

    mov ax, 4c00H
    int 21H

code ends

end start