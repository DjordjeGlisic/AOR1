.386
.model flat,c
.data
Ce dw 2571h
D dw 0ABCDh
B db 0ABh
A dw 1234h
.stack 4096
.code
main proc
mov edx,0
mov eax,0
mov ax,Ce
mov ebx,0
mov bx,D
mul bx
mov ecx,0
mov cx,A
mov ebx,0
mov bl,B
add cl,bl
adc cl,0
mov bx,ax
mov ax,dx
shl eax,16
mov ax,bx
mov ebx,0
mov bx,cx
sub ebx,eax

ret
main endp
end main