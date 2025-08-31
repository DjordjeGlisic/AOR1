.386
.model flat,c
.data

N dword 5
NIZ dword 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0
MAT dword ?
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
mov ebx,[ebp+8]
mov ebx,[ebx]
mov [eax],ebx
pop esi
pop edi
pop edx
pop ecx
pop ebx
pop eax
popfd
pop ebp
ret 8
procedura endp
main proc
mov ebx,0
mov esi,0
mov edi,0
wile:
mov eax,N
shl eax,2
cmp esi,eax
jae van
mov ebx,0
mov ecx,N
petlja:
lea eax,MAT
add eax,ebx
add eax,esi
push eax
lea eax,NIZ
add eax,edi
push eax
call procedura
mov edx,N
shl edx,2
add ebx,edx
add edi,4
lea eax,NIZ
add eax,edi
sub eax,4
mov eax,[eax]
cmp eax,0
jne ink
mov edi,0
ink:
loop petlja
add esi,4
jmp wile
van:
mov eax,0
main endp
end main