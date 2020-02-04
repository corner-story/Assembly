assume cs:code

code segment
start:
    ; ds:[si] => es:[di]
    mov ax, cs
    mov ds, ax
    mov si, offset Interrupt0

    mov ax, 0H
    mov es, ax
    mov di, 0200H

    ; 在0000:0200H处设置0号中断处理程序
    ; 设置DF正向传送
    cld
    mov cx, offset finish - offset Interrupt0
    rep movsb
    
    ; 设置中断向量
    mov word ptr es:[0*4+0], 0200H
    mov word ptr es:[0*4+2], 0000H

    mov ax, 4c00H
    int 21H

Interrupt0:
    jmp short Interrupt0_begin
    db "Divide error!"

Interrupt0_begin:
    mov ax, 0000H
    mov ds, ax
    mov si, 0202H

    mov ax, 0B800H
    mov es, ax
    mov di, (12*80+33)*2

    mov ah, 00000100b
    mov cx, 13
s:
    mov al, ds:[si]
    mov es:[di], ax
    inc si
    add di, 2
    loop s
    
    mov ax, 4c00H
    int 21H
finish:
    nop
code ends

end start