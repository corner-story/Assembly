assume cs:code, ds:data

data segment 
year        db '1975', '1976', '1977', '1978', '1979', '1980', '1981', '1982', '1983'
            db '1984', '1985', '1986', '1987', '1988', '1989', '1990', '1991', '1992'
            db '1993', '1994', '1995'
            ; 21个年份

income      dd 16, 22, 382, 1356, 2390, 8000, 16000, 24486, 50065, 97479, 140417, 197514
            dd 345980, 590827, 803530, 1183000, 1843000, 2759000, 3753000, 4649000, 5937000
            ; 21年的总收入

employee    dw 3, 7, 9, 13, 28, 38, 130, 220, 476, 778, 1001, 1442, 2258, 2793, 4037, 5635, 8226
            dw 11542, 14430, 15257, 17800
            ; 21年公司雇的人数
data ends

code segment
start:
    mov ax, data
    mov ds, ax
    mov si, 0

    mov cx, 21
    call showinfo

    mov ax, 4c00H
    int 21H

; 展示公司信息
; ds:si 信息下标, cx 需要展示的信息数量
showinfo:
    jmp short showstart
       
showstart:
    push ax
    push es
    push di

    mov ax, 0B800H
    mov es, ax
    mov di, (4*80+0)*2

showline:
    ; 显示year
    call _showyear
    add di, 40

    ; 显示收入
    call _showincome
    add di, 40

    ; 显示人数
    call _showemployee
    add di, 40

    ; 计算平均收入并显示
    call _showages
    add di, 40

    inc si
    loop showline

showfinish:
    pop di
    pop es
    pop ax
    ret

; 显示平均工资
_showages:
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    mov bx, si
    add bx, bx
    mov cx, employee[bx]
    add bx, bx
    mov ax, income[bx]
    mov dx, income[bx+2]
    call divdw
    mov si, 0
_loopwages:
    mov cx, 10
    call divdw
    add cx, 30H
    push cx
    inc si
    cmp ax, 0
    jne _loopwages
    cmp dx, 0
    jne _loopwages

    mov cx, si
_loopwages_display:
    pop ax
    mov ah, 4
    mov es:[di], ax
    add di, 2
    loop _loopwages_display

    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret


; 显示雇员人数
_showemployee:
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    mov bx, si
    add bx, bx
    mov ax, employee[bx]
    mov dx, 0
    mov si, 0
_loopemployee:
    mov cx, 10
    call divdw
    add cx, 30H
    push cx
    inc si
    cmp ax, 0
    jne _loopemployee
    cmp dx, 0
    jne _loopemployee

    mov cx, si
_loopemployee_display:
    pop ax
    mov ah, 2
    mov es:[di], ax
    add di, 2
    loop _loopemployee_display

    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; 显示总收入
_showincome:
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    mov bx, si
    add bx, bx
    add bx, bx
    mov ax, income[bx]
    mov dx, income[bx+2]
    mov si, 0
_loopincome:
    mov cx, 10
    call divdw
    add cx, 30H
    push cx
    inc si
    cmp ax, 0
    jne _loopincome
    cmp dx, 0
    jne _loopincome

    mov cx, si
_loopincome_display:
    pop ax
    mov ah, 2
    mov es:[di], ax
    add di, 2
    loop _loopincome_display

    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret


; 显示年份
_showyear:
    push ax
    push bx
    push cx
    push si
    push di

    mov bx, si
    add bx, bx
    add bx, bx
    mov ah, 2
    mov si, 0
    mov cx, 4
_loopyear:
    mov al, year[bx+si]
    mov es:[di], ax
    inc si
    add di, 2
    loop _loopyear

    pop di
    pop si
    pop cx
    pop bx
    pop ax
    ret


; 参数  (ax)=dword型数据的低16位
;		(dx)=dword型数据的高16位
;		(cx)=除数
; 返回	(dx)=结果的高16位，(ax)=结果的低16位
;		(cx)=余数
divdw:
		push bx
		
		mov bx,ax
		mov ax,dx
		mov dx,0
		div cx
		push ax   ;将高位产生的商入栈保存
		mov ax,bx
		div cx
		mov cx,dx ;结果
		pop dx
		
		pop bx
		ret


code ends


end start