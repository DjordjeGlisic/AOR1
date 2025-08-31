.386
.model flat,c
.data
n db 2
s db ?
a dw ?
b db ?
pom dw ?
.stack 4096
.code
main proc
	mov eax,0
	mov al,n
	mov ebx,0
	mov bl,2
	div bl
	mov ah,0
	mov ecx,0
	mov cl,al
	petlja:
		add s,cl
	loop petlja
	; s poseduje sumu 
	mov eax,0
	mov al,n
	mov ebx,0
	mov bl,n
	mul bl;rezultat je u ah:al
	mov bx,ax
	mov eax,0
	mov al,n
	mov edx,0
	mov dl,n
	mul dl;rezultat je u ah:al
	mul bx;rezultat je u dx:ax
	mov ecx,0
	mov cx,ax
	mov ax,dx
	shl eax,16
	mov ax,cx;rezultat je u eax-n^4
	mov edi,eax
	mov ebx,0
	mov ecx,0
	mov edx,0
	wile:
		
		mov dl,bl
		add dl,s
		mov ax,dx
		mov dx,0
		div edi
		inc ebx
		mov pom,ax
		div bl
		cmp ah,n
	
	je van
		mov ax,pom
	jmp wile
	van:
	mov ax,pom
	mov a,ax
	mov b,bl
	


	
	
	ret
main endp
end main