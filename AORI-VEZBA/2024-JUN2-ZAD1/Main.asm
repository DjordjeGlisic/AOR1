.386
.model flat,c
.data
N db 4
A dword ?
B dw ?
pom dword ?
.stack 4096
.code
main proc
mov edi,0
mov esi,0
mov eax,0
mov al,N
mov ebx,0
mov bl,N
mul bl
mov bx,ax
mov edx,0
mul bx
mov bx,ax
mov ax,dx
shl eax,16
mov ax,bx
mov pom,eax
mov ecx,0
mov cl,N
shr ecx,1
mov eax,0
petlja:
add eax,ecx
loop petlja
mov ecx,eax
wile:
mov ebx,esi
mov eax,edi
mov edx,eax
and edx,0FFFF0000h
shr edx,16
and eax,0000ffffh
cmp bx,0
je rad
div bx
mov ax,0
mov al,N
cmp dx,ax
je van
rad:
mov edx,0
mov eax,ecx
add eax,esi
mov ebx,pom
div ebx
mov edi,eax
inc esi
jmp wile
van:
ret
main endp
end main