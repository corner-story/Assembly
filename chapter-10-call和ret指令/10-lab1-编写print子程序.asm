assume cs:code

data segment
    db "Hello, world!", 0
data ends

stack segment
    db 256 dup (0)
stack ends

code segment
start:  
    mov ax, stack
    mov ss, ax
    mov sp, 256

    mov ax, data
    mov ds, ax
    mov si, 0
    mov dh, 18
    mov dl, 35
    mov cl, 01110100b

    call show_str
    
    mov ax, 4c00H
    int 21H

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