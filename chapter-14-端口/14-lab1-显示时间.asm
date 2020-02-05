assume cs:code

code segment
year:   db "00/"
month:  db "00/"
day:    db "00 "
hour:   db "00:"
minute: db "00:"
second: db "00$"

display:
        dw offset year, offset month, offset day, offset hour, offset minute, offset second
position:
        db 9, 8, 7, 4, 2, 0

start:
    mov ax, cs
    mov ds, ax

loopforver:
    mov si, offset position
    mov di, offset display
    mov cx, 6
s:
    ; 计算对应项的ascii值
    mov al, ds:[si]

    ; 读取端口值
    out 70H, al
    in al, 71H

    mov ah, al
    push cx
    mov cl, 4
    shr al, cl
    and ah, 00001111b
    add ax, 3030H
    pop cx

    mov bx, ds:[di]
    mov ds:[bx], ax

    inc si
    add di, 2
    loop s

    ; 显示字符串
    mov bh, 0
    mov dh, 12
    mov dl, 32
    mov ah, 02H
    int 10H

    mov dx, 0
    mov ah, 09H
    int 21H

    jmp near ptr loopforver

    mov ax, 4c00H
    int 21H
code ends

end start