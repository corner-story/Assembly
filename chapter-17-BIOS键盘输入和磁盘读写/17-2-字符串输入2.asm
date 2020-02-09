assume cs:code

data segment
    db 128 dup (0)
data ends

stack segment
    db 256 dup (0)
stack ends

code segment
start:
    mov ax, stack
    mov ss, ax
    mov sp, 256

    mov ax, data
    mov ds, ax
    mov si, 0

    mov dh, 12
    mov dl, 20

    call getchar
    
    mov ax, 4c00H
    int 21H


; 获取键盘输入
getchar:
    push ax
input:
    mov ah, 0
    int 16H

    ; 控制字符, 重新输入
    cmp al, 20H
    jb nochar
    ; 删除DEL键
    ; cmp al, 7FH
    ; je delete
    ; 普通字符
    jmp short chars

nochar:
    cmp al, 0DH
    je _enter
    cmp al, 08H
    je delete
    jmp input

_enter:
    mov ax, 0
    call charstack
    jmp eof

delete:
    mov ah, 1
    call charstack
    jmp input

chars:
    mov ah, 0
    call charstack
    jmp input 

eof:
    pop ax
    ret



; 入栈, 出栈, 显示字符串
charstack:
    jmp short charstart
    table dw charpush, charpop, chardisplay
    top   dw 0
charstart:
    push ax
    push bx 
    push dx
    push es
    push di

    cmp ah, 2
    ja charreturn

    mov bl, ah
    mov bh, 0
    add bx, bx
    ; 这里应该使用jmp, 不用ret
    jmp word ptr table[bx]

; al=入栈字符
charpush:
    mov bx, top
    mov ds:[si+bx], al
    inc word ptr top
    jmp chardisplay


; al=出栈字符
charpop:
    mov bx, top
    cmp bx, 0
    je charreturn
    dec bx
    mov al, ds:[si+bx]
    mov top, bx
    jmp chardisplay

; dh=行号, dl=列号
; ds:si=字符串存储地址
chardisplay:
    mov ax, 0B800H
    mov es, ax
    ; 计算显示的位置
    mov al, dh
    mov dh, 160
    mul dh
    mov dh, 0
    add dx, dx
    add ax, dx
    mov di, ax

    mov ah, 2
    mov bx, 0
beginshow:
    cmp bx, top
    jb showchars
    mov byte ptr es:[di], ' '
    jmp charreturn
showchars:
    mov al, ds:[si+bx]
    mov es:[di], ax
    inc bx
    add di, 2
    jmp beginshow

charreturn:
    pop di
    pop es
    pop dx
    pop bx
    pop ax
    ret


code ends

end start