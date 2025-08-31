.386
.model flat,c
.data
b dw 10
ce dw 15
a dword 5 
m dw ?
pom dw ?
.stack 4096
.code
main proc
	mov edi,0
	mov ecx,0
	
	mov eax,2
	mov m,ax
	mov cx,ax
	wile:
		cmp cx,b
		je vanWile

		mov eax,0
		mov ax,m
		xor ax,0f0fh
		mov ebx,3
		mul bx
		mov pom,ax
		mov ax,dx
		shl eax,16
		mov ax,pom
		sub eax,a
		cmp eax,0
		ja van
		neg eax
		van:
		mov ebx,eax
		mov eax,0
		mov ax,m
		mov edx,2
		mul dx
		mov pom,ax
		mov ax,dx
		shl eax,16
		mov ax,pom
		add eax,a
		mov esi,eax
		mov eax,ebx
		mov edx,0
		div esi
		add edi,eax
		mov eax,0
		mov ax,m
		inc ax
		mov m,ax
		mov cx,m
	jmp wile
	vanWile:
	mov ecx,0
	mov cx,b
	add cx,ce
	mov eax,edi
	mov dx,0
	div cx
	;ax ima ceo deo
	;u dx se nalazi ostatak
	ret
main endp
end main