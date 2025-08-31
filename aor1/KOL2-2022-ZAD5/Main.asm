.386
.model flat,c
.data
MAT dword 1,2
	dword 3,4
	dword 5,6
	dword 7,8
N dword 4
REZ dword ?
NIZ dword ?
.stack 4096
.code
procedura proc
push ebp
mov ebp,esp
pushfd
push ebx
push ecx
push edi
push esi
cmp eax,edx
jge drugiif
mov REZ,edx
jmp kraj
drugiif:
je elze
mov REZ,eax
jmp kraj
elze:
mov REZ,eax
kraj:
lea ebx,REZ
mov [ebp+8],ebx
pop esi
pop edi
pop ecx
pop ebx
popfd
pop ebp
ret
procedura endp
main proc
mov ebx,0
mov edi,0
mov ecx,2
shl esi,cl
mov eax,N
dec eax
mov ecx,1
shl eax,cl
mov ecx,2
shl eax,cl
mov ecx,eax
wile:
cmp ebx,ecx
ja van
lea eax,REZ
push eax
lea eax,MAT
add eax,ebx
mov eax,[eax]
lea edx,MAT
add edx,ebx
add edx,4
mov edx,[edx]
call procedura
pop edx
lea eax,NIZ
add eax,edi
mov edx,[edx]
mov [eax],edx
add edi,4
add ebx,8
jmp wile
van:
lea eax,NIZ
ret
main endp
end main