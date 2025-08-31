.386
.model flat,c
.data
	mat dword 1,2,3,5
		dword 8,11,4,6
		dword 7,9,10,12
	n dword 3
	m dword 4
.stack 4096
.code

main proc
	mov edx,0
	mov eax,0
	mov ebx,0
	mov esi,0
	mov bl,byte ptr m
	mov al,byte ptr n
	dec al
	mul bl
	;rez u ax
	mov bl,4
	mul bl
	;rez u ax,mnoze se al i bl
	mov dx,ax
	mov eax,0
	mov ebx,0
	wile:
		cmp ebx,edx
		ja van
		mov ecx,m
		mov esi,0
		petlja:
			mov eax,mat[ebx][esi]
			add esi,4
		loop petlja
		add ebx,m
		add ebx,m
		add ebx,m
		add ebx,m
		
	jmp wile
	van:
	
	ret
main endp
end main