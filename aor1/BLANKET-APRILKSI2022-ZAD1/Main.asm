.386
.model flat,c
.data
X dword 0ffabh
Y dword 0aabbh
Z dword 0ffffh
.stack 4096
.code
main proc
mov ecx,0
mov edi,X
mov esi,Y
wile:
cmp ecx,100
jae van
cmp edi,esi
jb van
mov eax,edi
shl eax,2
mov ebx,esi
inc ebx
mov edx,0
div ebx
mov edi,eax
mov eax,esi
shl eax,1
mov ebx,Z
shl ebx,2
add eax,ebx
mov esi,eax
inc ecx
jmp wile
van:
ret
main endp
end main