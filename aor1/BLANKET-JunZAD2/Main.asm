.386
.model flat,c
.data
niz dword 1,7,8,5,10,3,7,2
n dword 8
gra dword ?
.stack 4096
.code
okreni proc
	mov ecx,0;int i=0
	mov eax,n
	dec eax
	mov ebx,4
	mul ebx; u eax imam 4(n-1)
	mov ebx,2
	div ebx
	mov gra,eax
	mov ebx,2
	mul ebx
	lea ebx,niz

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
	ret
okreni endp
end okreni
