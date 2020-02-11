assume cs:code
; a mini os

code segment
start:
    mov ax, 0B800H
    mov ds, ax
    mov si, (12*80+38)*2

    mov ah, 2
    mov al, 'Y'

    mov ds:[si], ax
    
    jmp $

    org 510
    db 0, 0
code ends

end start