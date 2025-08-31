.386
.model flat,c
.data
X dw 5
Y dw 88
S dword 0
.stack
.code
main proc
mov edi,0
wile:
mov eax,0
mov ax,X
mov ebx,0
mov bx,Y
cmp eax,ebx
ja van
cmp edi,20
jae van
mov eax,0
mov ax,Y
mov ecx,3
shr eax,cl
mov ebx,0
mov bx,X
add eax,ebx
mov X,ax
mov edx,0
mov eax,0
mov ax,Y
mov ebx,3
mul bx
mov ebx,0
mov bx,X
div bx
mov ebx,eax
mov eax,5
mov ecx,0
mov cx,X
add eax,ecx
sub eax,ebx
mov Y,ax
mov eax,S
add ax,X
adc eax,0
add ax,Y
adc eax,0
inc edi
jmp wile
van:
mov eax,0
mov ax,X
mov ebx,0
mov bx,Y
mov ecx,S
ret
main endp
end main