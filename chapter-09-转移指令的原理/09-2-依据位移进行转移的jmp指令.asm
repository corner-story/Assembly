assume cs:code

code segment
start:
    mov ax, 0
    jmp short des
    add ax, 1
des:
    inc ax

    mov ax, 4c00H
    int 21H
code ends

end start

; jmp short 标号  =>>> (ip) = (ip) + 8位的位移
; 位移是 标号的地址 - jmp指令后面一条指令的地址
; 和 jmp near ptr => (ip) = (ip) + 16位的位移