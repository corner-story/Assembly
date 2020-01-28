assume cs:code, ds:data, ss:stack

data segment 
    dw 0123H, 0456H, 0789H, 0ABCH, 0DEFH, 0FEDH, 0CBAH, 0987H
data ends

stack segment 
    dw 0, 0, 0, 0, 0, 0, 0, 0
stack ends


code segment 
start:
    ; 设置栈寄存器
    mov ax, stack
    mov ss, ax
    mov sp, 10H

    ; 设置数据寄存器
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



; 程序返回前, data中的数据： 和data段中的一样

; 程序返回前 cs= 076CH , ss= 076BH , ds=076AH 

; 设程序加载后, code段的段地址为 x， 则 data段的段地址为: x-2 , stack的段地址为: x-1 