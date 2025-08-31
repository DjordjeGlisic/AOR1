.386
.model flat,c
.data
	
	niz db 07h,0eh,17h,1bh,33h,00fh
	sum db 0
	dop db 0
	avg dw 0
	; 05 07 0e 17 1b 33 00 00 00 00
	n db 6
	i db 0
	k db 3
	pom db 0


.code
main proc
	lea esi,niz
	mov eax,0
	mov ecx,5
	mov edx,ecx
	sumaPetlja:
		;uvodi se reg bx za operacije izmedju sum i niz[eax]
		mov ebx,0
		mov bl,niz[eax]
		add sum,bl
		mov bl,byte ptr sum+1
		adc bl,0
		mov byte ptr sum+1,bl
		inc eax
	loop sumaPetlja
	mov eax,0
	mov ah,byte ptr dop
	mov al,byte ptr sum
	mov ebx,5
	inc ebx
	div bl
	mov ah,0
	mov avg,ax
	mov ecx,5
	mov eax,0
	reinicPetlja:
		mov ebx,0
		mov bx,avg
		cmp niz[eax],bl
		jbe nakon
		mov niz[eax],bl
		nakon:
		inc eax
	loop reinicPetlja
	wile:
	mov eax,0
	mov al,i
	add al,k
	cmp al,n
	jae rez
	mov eax,0
	;pom=niz[i]
		mov ebx,0
		mov eax,0
		mov al,i
		mov bl,niz[eax]
		mov pom,bl
	;niz[i]=niz[i+k]
		mov eax,0
		mov ebx,0
		mov ecx,0
		mov edx,0
		mov cl,i
		;niz[ecx] je niz[i]
		mov al,i
		add al,k
		;niz[eax] je niz[i+k]
		mov dl,niz[eax]
		mov niz[ecx],dl

	;niz[i+k]=pom
		mov eax,0
		mov al,i
		mov ebx,0
		add al,k
		mov bl,pom
		mov niz[eax],bl
	mov eax,0
	mov al,i
	inc eax
	mov i,al
	jmp wile

	rez:
	
	
	ret
main endp
end main