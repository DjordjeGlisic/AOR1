.386
.model flat,c
.data
mat dword 1,7,-5,4
	dword 3,2,1,5
	dword -2,-7,-3,-9
	dword 1,4,4,1
n dword 4
m dword 4
pom dword ?
indeks dword ?
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
add edx,ecx
mov [eax],edx
popfd
pop esi
pop edi
pop edx
pop ecx
pop ebx
pop eax
pop ebp
ret
procedura endp
main proc
mov ebx,0
mov eax,n
dec eax
mov ebx,m
mul bl
mov ebx,4
mul bl
mov edi,eax
mov ebx,0
mov eax,0
mov indeks,eax
wile:
	cmp ebx,edi
	ja van
	mov eax,indeks
	mov ecx,2
	mov edx,0
	div ecx
	cmp edx,0
	je naredna
	cmp ebx,0
	je naredna
	cmp ebx,edi
	je naredna
	mov esi,0
	mov ecx,m
	petlja:
		
		lea eax,mat
		add eax,ebx
		add eax,esi
		lea edx,mat
		add edx,ebx
		sub edx,m
		sub edx,m
		sub edx,m
		sub edx,m
		add edx,esi
		mov edx,[edx]
		mov pom,ecx
		lea ecx,mat
		add ecx,ebx
		add ecx,m
		add ecx,m
		add ecx,m
		add ecx,m
		add ecx,esi
		mov ecx,[ecx]
		call procedura
		mov ecx,pom
		add esi,4
	loop petlja
	naredna:
	add ebx,m
	add ebx,m
	add ebx,m
	add ebx,m
	mov edx,0
	mov eax,indeks
	inc eax
	mov indeks,eax
jmp wile
van:
ret
main endp
end main