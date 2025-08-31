.386
.model flat,c
.data
	x dword 12345678h, 3h
	n db 5
	m db 10h
	a dw 0abcdh
	q dw 0a741h
	; izgled memorije 78 56 34 12 03 00 00 00 05 10 cd ab 41 a7   
	;niz db 10 DUP(0); suma za byte niz
	;niz dw 10 DUP(0) suma za word niz
	pom db 0
	;pom2 dw 0 za izlazni prenos word niza
	niz dword 10 DUP(0)


	
.code
	; naci sumu elementa niza 
	main proc
		;inicijalizacija niza
		lea ebx,x
		mov eax,dword ptr pom
		mov edx,0; iti element niza
		mov ecx,dword ptr 4h; 5 clana je imao byte niz 4 word 3 dword niz
		inicijalizuj:
			mov ax, word ptr [ebx + eax]; adresa x + pomeraj za iti element niza ovde ax cuva pomeraj u memoriji
			
			mov niz[edx],ax; nadjeno parce memorije stavi na iti element nia
			mov eax,dword ptr pom; sada ax cuva adresu u memoriji za sledeci index 
			;suma za byte niz add ax,3
			;suma za word niz add ax,4; uzima svaki drugu rec u memoriji pocev od adrese x(preskace svaki put po rec kada inicijalizuje element)
			add ax,4; sukcesivno iz memorije 4 bajta daje itom clanu niza pa i+1vom narednih 4 bajta
			mov pom,al
			; inc edx za byte niz
			;add edx,2; za word niz
			add edx,4
			; niz= 78 12 00 10 41 za byte niz
			; niz= 5678,0003,1005,a741 za word niz
			; niz=12345678,00000003,abcd1005 za dword niz
		loop inicijalizuj
		mov eax,0
		;za byte niz mov ebx,00000005h
		; za word niz mov ebx,8h
		mov ebx,12
		mov ecx,ebx
		mov edx,0;suma
		suma:
		cmp ebx,eax
		jbe rez
		;mov esi,word ptr [niz+eax]
		add edx,niz[eax]
		;add dx,niz[eax]
		;mov pom2,dx
		;mov edx,0
		;adc edx,0
		;shl edx,16
		;mov dx,pom2
		; za byte niz inc eax
		;za word niz add eax,2
		;za dword niz
		add eax,4
		loop suma
		rez:
		mov eax,edx
		ret
	main endp
	end main