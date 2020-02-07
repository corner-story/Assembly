assume cs:code 

code segment
start:
    mov ax, cs
    mov ds, ax
    mov si, offset Int9

    mov ax, 0000H
    mov es, ax
    mov di, 0204H

    cld
    mov cx, offset Int9_finish - offset Int9
    rep movsb

    push es:[9*4]
    pop es:[0200H]
    push es:[9*4+2]
    pop es:[0200H+2]

    mov word ptr es:[9*4], 0204H
    mov word ptr es:[9*4+2], 0000H

    mov ax, 4c00H
    int 21H

Int9:
    push ax
    push cx
    push es
    push di
    
    in al, 60H

    pushf
    call dword ptr cs:[0200H]

    ; 检查是否为A的断码
    cmp al, 9EH
    jne Int9_end
    mov ax, 0B800H
    mov es, ax
    mov di, 0000H
    mov al, 'A'
    mov ah, 2
    mov cx, 25*80
s:
    mov es:[di], ax
    add di, 2
    loop s

Int9_end:
    pop di
    pop es
    pop cx
    pop ax
    iret
Int9_finish:
    nop
code ends


end start