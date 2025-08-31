.386
.model flat,c
.data
N dword 11
NIZ dword 0,0,0,1,3,5,7,9,12,14,20
SUM dword ?
.stack 4096
.code
main proc
mov esi,0
mov edi,0
mov edx,0
mov ecx,0
wile:
mov eax,N
cmp edx,eax
jae van
cmp ecx,0
jne suma
lea eax,NIZ
lea ebx,NIZ
add eax,edi
add ebx,edi
add ebx,4
mov eax,[eax]
mov ebx,[ebx]
cmp eax,0
jne ink
cmp ebx,0
je ink
mov ecx,1
suma:
lea eax,NIZ
add eax,edi
mov eax,[eax]
add esi,eax
ink:
inc edx
add edi,4
jmp wile
van:
mov SUM,esi
ret
main endp
end main