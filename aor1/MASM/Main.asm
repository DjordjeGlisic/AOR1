.386
.model flat,c
.data
	niz db 1,2,3,4,5
	n db 4

.code
main proc
	mov ax,0
	mov ecx,n
	petlja:
		add ax,[ebx]
	loop petlja


	ret
main endp
end main