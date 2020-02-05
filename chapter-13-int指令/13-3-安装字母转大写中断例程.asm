assume cs:code 

; 字母转大写

code segment
start:
    mov ax, cs
    mov ds, ax
    mov si, offset IntLetterc

    mov ax, 0000H
    mov es, ax
    mov di, 0200H

    cld
    mov cx, offset finish - offset IntLetterc
    rep movsb

    mov word ptr es:[7cH*4+0], 0200H
    mov word ptr es:[7cH*4+2], 0000H

    mov ax, 4c00H
    int 21H

; ds:[si] 指向字符串首地址
IntLetterc:
    push cx
    push si

    mov ch, 0
int_begin:
    mov cl, ds:[si]
    jcxz int_end
    and byte ptr ds:[si], 11011111b
    
    inc si
    jmp short int_begin

int_end:
    pop si
    pop cx
    iret
finish:
    nop
code ends

end start