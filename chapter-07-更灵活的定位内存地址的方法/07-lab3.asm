assume cs:code

; 使用两层循环完成lab2

data segment 
    db "ibm     "
    db "des     "
    db "dos     "
    db "vax     "
data ends

code segment
start:
    mov ax, data
    mov ds, ax

    mov bx, 0
    mov cx, 4
s0: 
    mov dx, cx                        ; 外层循环
    mov si, 0                         ; 进入内层循环时先保存cx
    mov cx, 3
s1: 
    mov al, ds:[bx+si]
    and al, 11011111b
    mov ds:[bx+si], al
    inc si
    loop s1

    add bx, 8                        ; 外层循环变量
    mov cx, dx                       ; 恢复cx
    loop s0

    mov ax, 4c00H
    int 21H
code ends

end start