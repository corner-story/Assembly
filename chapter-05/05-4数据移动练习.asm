assume cs:cscodes
; 将2000:0 2000:1 2000:2 2000:3中的内容送到寄存器
; note: [i] 和 ds:[i] 在dos中是不一样的, 前者为立即数

cscodes segment
    ; 初始化寄存器
    mov ax, 2000H
    mov ds, ax

    mov al, ds:[0]
    mov ah, ds:[1]
    mov bl, ds:[2]
    mov bh, ds:[3]

    ; 程序退出
    mov ax, 4c00H
    int 21H

cscodes ends

end