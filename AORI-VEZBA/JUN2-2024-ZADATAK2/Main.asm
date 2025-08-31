.386
.model flat,c
.data
N dword 4
M dword 3
MAT dword 1,3,-1,0
	dword -1,7,-8,-1
	dword 2,-9,-12,-2
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
mov edi,0
mov esi,0
wile:
mov ecx,[ebp+12]
cmp edi,ecx
jae van
mov eax,[ebp+8]
add eax,edi
mov eax,[eax]
cmp eax,0
jle dalje
mov ebx,[ebp+16]
add ebx,esi
mov [ebx],eax
add esi,4
dalje:
add edi,4
jmp wile
van:
mov ebx,[ebp+16]
add ebx,esi
mov eax,-1
mov [ebx],eax
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
mov eax,0
mov eax,M
shl eax,2
mov ebx,N
mov edx,0
mul ebx
lea ebx,NIZ
push ebx
push eax
lea ebx,MAT
push ebx
call procedura
pop eax
ret
main endp
end main