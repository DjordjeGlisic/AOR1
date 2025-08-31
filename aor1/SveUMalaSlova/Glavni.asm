.386
.model flat,c
.data
	
.stack 4096
.code
strKonverz proc
	push ebp
	mov ebp,esp
	push eax
	push ebx
	push ecx
	push edx
	push edi
	push esi
	mov esi,[ebp+8];ulaz
	mov edi,[ebp+12];izlaz
	mov ebx,-1;pomeraj
	mov ecx,'a'
	mov edx,'A'
	wile:
		inc ebx
		mov eax,0
		mov al,[esi+ebx]
		cmp al,0
		je van
		cmp al,'A'
		jl van1
		cmp al,'Z'
		ja van1
		mov al,[esi+ebx]
		add al,32
		mov [edi+ebx],al
		van1:
		mov [edi+ebx],al
		jmp wile
	jmp wile
	van:
	pop esi
	pop edi
	pop edx
	pop ecx
	pop ebx
	pop eax
	pop ebp
	ret
strKonverz endp
end