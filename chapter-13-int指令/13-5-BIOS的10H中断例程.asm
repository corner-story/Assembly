assume cs:code

code segment
start:
    ; 设置光标位置
    mov ah, 2
    mov bh, 0
    mov dh, 20
    mov dl, 36
    int 10H

    ; 在光标处显示字符串
    mov ah, 9
    mov al, 't'
    mov bh, 0
    mov bl, 00000100b
    mov cx, 6
    int 10H

    mov ax, 4c00H
    int 21H
code ends

end start