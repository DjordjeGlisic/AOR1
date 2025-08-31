.386
.model flat,c
.data
m dword 1
n dword 0
p dword 0
s word 8

.stack 4096
.code
main proc
	mov ecx,1;int cl=1;
	; to sluzi za while(m<=s)<=> not eax>ebx
	wile:
		mov eax,m;u eax imam m
		mov ebx,dword ptr s; u ebsx se cuva s
		cmp eax,ebx
		ja van
		mov eax,0
		mov al,cl;int i
		mul cl; i*i se nalazi u ax
		mov ebx,0
		mov bx,ax; sad se i*i nalazi u bx
		mov eax,m; u eax cuva se m
		mov edx,5; u edx cuva se 5
		mul edx;5 puta Mi-1 se nalazi u edx:eax
		sub eax,ebx;5mi-1-i2 se nalazi u eax
		cmp eax,0
		jge pomeraj
		neg eax
		pomeraj:
		mov n,eax;to je nova vrednost n
		mov eax,0
		mov ax,s
		mov ebx,8
		div bl; s/8 se nalazi u al ostatak u ah
		mov edx,0
		mov dl,al
		cmp ah,0
		je preskoci
		inc dl
		preskoci:;u dl se nalazi veci deo od celo s/8
		add edx,m; na s/8 dodaje se m proslo
		mov m,edx;m ima novu vrednost 
		mov eax,m
		mov ebx,n
		add eax,ebx;sabiraju se m i n sadasnje i jedan i dodaje se u p
		inc eax
		mov p,eax
		inc cl;i++
	jmp wile
	van:
	ret
main endp
end main