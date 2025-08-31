.386
.model flat,c
.data
mat	word 2,1,1
	 word 7,3,11
	word 9,9,4
	word 9,81,3
n dword 3
m dword 4
count dword -1

.stack 4096
.code
procedura proc
	push ebp
	mov ebp,esp
	push eax
	push ebx
	push ecx
	push edx
	push edi
	push esi
	
	pushfd
	mov esi,[ebp+12];matrica za int i=0;
	mov ecx,[ebp+8];int n=broj
	mov edx,0;count=0
	petlj:
		mov ebx,3
		
		mov eax,0
		mov ax,word ptr[esi]
		div bl;ah-ostatak,al-ceo broj
		cmp ah,0
		jne inkrement
		inc edx
		inkrement:
		add esi,2
	loop petlj
	mov [ebp+12],edx
	popfd
	
	pop esi
	pop edi
	pop edx
	pop ecx
	pop ebx
	pop eax
	pop ebp

	ret 4
procedura endp
main proc
	mov ecx,m
	mov edx,0;int i=0
	mov eax,0;za skladistenje kolone
	mov edi,1;za koja je kolona po redu
	lea esi,mat
	petlja:
		push esi
		mov ebx,n
		push ebx
		call procedura
		pop ebx;count za datu kolonu
		cmp ebx,count
		jle ink
		mov count,ebx
		mov eax,edi
		ink:
		inc edi
		add edx,2;i++
		add esi,n
		add esi,n
	loop petlja
	;kolona sa najvecim brojem clanova deljivih sa 3 je u eax



	ret
main endp
end main