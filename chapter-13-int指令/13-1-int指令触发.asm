assume cs:code

code segment
start:
    mov ax, 0B800H
    mov es, ax
    mov si, (12*80+36)*2
    mov byte ptr es:[si], '!'

    int 00H

code ends

end start