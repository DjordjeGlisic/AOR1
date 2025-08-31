.386
.model flat,c
.data
	x dword 0a5b7c4d5h
	a db 7h
	b db 0afh
	y dword 0b1b70003h
	;izgled memorije d5 c4 b7 a5 07 af b5 b4 00 03
	niz dw 5 DUP(0)
	niz2 dw 0d5c4h, 0b7a5h, 007afh, 0b5b4h, 0003h, 0000h

.code
	main proc
		mov eax,0
		mov al,3h
		mov ecx,5
		lea esi,x
		lea edi,niz
		mov ebx,0
		inicijalizacija:
			mov dx,[esi+ebx]
			mov niz[ebx],dx
			add ebx,2
			;niz c4 d5,a5 b7, af 07, b4 b5,b1 b7
		loop inicijalizacija
		mov ecx,5
		;repne scasw
		; ako nemamo repne on na edi adresi proverava word sa ax a ne pocev od adrese na edi svaki word u nizu to radi rep,repe,repne
		scasw
		jz naso
		jnz nijeNaso
		naso:
			stc
			jmp kraj
		nijeNaso:
			clc
		kraj:
			lea esi,niz2
			mov eax,0
			wile:
			cmp niz2[eax],0
			je vanNula
			cmp niz2[eax],3
			je vanNaso
			add ax,2
			jmp wile
			vanNula:
				clc
				jmp kraj2
			vanNaso:
				stc
				jmp kraj2
			kraj2:
		ret
	main endp
	end main
	
	