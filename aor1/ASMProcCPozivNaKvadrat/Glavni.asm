.386
.model flat,c
PUBLIC power2
.data
.stack 4096
.code
power2 proc
	push ebp
	mov ebp,esp
	push ebx
	push ecx
	push edx
	push edi
	push esi
	
	mov eax,[ebp+8];broj
	mov ebx,eax
	mov ecx,[ebp+12];stepen
	dec ecx
	petlja:
		mul bl
	loop petlja

	pop esi
	pop edi
	pop edx
	pop ecx
	pop ebx
	pop ebp
	ret 8
power2 endp
end
