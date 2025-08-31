.386
.model flat,c
.data
	a1 dword 0ffffffffh
	b1 db 3 DUP(?)
	a2 dw 2b08h
	b2 dword ?
	a3 dw 0a556h
	c1 db 'O','K','T','2'
.stack 4096
.code
main proc
	mov eax,a1
	mov ebx,0
	mov bx,a2
	add eax,ebx
	mov ebx,0
	mov bx,a2
	mov cx,ax
	shr eax,16
	mov dx,ax
	mov ax,cx
	div bx
	mov word ptr b1,ax
	mov ax,dx
	mov bx,a3
	mul bx
	mov cx,ax
	mov ax,dx
	shl eax,16
	mov ax,cx
	mov b2,eax
	ret
main endp
end main