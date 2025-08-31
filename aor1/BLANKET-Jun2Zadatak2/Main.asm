.386
.model flat,c
.data
	mat dword -7,8,1
		dword 1,-2,-5
		dword 4,3,2
		dword -3,7,-3
	n dword 3
	m dword 4
	niz dword 13 DUP(0)



.stack 4096
.code
metoda proc
	push ebp
	mov ebp,esp
	push eax
	push ebx
	push ecx
	push edx
	push edi
	push esi
	pushfd
	mov ecx,[ebp+8]
	mov edx,0;int i=0;
	mov eax,0;int j=0; 
	petlja:
		mov edi,[ebp+12]
		add edi,edx
		mov edi,[edi]
		cmp edi,0
		jle ink
		
		mov niz[eax],edi
		add eax,4
		ink:
		add edx,4
	loop petlja
	mov niz[eax],-1
	lea eax,niz
	mov [ebp+12],eax

	popfd
	pop esi
	pop edi
	pop edx
	pop ecx
	pop ebx
	pop eax
	pop ebp
	ret 4
metoda endp
main proc
	lea eax,mat
	push eax
	mov eax,n
	mov ebx,m
	mul bl
	push eax
	call metoda
	
	pop eax
	mov ecx,0
	mov edx,0
	wil:
		mov edx,eax
		add edx,ecx
		mov edx,[edx]
		cmp edx,-1
		je kr
		mov ebx,edx
		add ecx,4
	jmp wil
	kr:

	ret
main endp
end main