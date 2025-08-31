.386
.model flat,c
.data
A1 db 5,6,7
B1 dword ?
A2 dw 0B208h
B2 dword ?
A3 dw 0A565h
B3 db 'A','O','R','1'
.stack 4096
.code
mov eax,0
mov ax,word ptr [A1]
shl eax,8
mov al,byte ptr [A1+2]
mov ebx,0
mov bx,A2
add eax,ebx

mov bx,ax
shr eax,16
mov dx,ax
mov ax,bx
mov bx,A2
div bx
mov word ptr [B1],ax

mov ax,dx
mov bx,A3
mul bx
mov bx,ax
mov ax,dx
shl eax,16
mov ax,bx
lea ecx,B2
mov [ecx],eax
main proc
ret
main endp
end main