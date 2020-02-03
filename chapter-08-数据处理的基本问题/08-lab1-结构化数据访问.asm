assume cs:code

data segment 
    db '1975', '1976', '1977', '1978', '1979', '1980', '1981', '1982', '1983'
    db '1984', '1985', '1986', '1987', '1988', '1989', '1990', '1991', '1992'
    db '1993', '1994', '1995'
    ; 21个年份

    dd 16, 22, 382, 1356, 2390, 8000, 16000, 24486, 50065, 97479, 140417, 197514
    dd 345980, 590827, 803530, 1183000, 1843000, 2759000, 3753000, 4649000, 5937000
    ; 21年的总收入

    dw 3, 7, 9, 13, 28, 38, 130, 220, 476, 778, 1001, 1442, 2258, 2793, 4037, 5635, 8226
    dw 11542, 14430, 15257, 17800
    ; 21年公司雇的人数
data ends


table segment   
    db 21 dup("year summ ne ?? ")
table ends 

code segment
start:
    mov ax, data
    mov es, ax

    mov si, 0
    mov di, 168

    mov ax, table
    mov ds, ax
    mov bx, 0

    mov cx, 21
s0: 
    mov dx, es:[si+0]
    mov ds:[bx+0], dx
    mov dx, es:[si+2]
    mov ds:[bx+2], dx

    mov dx, es:[si+84+0]
    mov ds:[bx+5+0], dx
    mov dx, es:[si+84+2]
    mov ds:[bx+5+2], dx

    mov dx, es:[di]
    mov ds:[bx+10], dx

    ; 计算
    mov ax, ds:[bx+5+0]
    mov dx, ds:[bx+5+2]

    div word ptr ds:[bx+10]
    mov ds:[bx+13], ax

    add si, 4
    add di, 2
    add bx, 16

    loop s0

    mov ax, 4c00H
    int 21H

code ends

end start