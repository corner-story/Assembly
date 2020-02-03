assume cs:code


code segment
start:  
    mov ax, 2000H
    mov ds, ax
    mov bx, 0

s:
    mov ch, 0
    mov cl, ds:[bx]
    jcxz des
    inc bx
    jmp short s

des:
    mov dx, bx
    mov ax, 4c00H
    int 21H
code ends

end start


; jcxz 标号
; if(cs == 0) jmp to 标号 else 执行下一条命令