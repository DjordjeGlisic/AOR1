.386
.model flat,c
.data
N dword ?
M dword ?
P dword ?
S dw 16
.stack 4096
.code
main proc
mov ecx,1
mov edi,1
mov edx,0
mov esi,1
wile:
mov edx,0
mov dx,S
cmp edi,edx
ja van
mov eax,edi
mov ebx,5
mul ebx
mov esi,eax
mov eax,0
mov ax,cx
mov edx,0
mul cx
mov bx,ax
mov ax,dx
shl eax,16
mov ax,bx
mov edx,eax
sub esi,edx
cmp esi,0
jge drugiIzraz
neg esi
drugiIzraz:
mov eax,0
mov ax,S
mov ebx,0
mov bl,8
div bl
cmp ah,0
je dalje
inc al
dalje:
mov ah,0
add edi,eax
mov edx,edi
add edx,esi
inc edx
mov P,edx
inc ecx
jmp wile
van:

mov N,edi
mov M,esi
ret
main endp
end main