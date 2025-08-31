.386
.model flat,c
.data
	n dd 10
	m dd 3
	a dw 22h
	b dw 03Ah

.code 
	main proc
		mov ax,0
		mov ecx,n
		; petlja sa korakom 1 i 2 od n do 0
		;petlja:
			;inc ax
			;sub ecx,1
			;cmp ecx,0
			;jbe van
			;inc ax
		;loop petlja
		;van:
		;for int i=m;i<n;i++
		;mov eax,m
		
		;mov ecx,n
		;sub ecx,eax
		;mov ebx,n
		;petlja:
			;telo petlje
			;inc ax
		;loop petlja
		;for int i=0;i<n;i++
		;mov ecx,n
		;mov eax,0
		;petlja:
			;inc ax
			;za i+=2
			;inc ax
		;loop petlja
		;for int i=0;i<n&&a<b;i++{a+=1}
		mov eax,0
		mov ecx,n
		petlja:
			mov ebx,0
			mov bx,b
			cmp a,bx
			je kraj
			inc eax
			inc a
		loop petlja
		kraj:



		
	ret
	main endp
	end main
