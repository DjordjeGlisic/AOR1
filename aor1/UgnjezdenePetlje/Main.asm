;for i=5;i>0;i--
;	for j=10;j>0;j++
.386
.model flat,c
.data
.stack 4096
.code
main proc
	mov eax,0
	mov ebx,0bh
	mov ecx,3
	spoljna:
	push ecx
	mov ecx,10
	unutrasnja:
		add eax,ebx
	loop unutrasnja
	pop ecx

	loop spoljna
	ret
main endp
end main