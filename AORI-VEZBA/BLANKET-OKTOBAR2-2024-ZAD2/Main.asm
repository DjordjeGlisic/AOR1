.386
.model flat,c
.data
MATR word 1,0,2,3
	 word 7,3,5,6
	 word 9,3,3,9
	 word 6,1,9,12
	 word 4,3,6,18
N dword 4
M dword 5
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
mov esi,0
mov edi,0
mov ecx,[ebp+12]
petlja:
mov eax,[ebp+8]
add eax,edi
mov ax,word ptr [eax]
and eax,00000FFFFh
mov ebx,0
mov edx,0
mov bx,ax
shr eax,16
mov dx,ax
mov ax,bx
mov bx,3
div bx
cmp dx,0
jne dalje
inc esi
dalje:
add edi,2
loop petlja
mov [ebp+12],esi
pop esi
pop edi
pop edx
pop ecx
pop ebx
pop eax
pop ebp
ret 4
procedura endp
main proc
mov esi,-1
mov edi,-1
mov ebx,0
mov eax,M
dec eax
mov ecx,N
mov edx,0
mul cl
shl eax,1
mov edx,eax
wile:
cmp ebx,edx
ja van
mov eax,N
push eax
lea eax,MATR
add eax,ebx
push eax
call procedura
pop ecx
cmp ecx,edi
jle ink
mov esi,ebx
mov edi,ecx
ink:
mov eax,N
shl eax,1
add ebx,eax
jmp wile
van:
mov eax,esi
mov edx,0
mov ebx,N
shl ebx,1
div ebx
inc eax
ret
main endp
end main