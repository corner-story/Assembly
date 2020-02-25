; 从20章以后开始用NASM编译代码
; 进入保护模式
; 当前512字节在0x7c00-0x7e00
; 0x7e00之后存放GDT

    ; 设置ds->0x7e00
    ; 这里要注意, 此时为实模式, 内存访问模式为ds:bx, ds设置为0x07e0, 不是0x7e00!!!(这个地方折磨了好久)
    mov ax, 0x07e0
    mov ds, ax

    ; 进行进入保护模式之前的准备
    ; 填写GDT
    mov dword [ds:0x00], 0x00           ; 0号描述符, 必须为null, 处理器要求                   
    mov dword [ds:0x04], 0x00
    
    mov dword [ds:0x08], 0x7c0001ff     ; 1号描述符, 代码段        
    mov dword [ds:0x0c], 0x00409800

    mov dword [ds:0x10], 0x80001000     ; 2号描述符, 数据段, 对应屏幕显示区
    mov dword [ds:0x14], 0x0040920b  

    mov dword [ds:0x18], 0x7a0001ff     ; 3号描述符, 堆栈段
    mov dword [ds:0x1c], 0x00409600
    

    ; 填写GDTR
    lgdt [cs:0x7c00+gdtinfo]

    ; 打开A20(通过读写0x92端口)
    in al, 0x92
    or al, 000000_1_0B
    out 0x92, al

    ; 关闭中断, 进入保护模式后, BIOS的所有中断无法使用, 设置新的中断向量之前必须关闭中断
    cli

    ; 修改控制寄存器(cr0)的PE位(第1位)为1, 允许进入保护模式
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    ; 使用一个远跳转操作, 清空流水线
    ; 执行该位置的命令时已经进入保护模式
    ; 0x08-> 00001_0_00(index_TI_RPL), 段选择子为1,对应代码段, TI=0, 表示该段在GDT中, RPL为请求特权级
    jmp dword 0x0008:protected

    [bits 32]
protected:
    ; 在保护模式中设置数据段
    mov ax, 0000000000010_0_00B
    mov ds, ax

    mov byte [ds: 0x00], 'O'
    mov byte [ds: 0x02], 'K' 

    ; 在保护模式中设置堆栈段
    mov ax, 0000000000011_0_00B
    mov ss, ax
    mov esp, 0x00007c00

    mov eax, esp
    push byte '!'
    sub eax, 4
    cmp eax, esp
    jne finally
    pop eax
    mov [ds: 0x04], al
finally:
    hlt

gdtinfo     dw 31                 ; 16位的界限值
            dd 0x00007e00         ; 32位的GDT基址

    times 510-($-$$) db 0
    db 0x55,0xaa