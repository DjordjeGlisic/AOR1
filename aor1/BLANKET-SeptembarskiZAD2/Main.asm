.386
.model flat,c
.data
niz db 'o','v','o','b','r','a','t','e',' ',' ',' ', 'j','e',' ','n','e','k','i',' ','s','t','r','i','n','g',0
poc db ?
kraj db ?
pom db ?
.stack 4096
.code
nadjiRec proc
	push ebp
	mov ebp,esp
	push ecx
	push edx
	push esi
	push edi
	pushfd
	mov eax,1;brojac=1
	mov edx,0;int i=0;
	mov esi,[ebp+12];adresa niz
	wile:
		cmp al,byte ptr [ebp+8]
		je van
		mov ecx,esi
		add ecx,edx
		mov cl,byte ptr [ecx]
		cmp cl,0
		je van
		cmp cl,' '
		jne elsee
		inc eax
		inc edx
		wile2:
			mov ecx,esi
			add ecx,edx
			mov cl,byte ptr [ecx]
			cmp cl,' '
			jne van2
			inc edx
		jmp wile2
		elsee:
		inc edx
		van2:
	jmp wile
	van:
	mov ecx,esi
	add ecx,edx
	mov cl,byte ptr [ecx]
	cmp cl,0
	jne else2
	mov eax,0
	mov ebx,0
	jmp va
	else2:
	mov eax,edx
	mov ebx,eax
	wile3:
		mov ecx,esi
		add ecx,ebx
		mov cl,byte ptr [ecx]
		cmp cl,' '
		je va
		cmp cl,0
		je nula
		inc ebx
	jmp wile3
	nula:
	dec ebx
	va:
	popfd
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebp
	ret 8
nadjiRec endp
main proc

	lea eax,niz
	push eax
	mov eax,1
	push eax
	call nadjiRec
	mov poc,al
	mov kraj,bl
	mov edx,2
	wajl:
		mov pom,dl
		lea eax,niz
		push eax
		mov eax,edx
		push eax
		call nadjiRec
		mov edx,0
		mov dl,al
		add dl,bl
		cmp dl,0
		je krajKoda
		mov cl,kraj
		sub cl,poc
		mov edx,0
		mov dl,bl
		sub dl,al
		cmp cl,dl
		jae neInic
		mov poc,al
		mov kraj,bl
		neInic:
		mov edx,0
		mov dl,pom
		inc dl

		
	jmp wajl
	krajKoda:
	mov eax,0
	mov al,kraj
	sub al,poc
	ret
main endp
end main