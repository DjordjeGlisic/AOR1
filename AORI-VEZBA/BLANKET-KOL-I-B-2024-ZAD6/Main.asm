.386
.model flat,c
.data
A db 10
B db 23
Ce dw 320
.stack 4096
.code
main proc
	mov eax,0
	mov ax,Ce
	mov ebx,0
	mov bl,B
	cmp bl,0
	jge preskok
	mov bh,0ffh
	jmp dalje
	preskok:
	mov bh,0
	dalje:
	mov edx,0
	imul ax,bx
	mov cx,ax
	mov ax,dx
	shl eax,16
	mov ax,cx
	mov ebx,0
	mov bl,B
	mov ecx,0
	mov cl,A
	add bl,cl
	adc bh,0
	mov ecx,eax
	cmp bx,0
	jge pr
	mov dx,bx
	mov ebx,0ffffffffh
	shl eax,16
	mov bx,dx
	jmp d
	pr:
	mov dx,bx
	mov ebx,0
	mov bx,dx
	d:
	mov eax,ebx
	cdq
	idiv ecx
ret
main endp
end main