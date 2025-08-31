.386
.model flat,c
.data
X dw 7
Y dw 2
Z dw 3
.stack 4096
.code
main proc
mov eax,0
mov ax,X
mov ebx,0
mov bx,Y
mov esi,eax
mov edi,ebx
wile:
cmp esi,0
je van
cmp edi,1
jbe van
mov eax,0
mov ax,Y
dec ax
mov ebx,0
mov bx,X
mov edx,0
mul bx
mov bx,ax
mov ax,dx
shl eax,16
mov ax,bx
add eax,10
mov ebx,0
mov bx,Y
dec bx
mov ecx,0
mov cx,Z
add ebx,ecx
mov ecx,eax
mov eax,ebx
mov edx,0
mul ebx
mov ebx,eax
mov eax,ecx
mov edx,0
div ebx
mov esi,eax
mov ebx,0
mov bx,Y
shr bx,1
add ebx,1
mov edi,ebx
jmp wile
van:
ret
main endp
end main
