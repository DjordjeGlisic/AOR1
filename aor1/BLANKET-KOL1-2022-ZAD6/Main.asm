.386
.model flat,c
.data
N dword 0
M dword 32
.stack 4096
.code
main proc
mov esi,N
mov edi,M
mov eax,0
wile:
cmp esi,edi
jg van
mov ebx,esi
mov ecx,3
mov edx,0
petlja1:
shl esi,1
jnc elz1
inc edx
elz1:
loop petlja1
mov esi,ebx
shl edx,16
mov ecx,3
petlja2:
shr esi,1
jnc elz2
inc dl
elz2:
loop petlja2
cmp dh,dl
jne ink
inc eax
ink:
mov esi,ebx
inc esi
jmp wile
van:
ret
main endp
end main