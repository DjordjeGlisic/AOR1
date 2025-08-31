;zamena mesta glavnoj i sporednoj ndijagonali
;matrica smestena po kolonama
.386
.model flat,c
.data
	mat byte 1,6,11,10,21
		byte 2,7,12,17,22
		byte 3,8,13,18,23
		byte 4,9,14,19,24
		byte 5,10,15,20,25
	n dword 5
	pom db ?
.stack 4096

.code
main proc
	mov eax,0
	mov ebx,0
	mov al,byte ptr n
	dec al
	mov bl, byte ptr n
	mul bl
	mov edx,0
	mov edx,eax
	;edx=0;ebx=(n-1)*n;
	mov ecx,n
	mov esi,0
	mov ebx,edx
	mov edx,0
	petlja:
		mov eax,0
		;int pom=a[i];a[i]=a[j];a[j]=pom;
		mov al,mat[edx][esi]
		mov pom,al
		mov al,mat[ebx][esi]
		mov mat[edx][esi],al
		mov al,pom
		mov mat[ebx][esi],al
		inc esi
		add edx,n
		sub ebx,n
	loop petlja
	mov esi,0
	mov ebx,0
	mov eax,0
	mov al,byte ptr n
	dec al
	mov bl,byte ptr n
	mul bl
	mov edx,eax
	mov eax,0
	mov ecx,n
	petlja2:
		;while(ebx<=(n-1)*n)
		mov ebx,0
		wile:
			cmp ebx,edx
			ja van
			mov eax,0
			mov al,mat[ebx][esi]
			add ebx,n
		jmp wile
		van:
		inc esi
	loop petlja2
	ret
main endp
end main
