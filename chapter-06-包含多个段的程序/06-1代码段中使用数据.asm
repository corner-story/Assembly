assume cs:code
; 在代码段中使用数据

code segment
    ; define word 定义字型数据 
    dw 0001H, 0002H, 0003H, 0004H

start:   
    mov bx, 0
    mov ax, 0
    mov cx, 4
s:  add ax, cs:[bx]
    add bx, 2
    loop s

    mov ax, 4c00H
    int 21H
code ends
; 使用end:name来设置cs:ip, 即设置开始执行的ip
end start
