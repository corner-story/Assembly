assume cs:code

data segment
    db "hEllo"
    db "LAMBDAFATE"
data ends


code segment
start:
    mov ax, data
    mov ds, ax
    
    mov bx, 0
    mov cx, 5
s0: 
    mov al, ds:[bx]
    and al, 11011111b
    mov ds:[bx], al
    inc bx
    loop s0

    mov cx, 10
s1: 
    mov al, ds:[bx]
    or al, 00100000b
    mov ds:[bx], al
    inc bx   
    loop s1

    
    mov ax, 4c00H
    int 21H
code ends

end start