.model flat,c
.data
A db 3
B db 4
S dword ?
.stack 4096
.code
main proc
mov esi,0
mov edx,0
wile:
mov ecx,100
sub ecx,esi
jnc van
mov eax,0
mov ebx,0
mov ecx,edx
mov edx,0
mov al,A
mov bl,B
mul bl
mov ebx,eax
mul bx
mov bx,ax
mov ax,dx
shl eax,16
mov ax,bx
mov ebx,eax
mov edx,ecx
sub ebx,edx
jnc van
inc esi
mov ecx,esi
mov eax,0
mov al,A
sub esi,eax
jns elz
mov eax,0
mov al,A
dec al
mov ebx,0
mov bl,b
mul bl
shl eax,2
add edx,eax
jmp wile
elz:
mov eax,0
mov al,A
add dl,al
adc dh,0
jnc wile
mov ax,dx
shr edx,16
add dl,1
adc dh,0
shl edx,16
mov dx,ax
jmp wile
van:
mov S,edx
ret
main endp
end main