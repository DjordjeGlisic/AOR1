.386
.model flat,c
.data
X dword 25
N dw 10
.stack 4096
.code
main proc
mov esi,0
mov edi,4
wile:
mov eax,0
mov ax,N
cmp edi,eax
ja van
mov ebx,edi
and ebx,00ffh
shl ebx,1
mov eax,X
add eax,ebx
mov ebx,edi
xor ebx,0ff00h
shl ebx,1
add ebx,X
mov edx,0
div ebx
add esi,eax
inc edi
jmp wile
van:
mov eax,esi
ret
main endp
end main