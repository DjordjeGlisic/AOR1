.386
.model flat,c
.data
	niz db 10 DUP(0)
	n db 10
	rez db 0
	;promenljive za inicijalizacuju niza
	a dword 0fa3b9ca1h
	b dword 03345aefah
	z dw 0fa11h
	pom dword ?
	
.stack 4996
.code
trazi proc
	push ebp
	mov ebp,esp
	pushfd
	push ebx
	push ecx
	push esi
	push edi
	;u eax niz;
	;u edx podatak
	mov ebx,0;int i=0;
	mov edi,[ebp+8];int n=10;
	mov ecx,edi
	mov esi,0;int count=0;
	vrti:
		cmp ebx,edi
		jae kraj
		mov pom,edx; u pom imam adresu podatka koji se trazi;
		mov edx,[edx]
		
		cmp [eax+ebx],dh
		mov edx,pom
		jne ink
		inc esi
		ink:
		inc ebx
	loop vrti
	kraj:
		mov eax,[ebp+12]
		mov [eax],esi
	pop edi
	pop esi
	pop ecx
	pop ebx
	popfd
	pop ebp

	
	ret 4
trazi endp
inicijalizuj proc
	push ebp
	mov ebp,esp
	push eax
	push ebx
	push ecx
	push edx
	push edi
	push esi
	pushfd
	mov ecx,0
	mov cl,[ebp+8];brojac petlje
	mov ebx,ecx;int n=10;
	mov eax,0;int i=0;
	mov esi,[ebp+16];adresa u memoriji od gde se inicijalizuje niz
	mov edi,[ebp+12]; adresa niza
	petlja:
		cmp eax,ebx
		jae van
		mov dl,byte ptr [esi+eax]
		mov byte ptr [edi+eax],dl
		inc eax;i++;
	loop petlja
	van:

	
	popfd
	pop esi
	pop edi
	pop edx
	pop ecx
	pop ebx
	pop eax
	pop ebp
	ret 12
inicijalizuj endp
main proc
;adresa  niza preko registra vrednost n niza preko steka podatak koji se pretrazuje po adresi preko reg izlaz adresa preko stek
	lea eax,a
	push eax
	mov eax,offset niz
	push eax
	mov eax,0
	mov al,n
	push eax
	call inicijalizuj
	lea eax,rez
	push eax
	mov eax,offset niz
	
	mov eax,offset niz
	; u eax imamo adresu niza
	mov ebx,0
	mov bl,n
	push ebx
	;vrednost br el niza preko steka
	lea edx,z
	call trazi
	pop eax;rezultat je u eax
	mov eax,[eax]
	ret
main endp
end main
