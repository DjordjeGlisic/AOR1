.386
.model flat,c
.data
P dword 8
Q dword 2
n dword 5
m dword 10
x dword ?
.stack 4096
.code
main proc
mov esi,m
inc esi
mov ecx,0
wile:
mov eax,P
sub eax,ecx
mov ebx,eax
mov edx,0
imul ebx
mov ebx,Q
add ebx,ecx
idiv ebx
cmp edx,0
jne ink
cmp eax,n
jl ink
cmp eax,m
jg ink
cmp eax,esi
jge ink
mov esi,eax
ink:
inc ecx
cmp eax,m
jle wile
cmp ecx,p
jle wile
mov x,esi
ret
main endp
end main