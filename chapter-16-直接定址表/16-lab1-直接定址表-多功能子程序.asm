assume cs:code 

code segment
start:
    mov ax, cs
    mov ds, ax
    mov si, offset INT7CH

    mov ax, 0
    mov es, ax
    mov di, 0200H
    
    cld
    mov cx, offset FINISH - offset INT7CH
    rep movsb

    mov word ptr es:[7ch*4], 0000H
    mov word ptr es:[7ch*4+2], 0020H

    mov ax, 4c00H
    int 21H

; ah=功能号
; ah=0, 清屏
; ah=1, 设置前景色, al=颜色属性
; ah=2, 设置背景色, al=属性
; ah=3, 向上滚动一行
INT7CH:
    jmp short begin
    table dw sub00, sub01, sub02, sub03
begin:
    push bx

    cmp ah, 3
    ja _end

    mov bh, 0
    mov bl, ah
    add bx, bx
    
    mov bx, cs:[2+bx]
    sub bx, offset INT7CH

    call bx
_end:
    pop bx
    iret

; 清屏
sub00:
    push ax
    push cx
    push es
    push di 

    mov ax, 0B800H
    mov es, ax
    mov di, 0
    mov cx, 25*80
sub00_s:
    mov byte ptr es:[di], ' '
    add di, 2
    loop sub00_s

    pop di
    pop es
    pop cx
    pop ax
    ret

; 设置前景色
sub01:
    push ax
    push bx
    push cx
    push es
    push di 

    cmp al, 7
    ja sub01_end
    mov bx, 0B800H
    mov es, bx
    mov di, 1
    mov cx, 25*80
sub01_s:
    and byte ptr es:[di], 11111000b
    or es:[di], al
    add di, 2
    loop sub01_s
sub01_end:
    pop di
    pop es
    pop cx
    pop bx
    pop ax
    ret

; 设置背景色
sub02:
    push ax
    push bx
    push cx
    push es
    push di 

    cmp al, 7
    ja sub02_end
    mov bx, 0B800H
    mov es, bx
    mov di, 1
    mov cx, 25*80

    shl al, 1
    shl al, 1
    shl al, 1
    shl al, 1
sub02_s:
    and byte ptr es:[di], 10001111b
    or es:[di], al
    add di, 2
    loop sub02_s
sub02_end:
    pop di
    pop es
    pop cx
    pop bx
    pop ax
    ret

; 向上滚动
sub03:
    push ax
    push cx
    push ds
    push si
    push es
    push di

    mov ax, 0B800H
    mov ds, ax
    mov si, (12*80+0)*2
    
    mov es, ax
    mov di, 0

    cld
    mov cx, 4000 - (12*80+0)*2
    rep movsb

    mov cx, (12*80+0)*2
sub03_s:
    mov byte ptr es:[di], ' '
    add di, 2
    loop sub03_s

    pop di
    pop es
    pop si
    pop ds
    pop cx
    pop ax
    ret

FINISH:
    nop
code ends

end start