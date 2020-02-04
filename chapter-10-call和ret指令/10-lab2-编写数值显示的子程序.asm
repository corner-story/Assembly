assume cs:code

; 数值显示子程序

data segment
    db 10 dup (0)
data ends

stack segment
    db 256 dup (0)
stack ends

code segment
start:  
    ; 初始化栈
    mov ax, stack
    mov ss, ax
    mov sp, 256
    ; 初始化ds:[si]
    mov ax, data
    mov ds, ax
    mov si, 0
    mov ax, 1000
    call dtoc

    mov dh, 18
    mov dl, 35
    mov cl, 01110100b

    call show_str
    
    mov ax, 4c00H
    int 21H

; function: 将word型的数字转变为十进制字符串, 字符串以0结尾
; 参数: (ax)=word型数据, ds:si指向字符串首地址
; 返回: 无返回
dtoc:
    push ax
    push bx
    push cx
    push dx
    push si

    mov bl, 10            ; 除数
    mov bh, 0             ; 显示字符的个数, word型数据, 最多显示五位
    mov dh, 0             ; 使用dx寄存器保存每次计算的余数
dtoc_begin:    
    div bl
    mov dl, ah
    add dl, 030H          ; 余数转换为对应字符的ASCII码值
    push dx
    inc bh

    mov ah, 0
    mov cx, ax            ; 每次循环计算完成后查看是否为0 
    jcxz dtoc_end         ; 如果为0则结束
    jmp short dtoc_begin

dtoc_end:
    ; 将栈中的结果pop到ds:[si]
    mov cl, bh
    mov ch, 0
dtoc_loop:
    pop ax
    mov ds:[si], ax
    inc si
    loop dtoc_loop

    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret


; function: 在指定位置, 指定颜色, 显示一个用0结束的字符串
; 参数: (dh)=行号(0-23), (dl)=列号(0-79), (cl)=颜色, ds:si=字符串首地址
; 返回: 无返回
show_str:
    ; 保存寄存器
    push ax
    push bx
    push cx
    push dx
    push es
    push bp
    push si

    ; 计算显示字符串在内存中的地址
    mov al, dh
    mov ah, 80
    mul ah
    mov dh, 0
    add ax, dx
    mov dx, 0
    mov bx, 2
    mul bx
    ; 初始化段寄存器
    mov bp, ax
    mov ax, 0B800H
    mov es, ax     
    mov ah, cl                  ; 保存cl
    mov ch, 0
    ; 循环显示, 遇到0结束
display:
    mov al, ds:[si]
    mov cl, al
    jcxz finish                 ; 如果cx=0, 即字符串遇到0则跳转到finish标签
    mov es:[bp], ax
    
    inc si
    add bp, 2
    jmp short display           ; 否则跳转到display继续显示下一个

finish:
    pop si
    pop bp
    pop es
    pop dx
    pop cx
    pop bx
    pop ax

    ret
code ends

end start