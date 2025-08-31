.386
.model flat,c
.data

gra dword ?
.stack 4096
.code
okreni proc
	push ebp
	mov ebp,esp
	push eax
	push ebx
	push ecx
	push edx
	push edi
	push esi
	pushfd
	mov ecx,0;int i=0
	mov eax,[ebp+12]
	dec eax
	mov ebx,4
	mul ebx; u eax imam 4(n-1)
	mov ebx,2
	div ebx
	mov gra,eax
	mov ebx,2
	mul ebx
	mov ebx,[ebp+8]

	wile:
		cmp ecx,gra
		jae van
		mov edx,ebx
		add edx,ecx
		mov esi,[edx];pom=niz[i]
		mov edx,ebx
		add edx,eax
		sub edx,ecx
		mov edi,ebx
		add edi,ecx
		mov edx,[edx]
		mov [edi],edx
		mov edx,ebx
		add edx,eax
		sub edx,ecx
		mov [edx],esi
		add ecx,4
	jmp wile
	van:
	popfd
	pop esi
	pop edi
	pop edx
	pop ecx
	pop ebx
	pop eax
	pop ebp
	ret 8
okreni endp
end 
