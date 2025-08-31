.386
.model flat,c
.data
n dw 5
kol dw ?
ostatak dw ?
pom dw ?
.stack 4096
.code
main proc
mov edi,0
mov eax,0
mov ax,n
mov esi,0
wile:
cmp edi,eax
ja van
mov ebx,edi
dec ebx
sub eax,ebx
mov edx,0
mov ebx,eax
mov eax,edi
mul bx
mov pom,ax
mov ax,dx
shr eax,16
mov ax,pom
mov ecx,edi
dec ecx
shr eax,cl
add esi,eax
inc edi
mov eax,0
mov ax,n
jmp wile
van:
mov eax,esi
mov pom,ax
shr eax,16
mov edx,0
mov dx,ax
mov ax,pom
mov ecx,0
mov cx,n
div cx
mov kol,ax
mov ostatak,dx
ret
main endp
end main