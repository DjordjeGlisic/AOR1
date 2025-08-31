.386
.model flat,c
.data
N dword 10
SUM dword ?
.stack 4096
.code
main proc
mov edi,N
mov esi,0
mov ecx,1
wile:
cmp ecx,edi
ja van
mov eax,edi
mov ebx,ecx
mov edx,0
mul ebx
mov bx,ax
mov ax,dx
shl eax,16
mov ax,bx
mov ebx,ecx
dec ebx
mov edx,ecx
mov ecx,ebx
shr eax,cl
mov ecx,edx
add esi,eax
inc ecx
jmp wile
van:
mov SUM,esi
ret
main endp
end main