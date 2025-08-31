.386
.model flat,c
.data
.stack 4096
.code
sumaVrste proc
	push ebp
	mov ebp,esp
	push ebx
	push ecx
	push edx
	push edi
	push esi
	mov eax,[ebp+16]
	mov ebx,[ebp+8]
	cmp eax,ebx
	jae minusJedan
	cmp eax,0
	jb minusJedan
	mov ecx,[ebp+12]
	mov esi,0
	;ebx=vrsta*m*4
	
	mov al,byte ptr [ebp+16]
	mov ebx,0
	mov bl,4
	mul bl
	
	mov bl,byte ptr [ebp+12]
	mul bl
	mov ebx,eax
	mov eax,0
	mov esi,0
	mov eax,0;tu ce biti suma
	petlja:
		mov edx,[ebp+20]
		add edx,ebx
		add edx,esi
		add eax,[edx]
		add ebx,4
	loop petlja
	jmp kraj
	minusJedan:
	mov eax,-1
	kraj:
	pop esi
	pop edi
	pop edx
	pop ecx
	pop ebx
	pop ebp
	ret 16
sumaVrste endp
end