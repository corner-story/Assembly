assume cs:code

; 0000:007CH --> 0000:0200H

code segment
start:
    ; 设置ds:[si]
    mov ax, cs
    mov ds, ax
    mov si, offset IntSquare

    ; 设置es:[di]
    mov ax, 0
    mov es, ax
    mov di, 0200H

    ; 设置DF
    cld
    ; 循环次数
    mov cx, offset finish - offset IntSquare
    ; 装载7CH号中断处理程序
    rep movsb

    ; 安装
    mov word ptr es:[7CH*4+0], 0200H
    mov word ptr es:[7CH*4+2], 0000H

    mov ax, 4c00H
    int 21H

IntSquare:
    mul ax
    iret
finish:
    nop
code ends

end start