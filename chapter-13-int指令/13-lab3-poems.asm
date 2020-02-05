assume cs:code

code segment
str1:    db "Good, better, best, ", '$'
str2:    db "Never let it rest, ", '$'
str3:    db "Till good is better, ", '$'
str4:    db "And beter, best!", '$'

poems:   dw offset str1, offset str2, offset str3, offset str4
rows:    db 4, 6, 8, 10

start:
    mov ax, cs
    mov ds, ax
    
    mov di, offset poems
    mov si, offset rows

    mov cx, 4
s:
    ; 设置光标位置
    mov bh, 0
    mov dh, ds:[si]
    mov dl, 30
    mov ah, 02H
    int 10H

    ; 显示字符串
    mov dx, ds:[di]
    mov ah, 09H
    int 21H

    inc si
    add di, 2

    loop s

    mov ax, 4c00H
    int 21H
code ends

end start