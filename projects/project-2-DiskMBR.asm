assume cs:code
; mbr from hard disk
code segment
    jmp short start
    db "Hello, OS!", 0

start:
    mov ax, 0B800H
    mov es, ax

    mov ax, 07C0H
    mov ds, ax
    mov si, 2

    call clearscreen

    mov di, (12*80+36)*2
    mov ah, 2
    call showstr

    jmp $

; 显示字符串
; ds:si, 遇见0结束
; es:di, 要显示的位置
showstr:
_loopshowstr:
    mov al, ds:[si]
    cmp al, 0
    je _showreturn
    mov es:[di], ax
    inc si
    add di, 2
    jmp short _loopshowstr    
_showreturn:
    ret

; 清屏
clearscreen:
    mov di, 0
    mov cx, 4000
_loopclear:
    mov byte ptr es:[di], ' '
    add di, 2
    loop _loopclear
    ret

    org 510
    dw 0AA55H
code ends

end start