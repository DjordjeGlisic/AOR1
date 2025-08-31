.386
.model flat,c
.data
N dword 5
MAT dword 1,2,3,4,5
	dword 6,7,8,9,10
	dword 11,12,13,14,15
	dword 0,0,1,1,0
	dword 1,1,0,0,0
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
mov esi,0
mov edi,0
mov ecx,[ebp+8]

petlja:
mov eax,[ebp+12]
add eax,edi
mov eax,[eax]
add esi,eax
add edi,4
loop petlja
mov [ebp+12],esi
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
mov edi,90
mov esi,00fffffffh
mov ecx,1
mov ebx,0
mov edx,N
shl edx,2
mov eax,N
dec eax
mul dx
mov edx,eax
wile:
cmp ebx,edx
ja van
lea eax,MAT
add eax,ebx
push eax
mov eax,N
push eax
call procedura
pop eax
cmp eax,esi
jge skok
mov esi,eax
mov edi,ecx
skok:
inc ecx
mov eax,N
shl eax,2
add ebx,eax
jmp wile
van:
mov REZ,edi
ret
main endp
end main