.386
.model flat,c
.data
d dword 74
e dword 10
a dw 3
.stack 4096
.code
main proc
mov esi,d
mov edi,e
wile:
	cmp esi,edi
	jbe vann
	mov ecx,0
	mov cx,a
	mov edi,ecx
	add edi,ecx
	add edi,ecx
	add edi,ecx
	add edi,ecx
	mov eax,0
	mov edx,0
	mov ax,cx
	mov dl,4
	div dl
	mov ah,0
	mov ecx,0
	mov cl,al
	mov eax,edi
	mov edx,0
	mov ebx,0
	mov bl,8
	div ebx
	sub esi,ecx
	sub esi,eax
	cmp esi,0
	jae vn
	neg esi
	vn:
	inc edi
	mov eax,edi
	mov ecx,3
	mov edx,0
	div ecx
	cmp edx,0
	je kraj
	inc eax
	kraj:
	add eax,2
	mov a,ax
	mov d,esi
	mov e,edi
jmp wile
vann:
mov eax,0
main endp
end main