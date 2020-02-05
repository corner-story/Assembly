assume cs:code 

code segment
start:
    mov ax, cs
    mov ds, ax
    mov si, offset IntDisplay

    mov ax, 0000H
    mov es, ax
    mov di, 0200H

    cld
    mov cx, offset finish - offset IntDisplay
    rep movsb

    mov word ptr es:[7cH*4+0], 0200H
    mov word ptr es:[7cH*4+2], 0000H

    mov ax, 4c00H
    int 21H

; ds:[si] 字符串首地址
; dh 行号, dl 列号
; cl 颜色
IntDisplay:
    push ax
    push bx
    push es
    push di
    push si


    ; 计算要显示的地址并设置寄存器 es:[di]
    mov al, dh
    mov ah, 160
    mul ah
    mov bx, ax
    mov al, dl
    mov ah, 2
    mul ah
    add bx, ax
    mov ax, 0B800H
    mov es, ax
    mov di, bx

    mov ah, cl
int_begin:
    mov al, ds:[si]
    cmp al, 0
    je int_end
    mov es:[di], ax
    inc si
    add di, 2
    jmp short int_begin
int_end:
    pop si
    pop di
    pop es
    pop bx
    pop ax
    iret
finish:
    nop
code ends

end start