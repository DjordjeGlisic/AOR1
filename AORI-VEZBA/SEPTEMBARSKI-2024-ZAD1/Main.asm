.386
.model flat,c
.data
A dword 2 
B dw 4
Ce dw 3
.stack 4096
.code
main proc
mov ecx,0
mov cx,2
mov edi,0
mov eax,0
mov ax,B
mov esi,eax
wile:
cmp ecx,esi
ja van
mov eax,0
mov ax,cx
xor ax,0FFFFh
mov ebx,0
mov bx,3
mul bx
mov ebx,A
sub eax,ebx
mov ebx,0
mov bx,cx
shl ebx,1
add ebx,A
mov edx,0
div ebx
inc cx
add edi,eax
jmp wile
van:
mov eax,edi
mov ebx,esi
mov ecx,0
mov cx,Ce
add ebx,ecx
mov edx,0
div ebx
mov eax,ebx
ret
main endp
end main