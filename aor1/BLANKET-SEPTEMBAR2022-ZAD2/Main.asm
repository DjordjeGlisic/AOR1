.386
.model flat,c
.data
MAT dword 10,2,-3,4
	dword 11,5,-6,0
	dword 12,7,8,9
	dword 13,10,11,12
N dword 4
REZ dword ?
.stack 4096
.code
procedura proc
push ebp
mov ebp,esp
pushfd
push eax
push ebx
push ecx
push edx
push edi
push esi
mov eax,[ebp+12]
mov ebx,eax
add ebx,4
mov edi,0
mov eax,[eax]
mov ecx,[ebp+8]
dec ecx
petlja:
mov edx,[ebx]
add edi,edx
add ebx,4
loop petlja
cmp eax,edi
jg elz
mov eax,1
jmp kraj
elz:
mov eax,0
jmp kraj
kraj:
mov [ebp+12],eax
pop esi
pop edi
pop edx
pop ecx
pop ebx
pop eax
popfd
pop ebp
ret 4
procedura endp
main proc
mov ecx,0
mov edi,0
mov eax,N
dec eax
shl eax,2
mov ebx,N
mul bl
mov esi,eax
mov ebx,0
wile:
cmp ebx,esi
ja van
lea eax,MAT
add eax,ebx
push eax
mov eax,N
push eax
call procedura
pop eax
cmp eax,1
jne ink
cmp edi,0
jne ink
mov edx,ecx
mov edi,1
ink:
inc ecx
mov eax,N
shl eax,2
add ebx,eax
jmp wile
van:
mov REZ,edx
ret
main endp
end main