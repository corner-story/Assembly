assume cs:code, ds:data, ss:stack

data segment
    dw 0123H, 0456H
data ends

stack segment 
    dw 0, 0
stack ends


code segment 
start:
    mov ax, stack 
    mov ss, ax
    mov sp, 10H

    mov ax, data
    mov ds, ax

    push ds:[0]
    push ds:[2]

    pop ds:[2]
    pop ds:[0]

    mov ax, 4c00H
    int 21H

code ends

end start


; 程序返回前, data段中的数据: 和data段一样、

; 程序返回前 cs=076cH, ss=076bH, ds=076aH

; 设code段的段地址为X, 则data段的段地址为: x-2  , stack段的段地址: x-1

; 设一个段中的数据占N字节, 则程序加载后, 该段实际占有的空间为: 
; N%16 == 0  N
; N%16 != 0 (N//16+1)*16