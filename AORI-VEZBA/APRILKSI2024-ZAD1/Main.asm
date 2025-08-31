.386
.model flat,c
.data
B dw 3
Ce dw 1
A dword 32
.stack 4096
.code
main proc
mov esi,0
mov ecx,2
mov edx,0
mov cx,2
wile:
mov dx,B
cmp cx,dx
ja van
mov eax,0
mov ax,cx
xor ax,0ff00h
mov ebx,0
mov bx,ax
add bx,ax
adc dl,0
mov edi,eax
mov ax,bx
mov bx,dx
shl ebx,16
mov bx,ax
mov eax,edi
add ebx,eax
mov edx,A
sub ebx,edx
mov eax,ebx
mov ebx,0
mov bx,cx
shl ebx,1
add ebx,edx
mov edx,0
div ebx
add esi,eax
inc cx
jmp wile
van:
mov ebx,0
mov ecx,0
mov edx,0
mov bx,B
mov cx,Ce
add ebx,ecx
mov edx,0
mov eax,esi
div ebx
ret
main endp
end main