.386
.model flat,c
.data
MAT dword 1,2,3,4
	dword 5,6,7,8
	dword 9,10,11,12
	dword 13,14,15,16
N dword 4
NIZ dword ?
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
mov edi,0ffffffffh
mov esi,0
mov ecx,[ebp+8]

petlja:
mov eax,[ebp+12]
add eax,esi
mov eax,[eax]
cmp eax,edi
jle ink
mov edi,eax
ink:
add esi,4
loop petlja
mov [ebp+12],edi
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
mov esi,0
mov edi,0
mov eax,N
dec eax
mov ebx,N
shl ebx,2
mul ebx
mov ecx,eax
wile:
cmp esi,ecx
ja van
lea eax,MAT
add eax,esi
push eax
mov eax,N
push eax
call procedura
pop eax
lea ebx,NIZ
add ebx,edi
mov [ebx],eax
add edi,4
mov edx,N
shl edx,2
add esi,edx
jmp wile
van:
ret
main endp
end main