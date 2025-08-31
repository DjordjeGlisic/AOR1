.386
.model flat,c
.data
A dword 012ab7412h
M dw 10
K db 4
p dw ?
pom dw ?
visi db ?
del dword ?
.stack 4096
.code
main proc
mov esi,0;sum ce biti u esi
mov eax,0;p=0
mov p,ax
mov eax,0
mov al,k
mov ecx,32
sub ecx,eax 
mov edi,0ffffffffh
petljaPom:
shr edi,1
loop petljaPom
mov ecx,0
mov cx,M;M=10
wile:
mov eax,0
mov ax,p
cmp ax,cx
ja van
and eax,edi
mov ebx,4
mov edx,0
mul bx
mov pom,ax
mov ax,dx
shl eax,16
mov ax,pom
mov edx,0
mov ebx,A
add eax,ebx
adc edx,0
mov visi,dl
mov del,eax
mov eax,0
mov ax,p
mov ebx,4
mov edx,0
mul bx
mov pom,ax
mov ax,dx
shl eax,16
mov ax,pom
mov ebx,A
sub ebx,eax
mov edx,0
mov dl,visi
mov eax,del
div ebx
add esi,eax
mov eax,0
mov ax,p
inc ax
mov p,ax
jmp wile
van:
mov eax,esi

ret
main endp
end main