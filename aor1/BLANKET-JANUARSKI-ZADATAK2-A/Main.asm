.386
.model flat,c
.data
niz dw 1,2,3,4,5,6,7,8,9,10,0
.stack 4096
.code
procedura proc
push ebp
mov ebp,esp
push eax
push ebx
push ecx
push edx
push edi
push esi
pushfd
mov eax,0
mov ax,[ebp+12]
add ax,word ptr [ebp+16]
mov dx,ax
shr eax,16
adc eax,0
shl eax,16
mov ax,dx
mov ebx,[ebp+8]
mov word ptr [ebx],ax
popfd
pop esi
pop edi
pop edx
pop ecx
pop ebx
pop eax
pop ebp
ret 12
procedura endp
main proc
mov edi,0
mov ecx,1
lea esi,niz
wile:
	mov eax,esi
	add eax,edi
	mov ebx,0
	mov bx,word ptr [eax]

	cmp ebx,0
	je van
	mov eax,ecx
	mov ebx,3
	mov edx,0
	div ebx
	cmp edx,0
	jne krajIfa
	mov ebx,edi
	dec ebx
	dec ebx
	
	add ebx,esi
	mov edx,0
	mov dx,[ebx]
	push edx
	mov ebx,edi
	inc ebx
	inc ebx
	add ebx,esi
	mov edx,0
	mov dx,[ebx]
	push edx
	mov ebx,esi
	add ebx,edi
	lea eax,[ebx]
	push eax
	call procedura
	krajIfa:
	add edi,2
	inc ecx
jmp wile
van:
mov edi,0
lea esi,niz
wile2:
mov ebx,esi
add ebx,edi
mov edx,0
mov dx,[ebx]
cmp dx,0
je vani
mov eax,0
mov ecx,esi
add ecx,edi
mov ax,[ecx]
add edi,2
jmp wile2
vani:
mov eax,0
main endp
end main