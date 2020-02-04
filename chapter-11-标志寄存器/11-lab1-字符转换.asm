assume cs:code 

data segment 
    db "Zzzz: I' am the best Man in the World!", 0
data ends 

code segment
start:
    mov ax, data
    mov ds, ax
    mov si, 0

    call letterc

    mov 4c00H
    int 21H

letterc:
    push cx
    push si

    mov ch, 0
loop_begin:
    mov cl, ds:[si]
    jcxz loop_end

    cmp cl, 97
    jb else
    cmp cl, 122
    ja else

    ; 转换为大写
    and cl, 11011111b
    
else:
    inc si
    jmp short loop_begin

loop_end:
    pop si
    pop cx
    ret
code sengmet

end start