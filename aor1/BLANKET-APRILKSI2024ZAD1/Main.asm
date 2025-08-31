.386
.model flat,c
.data
	a dword 075abc12h
	b dw 10
	c1 dw 3125
	m dw ?
	pom dw ?
.stack 4096
.code
main proc
mov edi,0
mov ecx,0
mov ecx,2
mov m,cx
wile:
	
	mov eax,0
	mov ax,m
	cmp ax,b
	ja van
	xor ax,0f0f0h
	mov ebx,3
	mul bx
	mov pom,ax
	mov ax,dx
	shl eax,16
	mov ax,pom
	sub eax,a
	mov esi,eax
	mov eax,0
	mov ax,m
	mov ebx,2
	mul bx
	mov pom,ax
	mov ax,dx
	shl eax,16
	mov ax,pom
	add eax,a
	mov ebx,eax
	mov eax,esi
	mov edx,0
	div ebx
	cmp edx,0
	je ink
	inc eax
	ink:
	add edi,eax
	mov edx,0
	mov dx,m
	inc dx
	mov m,dx


jmp wile
van:
mov eax,edi
mov ebx,0
mov bx,b
add bx,c1
jnc dalje
mov pom,bx
shr ebx,16
inc bx
shl ebx,16
mov bx,pom
dalje:
mov pom,ax
shr eax,16
mov edx,0
mov dx,ax
mov ax,pom
div ebx

ret
main endp
end main