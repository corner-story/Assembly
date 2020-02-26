; 进入保护模式并完成冒泡排序
; 0x7c00-0x7e00为代码段
; 0x0000-0xffffffff为数据段
; 0x0000-0x7c00为堆栈段

    mov ax, 0x07e0
    mov ds, ax
    ; 装载GDT
    mov dword [ds:0x00], 0x00000000
    mov dword [ds:0x04], 0x00000000

    mov dword [ds:0x08], 0x7c0001ff         ; 代码段
    mov dword [ds:0x0c], 0x00409800         

    mov dword [ds:0x10], 0x7c0001ff         ; 代码段别名, 可读写
    mov dword [ds:0x14], 0x00409200

    mov dword [ds:0x18], 0x0000ffff         ; 数据段
    mov dword [ds:0x1c], 0x00cf9200

    mov dword [ds:0x20], 0x00000000         ; 堆栈段
    mov dword [ds:0x24], 0x00409600


    ; 填写GDTR
    lgdt [cs:0x7c00+gdtinfo]

    ; 打开A20
    in al, 0x92
    or al, 000000_1_0B
    out 0x92, al

    ; 关闭中断
    cli

    ; 修改PE位
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    jmp dword 0x0008:protected

    [bits 32]

protected:
    ; 堆栈
    mov ax, 0000000000100_0_00B
    mov ss, ax
    mov esp, 0x00007c00

    ; 可读写代码区
    mov ax, 0000000000010_0_00B
    mov ds, ax

    ; 屏幕显示
    mov ax, 0000000000011_0_00B
    mov es, ax
    mov edi, 0x000b8000

    mov byte [es:edi+0x00], 'O'
    mov byte [es:edi+0x02], 'K'

    ; 以下进行冒泡排序
    mov ecx, gdtinfo-string-1           ; 最外层循环次数
    mov edx, gdtinfo-1
    mov ebx, string
outside:
    mov esi, ebx
    inc esi

    push ecx
    mov ecx, edx
    sub ecx, ebx
inside:
    mov al, [esi]
    cmp al, [ebx]
    jna continue
    mov ah, [ebx]
    mov [ebx], al
    mov [esi], ah
continue:
    inc esi
    loop inside

    pop ecx
    inc ebx
    loop outside

    ; 将字符在第二行显示出来
    mov ebx, string
    mov edi, 0x000b80a0
    mov edx, 0
    mov ecx, gdtinfo-string
    mov ah, 4
display:
    mov al, [ds:ebx]
    mov [es:edi+edx*2], ax
    inc edx
    inc ebx
    loop display

    hlt

    string  db "abcdefgklmn"
    gdtinfo dw 39
            dd 0x00007e00

    times 510-($-$$) db 0
    db 0x55, 0xaa
    