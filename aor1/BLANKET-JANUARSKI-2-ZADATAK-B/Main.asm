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
mov ax,[ebp+12]
add ax,word ptr [ebp+16]
mov dx,ax
shr eax,16
adc eax,0
shl eax,16
mov ax,dx
mov edi,[ebp+8]
stosw
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
mov ecx,1
lea edi,niz
wile:
	mov esi,edi
	lodsw
	cmp eax,0
	je van
	mov esi,edi
	mov eax,ecx
	mov edx,0
	mov esi,3
	div esi
	cmp edx,0
	jne ink
	mov esi,edi
	sub esi,2
	lodsw
	push eax
	mov esi,edi
	add esi,2
	lodsw
	push eax
	mov eax,edi
	push eax
	call procedura
	ink:
	add ecx,1
	add edi,2

jmp wile
van:

lea esi,niz
wile2:
lodsw
cmp eax,0
je vani
jmp wile2
vani:
mov eax,0
main endp
end main