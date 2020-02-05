assume cs:code 

; 使用 int 7cH中断 实现 jmp near ptr 标号 的功能
; 并安装该程序

code segment
start:
    mov ax, cs
    mov ds, ax
    mov si, offset IntJmp

    mov ax, 0000H
    mov es, ax
    mov di, 0200H

    cld
    mov cx, offset finish - offset IntJmp
    rep movsb

    mov word ptr es:[7cH*4+0], 0200H
    mov word ptr es:[7cH*4+2], 0000H

    mov ax, 4c00H
    int 21H

; 实现jmp near ptr 标号
; bx:偏移地址
IntJmp:
    push bp
    mov bp, sp
    add ss:[bp+2], bx
    pop bp
    iret
finish:
    nop
code ends

end start