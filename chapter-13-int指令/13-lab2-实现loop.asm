assume cs:code 

code segment
start:
    mov ax, cs
    mov ds, ax
    mov si, offset IntLoop

    mov ax, 0000H
    mov es, ax
    mov di, 0200H

    cld
    mov cx, offset finish - offset IntLoop
    rep movsb

    mov word ptr es:[7cH*4+0], 0200H
    mov word ptr es:[7cH*4+2], 0000H

    mov ax, 4c00H
    int 21H

; 实现loop的功能
; cx 循环次数, bx 位移偏移
IntLoop:
    dec cx
    cmp cx, 0
    je int_end

    push bp
    mov bp, sp
    add ss:[bp+2], bx
    pop bp
    
int_end:
    iret
finish:
    nop
code ends

end start