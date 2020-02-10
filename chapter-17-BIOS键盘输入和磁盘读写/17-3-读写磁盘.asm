assume cs:code
code segment

start:
    ; 缓冲区地址
    mov ax, 0B800H
    mov es, ax
    mov bx, (12*80+0)*2

    mov al, 1
    mov ch, 0
    mov cl, 1
    mov dh, 0

    ; 驱动器
    mov dl, 00H
    mov ah, 02H
    int 13H

    mov al, 'Y'
    cmp ah, 0
    je result
    mov al, 'N'
result:
    mov ah, 2
    mov es:[(8*80+40)*2], ax

loopforver:
    jmp loopforver    

    org 510
    db  55H, 0aaH
code ends


end start