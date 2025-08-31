.386
.model flat,c
.data
n db 10
pom dw ?
sum dw ?
rez dword ?
ostatak dword ?
.stack 4096
.code
main proc
	mov eax,0
	mov al,n
	mov bl,2
	div bl
	mov cl,1
	mov edx,0
	wile:
		cmp cl,al
		ja dalje
		add dl,cl
		adc dh,0
		inc cl
	jmp wile
	dalje:
	mov sum,dx
	mov eax,0
	mov ebx,0
	mov al,n
	mov bl,n
	mul bl
	mul bx
	mov pom,ax
	mov ax,dx
	shl eax,16
	mov ax,pom
	mul ebx
	mov esi,eax
	mov ecx,1
	mov ebx,0
	wile2:
		cmp cl,n
		ja van
		mov eax,0
		mov ax,cx
		add ax,sum
		add ebx,eax
		inc cl
	jmp wile2
	van:
	mov edx,0
	mov eax,ebx
	div esi
	mov rez,eax
	mov ostatak,edx
	ret
main endp
end main
