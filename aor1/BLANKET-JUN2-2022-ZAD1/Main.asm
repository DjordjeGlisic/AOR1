.386
.model flat,c
.data
N dw 10
KOL dword ?
OST dword ?
pom dw ?
.stack 4096
.code
main proc
mov edi,0
mov esi,0
mov edx,1
wile:
mov ecx,0
mov cx,N
cmp dx,cx
jae van
mov eax,edx
mov ebx,2
mul bl
mov ebx,0
mov bx,N
sub ebx,edx
mov ecx,edx
mov edx,0
mul bx
mov pom,ax
mov ax,dx
shl eax,16
mov ax,pom
add esi,eax
adc edi,0
mov edx,ecx
inc edx
jmp wile
van:
mov eax,0
mov ax,N
add esi,eax
adc edi,0
mov eax,0
mov ax,N
mov ebx,000ffh
and eax,ebx
mov ebx,eax
mov ecx,2
petlja:
mul bl
loop petlja
mov ebx,eax
mov edx,edi
mov eax,esi
div ebx
mov KOL,eax
mov OST,edx
ret
main endp
end main