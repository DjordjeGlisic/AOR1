.386
.model flat,c
.data
n dw 0
S dw ?
.stack 4096
.code
main proc
mov eax,0
mov ax,n
mov edi,eax
mov ax,0
wile:
mov eax,0
mov dx,1
mov ecx,edi
cmp ecx,0
je dalje
dec ecx
petlja:
add ax,dx
inc dx
cmp ecx,0
je dalje
loop petlja
dalje:
inc edi
mov edx,0
mov bl,2
mov cx,ax
div bl
mov dl,ah
cmp ah,0
jne wile
cmp ax,2
jbe wile
van:
mov eax,ecx
shr ecx,1
mov dx,ax
pe:
inc edi
sub dx,2
cmp dx,2
je kraj
loop pe
kraj:
mov S,ax
mov ebx,edi
mov n,bx
ret
main endp
end main