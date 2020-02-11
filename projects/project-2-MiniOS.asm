assume cs:code
; a mini os

code segment
start:
    mov ax, 7A00H
    mov ss, ax
    mov sp, 0200H
    
    call clearscreen
    call showinfo

    jmp $

; 显示提示信息
showinfo:
    jmp near ptr showstart
_infos:
db    "######################## a mini os #########################", 0
db    "#                                                          #", 0
db    "#                   1) reset pc                            #", 0
db    "#                   2) start system                        #", 0
db    "#                   3) clock                               #", 0
db    "#                   4) set clock                           #", 0
db    "#                                                          #", 0
db    "############################################################", 0

showstart:
    push ax
    push bx
    push cx
    push ds
    push si
    push es
    push di

    mov ax, 07E0H
    mov ds, ax
    mov si, offset _infos

    mov ax, 0B800H
    mov es, ax
    mov di, (2*80+10)*2         ; 字符串显示的位置
    mov ah, 4
    mov cx, 8                   ; 一共显示的行数

_loopshow:
    call showstr
    add si, 60+1                ; 每行显示的字符数+1(最后的0)
    add di, 160         
    loop _loopshow

    ; 置光标
    mov bh, 0
    mov dh, 16
    mov dl, 40
    mov ah, 2
    int 10H

    pop di
    pop es
    pop si
    pop ds
    pop cx
    pop bx
    pop ax
    ret


; 显示字符串
; ds:si, 遇见0结束
; es:di, 要显示的位置
showstr:
    push ax
    push si
    push di

_loopshowstr:
    mov al, ds:[si]
    cmp al, 0
    je _showreturn
    mov es:[di], ax
    inc si
    add di, 2
    jmp short _loopshowstr    
_showreturn:
    pop di
    pop si
    pop ax
    ret


; 清屏
clearscreen:
    push ax
    push cx
    push es
    push di

    mov ax, 0B800H
    mov es, ax
    mov di, 0
    mov cx, 4000
_loopclear:
    mov byte ptr es:[di], ' '
    add di, 2
    loop _loopclear

    pop di
    pop es
    pop cx
    pop ax
    ret
code ends

end start