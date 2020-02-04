assume cs:code

; 串传送指令
; movsb, movsw
; ds:[si] 传送到  es:[di]
; cld: DF=0, std: DF=1

data segment
    db "Welcome to masm!"
    db 16 dup (0)
    db 16 dup (0)
data ends

code segment
start:
    mov ax, data
    mov ds, ax
    mov es, ax
    mov si, 0
    mov di, 16

    ; 设置DF正向传送
    cld
    mov cx, 16
    rep movsb

    ; 设置DF反向传送
    std
    mov cx, 8
    mov si, 14
    mov di, 46
    rep movsw

    mov ax, 4c00H
    int 21H
code ends

end start