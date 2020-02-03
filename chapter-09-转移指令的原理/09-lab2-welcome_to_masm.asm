assume cs:code

data segment
    db "welcome to masm!"
data ends

code segment
start:
    mov ax, 0B800H
    mov es, ax
    mov bp, 1664

    mov ax, data
    mov ds, ax
    mov bx, 0

    mov cx, 16
s:
    mov al, ds:[bx]

    ; 红底绿字
    mov ah, 01000010b
    mov es:[bp], ax
    
    ; 绿底红字
    mov ah, 00101100b
    mov es:[bp+160], ax

    ; 白底蓝色
    mov ah, 01110001b
    mov es:[bp+320], ax
    
    add bx, 1
    add bp, 2
    loop s

    mov ax, 4c00H
    int 21H
code ends

end start