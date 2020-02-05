assume cs:code

; test 7CH
; 2*3456**2

code segment
start:
    mov ax, 3456
    int 7CH

    add ax, ax
    adc dx, dx

    mov ax, 4c00H
    int 21H
code ends

end start