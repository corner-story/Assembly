assume cs:code

; 按ESC键时改变颜色
; 在屏幕中央 12, 40显示A-Z

; 装载一个新的int 09H中断例程, 在新的中断例程中调用原来的

stack segment
    db 128 dup (0)
stack ends

; 存储 int 09H 对应的 cs:[ip] 
data segment
    dw 0, 0
data ends

code segment
start:
    mov ax, stack
    mov ss, ax
    mov sp, 128

    mov ax, data
    mov ds, ax
    mov ax, 0
    mov es, ax

    ; 保存原来的cs:ip并使其指向0000:0200
    push es:[9*4+2]
    push es:[9*4]
    pop ds:[0]
    pop ds:[2]

    mov es:[9*4+2], cs
    mov word ptr es:[9*4], offset Int09


    ; 执行程序
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
    jmp short dislpay
display_end:

    ; 在该程序返回之前
    ; 还原 cs:ip
    mov ax, 0
    mov es, ax
    mov ax, ds:[0]
    mov es:[9*4], ax
    mov ax, ds:[2]
    mov es:[9*4+2], ax

    mov ax, 4c00H
    int 21H


; 延迟
delay:
    push ax
    push dx

    mov dx, 0010H
    mov ax, 0000H
delay_begin:
    sub ax, 1
    sbb dx, 0
    cmp ax, 0
    jne delay_begin
    cmp dx, 0
    jne delay_begin
    
    pop dx
    pop ax
    ret


; 新的int9中断
; 先读取60H端口, 判断按键是否为ESC(扫描码为01), 最后调用原来的int9处理程序
; 该程序执行时cs=0000, ip=0200
Int09:
    push ax
    push es
    push di

    in al, 60H

    ; 保存fg并修改fg, TF=0, IF=0
    ; 但是进入该中断时, TF和IF都已设为0, 所以只保存fg
    pushf
    call dword ptr ds:[0]  ; push cs, push ip
    
    cmp al, 0001H
    jne Int09_end
    mov ax, 0B800H
    mov es, ax
    mov di, (12*80+40)*2
    add byte ptr es:[di+1], 1
    add byte ptr es:[di+2], 1
    mov ah, 04
    mov al, '!'
    mov es:[di+4], ax

Int09_end:
    pop di
    pop es
    pop ax
    iret
Int09_finish:
    nop
code ends

end start