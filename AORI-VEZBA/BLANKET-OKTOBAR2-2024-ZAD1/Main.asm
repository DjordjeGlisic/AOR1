.386
.model flat,c
.data
A1 dword 07060504h
B1 db 3 DUP(?)
A2 dw  02B08h
B2 dword ?
A3 dw 0A556h
C1 db '0','K','T','2'
.stack 4096
.code
main proc
mov eax,A1
mov ebx,0
mov bx,A2
add eax,ebx
mov cx,ax
shr eax,16
mov dx,ax
mov ax,cx
div bx
mov word ptr B1,ax
mov ax,dx
mov bx,A3
mov dx,0
mul bx
mov cx,ax
mov ax,dx
shl eax,16
mov ax,cx
mov B2,eax
ret
main endp
end main
 