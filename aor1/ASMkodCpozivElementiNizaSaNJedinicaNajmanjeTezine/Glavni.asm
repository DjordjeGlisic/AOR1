.386
.model flat,c
.data
pom db ?
.stack 4096
.code
brojiElemente proc
	push ebp
	mov ebp,esp
	push ebx
	push ecx
	push edx
	push edi
	push esi
	mov esi,0
	mov ecx,[ebp+12]
	mov eax,0
	petlja:
		mov ebx,[ebp+16]
		add ebx,esi
		mov ebx,[ebx]
		mov edi,0
		mov edx,0
		wile:
			cmp edi,[ebp+8]
			je van
			shr ebx,1
			adc edx,0
			inc edi
		jmp wile
		van:
		cmp edx,[ebp+8]
		jne v
		inc eax
		v:
		add esi,4
	loop petlja
	pop esi
	pop edi
	pop edx
	pop ecx
	pop ebx
	pop ebp
	ret 12
brojiElemente endp
end