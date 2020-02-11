assume cs:code

code segment
    jmp short start
errorinfo  db "boot error!"
start:
    
    mov ax, 07E0H
    mov es, ax     ; 目的地址
    mov bx, 0

    mov al, 1   ; 要读取的扇区数
    mov ch, 0   ; 柱面
    mov cl, 2   ; 扇区
    mov dh, 0   ; 磁头

    mov dl, 0   ; 驱动器
    mov ah, 2
    int 13H

    cmp ah, 0
    je bootsuccess
    mov ax, 0B800H
    mov ds, ax
    mov bx, (2*80+0)*2
    mov cx, 11
    mov si, 0
    mov ah, 4
showerror:
    mov al, errorinfo[si]
    mov ds:[bx], ax
    inc si
    add bx, 2
    loop showerror
    jmp $

bootsuccess:
    mov ax, 7E00H
    jmp ax    

    org 510
    dw 0AA55H

code ends

end start