assume cs:code

; 在屏幕中央 12, 40显示A-Z
code segment
start:

    mov ax, 0B800H
    mov es, ax
    mov di, (12*80+40)*2

    mov ah, 2
    mov al, 'A'
dislpay:
    mov es:[di], ax
    call delay
    cmp al, 'Z'
    je display_end
    inc al
display_end:

    mov ax, 4c00H
    int 21H

delay:
    push dx
    push ax

    mov dx, 0100H
    mov ax, 0000H
delay_begin:
    dec ax
    sbb dx, 0

    cmp ax, 0
    jne delay_begin
    cmp dx, 0
    jne delay_begin

    pop ax
    pop dx
    ret
code ends

end start