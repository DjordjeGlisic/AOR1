.586
.model flat,c
PUBLIC obidjiMatricu
.data
	adresa dword ?
.stack 4096
.code

obidjiMatricu proc
	push ebp
	mov esp,ebp
	push ebx
	push ecx
	push edx
	push edi
	push esi
	push eax
	mov eax,0
	mov ebx,0
	mov eax,[ebp+4]
	mov al,byte ptr [eax]
	dec al
	mov ebx,[ebp+8]
	mov bl,byte ptr [ebx]
	mul bl
	mov edx,eax
	mov ebx,0
	wile:
		cmp ebx,edx
		ja van
		mov ecx,[ebp+8]
		mov ecx,[ecx]
		mov esi,0
		petlja:
			mov eax,[ebp+12]
			mov adresa,eax
			mov eax,adresa[ebx][esi]
			inc esi
		loop petlja
		mov eax,[ebp+4]
		add ebx,[eax]
	jmp wile
	van:
	pop eax
	pop esi
	pop edi
	pop edx
	pop ecx
	pop ebx
	pop ebp
	ret 
obidjiMatricu endp
end 