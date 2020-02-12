assume cs:code
; a mini os

code segment
start:
    mov ax, 7A00H
    mov ss, ax
    mov sp, 0200H

    mov bp, 0           ; flag
    
    ; 安装新的int 9
    mov ah, 1
    call NewInt9

    mov bx, 0
    call clearscreen

    ; 显示信息
    call showinfo

    call selectinput

    jmp $


; 读取输入
selectinput:
    jmp short _inputstart
    db  "please input your choose: ", 0
_inputstart:
    push ax
    push bx
    push cx
    push ds
    push si
    push es
    push di

    mov ax, 07E0H
    mov ds, ax
    mov si, offset selectinput + 2

    mov ax, 0B800H
    mov es, ax
    mov di, (15*80+16)*2
    mov ah, 2
    call showstr
    ; 置光标
    mov bh, 0
    mov dh, 15
    mov dl, 42
    mov ah, 2
    int 10H
    
    mov di, (15*80+42)*2
_loopinput:
    ; 读取键盘输入
    mov ah, 0
    int 16H

    cmp al, 08H
    je _backspace

    cmp al, 0DH
    je _enter

    cmp al, 31H
    jb _loopinput
    cmp al, 34H
    ja _loopinput
    mov ah, 2
    mov es:[di], ax
    jmp _loopinput

_backspace:
    ; 删除键
    mov byte ptr es:[di], ' '
    jmp _loopinput
_enter:
    ; 回车键
    mov ah, es:[di]
    sub ah, 30H
    call fuck
    jmp _loopinput

    pop di
    pop es
    pop si
    pop ds
    pop cx
    pop bx
    pop ax
    ret


; 处理四个功能
; ah=功能号
fuck:
    jmp short _fuck_start
    dw 0000, 0FFFFH
_fuck_start:
    push ax
    push bx
    push cx
    push dx
    push ds
    push si
    push es
    push di

    mov bx, 07E0H
    mov ds, bx
    mov si, offset fuck + 2
    cmp ah, 1
    je _fuck_reset
    cmp ah, 2
    je _fuck_systemstart
    cmp ah, 3
    je _fuck_clock
    cmp ah, 4
    je _fuck_setclock
    jmp short _fuck_return

; reset system, 重新启动计算机, cs:ip=ffff:0000
_fuck_reset:
    mov ah, 0
    call NewInt9
    jmp dword ptr ds:[si]
; start system, 从硬盘引导计算机
_fuck_systemstart:
    mov ax, 0
    mov es, ax
    mov bx, 7C00H

    mov al, 1
    mov ch, 0
    mov cl, 1
    mov dh, 0
    mov dl, 80h
    mov ah, 2
    int 13H

    mov ah, 0
    call NewInt9
    mov ax, 7C00H
    jmp ax
; 在1页显示时钟
_fuck_clock:
    call showclock
    jmp short _fuck_return
; 在1页修改clock
_fuck_setclock:
    call setclock
    jmp short _fuck_return
_fuck_return:
    pop di
    pop es
    pop si
    pop ds
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; 在1页上修改clock
setclock:
    jmp short _setclockstart
_timemessage:    db "input time(YY/MM/DD hh:mm:ss): ", 0
_cmosindex:      db 9, 8, 7, 4, 2, 0
_setclockstart:
    push ax
    push bx
    push cx
    push dx
    push ds
    push si
    push es
    push di

    mov al, 1
    mov ah, 5
    int 10H  

    mov bx, 1
    call clearscreen

    mov ax, 07E0H
    mov ds, ax
    mov si, offset _timemessage

    mov ax, 0B800H
    mov es, ax
    mov di, 4096+(10*80+15)*2
    mov ah, 2
    call showstr

    mov bp, 0                         ; 当按下ESC键时会自动修改为1

    mov di, 4096+(10*80+46)*2         ; 用户输入在屏幕上显示的位置
    mov si, offset _cmosindex         ; CMOS中的index
    mov bx, 0
_waitinput:
    ; 这里dosbox中有用, 在virtualbox中没用
    cmp bp, 1                       ; 用户按下ESC键
    je _setclock_end

    mov ah, 0
    int 16H                         ; 等待输入

    cmp al, 0DH                     ; 回车
    je _INPUT_ENTER
    cmp al, 08H                     ; 删除键
    je _INPUT_BACKSPACE

    jmp _INPUT_CHAR

_INPUT_ENTER:
    cmp bx, 17
    jne _waitinput
    ; 将用户输入的时间写入CMOS
    ; ds:si --> cmos index
    ; es:di --> screen str
    mov cx, 6
_WRITE_CMOS:
    mov dh, es:[di]
    mov dl, es:[di+2]

    shl dh, 1
    shl dh, 1
    shl dh, 1
    shl dh, 1
    and dl, 00001111b
    or dh, dl               ; 计算结果保存在dh中

    mov al, ds:[si]
    out 70H, al
    mov al, dh
    out 71H, al

    inc si
    add di, 6
    loop _WRITE_CMOS
    jmp _setclock_end
_INPUT_BACKSPACE:
    cmp bx, 0
    je _waitinput
    dec bx
    push bx
    add bx, bx
    mov byte ptr es:[di+bx], ' '
    pop bx
    jmp _waitinput
_INPUT_CHAR:
    cmp bx, 17
    je _waitinput
    cmp al, 20H
    jb _waitinput
    cmp al, 7FH
    je _waitinput
    push bx
    add bx, bx
    mov es:[di+bx], al
    pop bx
    inc bx
    jmp _waitinput


_setclock_end:
    ; 显示第0页
    mov al, 0
    mov ah, 5
    int 10H 

    pop di
    pop es
    pop si
    pop ds
    pop dx
    pop cx
    pop bx
    pop ax
    ret


; 在1页显示时钟
showclock:
    jmp short _showclockstart
_timeindex:    db 9, 8, 7, 4, 2, 0
_timeinfo:     db "00/00/00 00:00:00 ", 0
_showclockstart:
    push ax
    push bx
    push cx
    push ds
    push si
    push es
    push di
    push bp

    mov al, 1
    mov ah, 5
    int 10H
    ; 清屏
    mov bx, 1
    call clearscreen
    mov bp, 0                    ; 按下ESC时修改bp为1
    mov ax, 0B800H
    mov es, ax

    mov ax, 07E0H
    mov ds, ax
_loopshowtime:
    mov si, offset _timeinfo
    mov bx, offset _timeindex
    mov cx, 6
_loopshows_toinfo:
    mov al, ds:[bx]
    out 70H, al
    in al, 71H

    mov ah, al
    shr al, 1
    shr al, 1
    shr al, 1
    shr al, 1
    and ah, 00001111b
    add ax, 3030H

    mov ds:[si], ax
    inc bx
    add si, 3
    loop _loopshows_toinfo

    ; 显示缓冲区共8页, 每页4kb
    mov di, 4096*1 + (10*80+32)*2
    mov si, offset _timeinfo
    mov cx, 18
_loopshows_toscreen:
    mov al, ds:[si]
    mov es:[di], al
    inc si
    add di, 2
    loop _loopshows_toscreen

    ; 查看bp的值, 检测是否按下ESC键
    cmp bp, 1
    jne _loopshowtime

    ; 显示0页
    mov al, 0
    mov ah, 5
    int 10H

    pop bp
    pop di
    pop es
    pop si
    pop ds
    pop cx
    pop bx
    pop ax
    ret




; 显示提示信息
showinfo:
    jmp near ptr showstart
_infos:
db    "######################## a mini os #########################", 0
db    "#                                                          #", 0
db    "#                   1) reset pc                            #", 0
db    "#                   2) start system                        #", 0
db    "#                   3) clock                               #", 0
db    "#                   4) set clock                           #", 0
db    "#                                                          #", 0
db    "############################################################", 0

showstart:
    push ax
    push bx
    push cx
    push ds
    push si
    push es
    push di

    mov ax, 07E0H
    mov ds, ax
    mov si, offset _infos

    mov ax, 0B800H
    mov es, ax
    mov di, (2*80+10)*2         ; 字符串显示的位置
    mov ah, 4
    mov cx, 8                   ; 一共显示的行数

_loopshow:
    call showstr
    add si, 60+1                ; 每行显示的字符数+1(最后的0)
    add di, 160         
    loop _loopshow

    pop di
    pop es
    pop si
    pop ds
    pop cx
    pop bx
    pop ax
    ret



; 显示字符串
; ds:si, 遇见0结束
; es:di, 要显示的位置
showstr:
    push ax
    push si
    push di

_loopshowstr:
    mov al, ds:[si]
    cmp al, 0
    je _showreturn
    mov es:[di], ax
    inc si
    add di, 2
    jmp short _loopshowstr    
_showreturn:
    pop di
    pop si
    pop ax
    ret


; 清屏
; bx=页号
clearscreen:
    push ax
    push bx
    push cx
    push dx
    push es
    push di

    mov ax, 4096
    mul bx
    mov di, ax

    mov ax, 0B800H
    mov es, ax
    ; mov di, 0
    mov cx, 4000
_loopclear:
    mov byte ptr es:[di], ' '
    add di, 2
    loop _loopclear

    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; 安装新的int 9
; ah=1, 安装新的
; ah=0, 恢复int 9
NewInt9:
    jmp short _dealstart
    dw 0, 0
_dealstart:
    push ax
    push bx
    push cx
    push dx
    push ds
    push si
    push es
    push di

    mov bx, 07E0H
    mov ds, bx
    mov bx, 0
    mov es, bx

    cmp ah, 1
    je _install
    cmp ah, 0
    jne _dealreturn
    mov si, offset NewInt9 + 2
    mov ax, ds:[si]
    mov es:[9*4+0], ax
    mov ax, ds:[si+2]
    mov es:[9*4+2], ax 
    jmp _dealreturn
_install:
    mov si, offset _NEWINT9
    mov di, 0200H
    cld
    mov cx, offset _NEWINT9_END - offset _NEWINT9
    rep movsb

    mov si, offset NewInt9 + 2
    push es:[9*4+0]
    pop ds:[si]
    push es:[9*4+2]
    pop ds:[si+2]

    mov word ptr es:[9*4+0], 0200H
    mov word ptr es:[9*4+2], 0000H

    jmp _dealreturn
; 新的int 9中断代码
_NEWINT9:
    push ax
    push bx
    push cx
    push ds

    in al, 60H
    mov bx, 07E0H
    mov ds, bx
    mov bx, offset NewInt9 + 2
    ; 调用旧int 9
    pushf
    call dword ptr ds:[bx]

    cmp al, 0001H               ; 检测ESC
    jne _OTHERS
    mov bp, 1
    jmp short _NEWINT9_RETURN
_OTHERS:
    cmp al, 3BH                 ; 检测F1
    jne _NEWINT9_RETURN
    ; 修改屏幕显示属性
    mov ax, 0B800H
    mov ds, ax
    mov bx, 1
    mov cx, 25*80
_CHANGECOLOR:
    add byte ptr ds:[bx], 1
    add bx, 2 
    loop _CHANGECOLOR
_NEWINT9_RETURN:

    pop ds
    pop cx
    pop bx
    pop ax
    iret
_NEWINT9_END:
    nop

_dealreturn:
    pop di
    pop es
    pop si
    pop ds
    pop dx
    pop cx
    pop bx
    pop ax
    ret




; delay
delay:
    push ax
    push dx

    mov ax, 0000H
    mov dx, 0010H
_loopdelay:
    sub ax, 1
    sbb dx, 0
    cmp ax, 0
    jne _loopdelay
    cmp dx, 0
    jne _loopdelay

    pop dx
    pop ax
    ret
code ends

end start