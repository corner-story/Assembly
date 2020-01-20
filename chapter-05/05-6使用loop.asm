assume cs:cscodes
; cx中代表循环次数
; bx中代表偏移量

cscodes segment
    ; 初始化数据寄存器
    mov ax, 0020H
    mov ds, ax

    ; 初始化内存单元
    ; 不能直接把立即数移进内存, 因为不知立即数是字节还是字
    mov al, 2
    mov ds:[0], al
    mov ds:[1], al
    mov ds:[2], al

    mov bx, 0 ; 初始化偏移量
    mov dx, 0 ; 初始化数据结果
    mov cx, 3 ; 初始化循环次数

s:  mov al, [bx] ; 当使用[r]格式时不用显示指明段寄存器
    mov ah, 0
    add dx, ax
    inc bx
    loop s

    mov ax, 4c00H
    int 21H

cscodes ends


end