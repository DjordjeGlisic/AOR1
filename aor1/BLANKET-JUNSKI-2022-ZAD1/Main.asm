.386
.model flat,c
.data
X dword 7
N dword 5
p db 8
pom dword ?
SUM dword ?
.stack 4096
.code
main proc
mov ecx,0
mov edi,0ffffffffh
mov esi,00ffffffffh
mov cl,p
petlja:
shr edi,1
shl esi,1
loop petlja
mov ecx,0
mov edx,1
wile:
mov eax,N
cmp edx,eax
ja van
mov pom,edx
and edx,edi
mov eax,X
add eax,edx
mov edx,pom
and edx,esi
mov ebx,X
cmp ebx,edx
jae elz
mov ebx,edx
sub ebx,X
jmp deli
elz:
sub ebx,edx
deli:
mov edx,0
div ebx
add ecx,eax
mov edx,pom
inc edx
jmp wile
van:
mov SUM,ecx
ret
main endp
end main