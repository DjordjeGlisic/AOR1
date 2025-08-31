.386
.model flat,c
.data
N db 0Ah
.stack 4096
.code
main proc
mov eax,0
mov al,N
mov edi,eax
mov edx,0
mov cl,al
shr cl,1
petlja:
add dl,cl
adc dh,0
loop petlja
mov edi,edx
mov ah,al
mul al
mov bx,ax
mov dx,0
mul bx
mov ebx,0
mov bx,dx
shl ebx,16
mov bx,ax
mov esi,0
mov ecx,0
mov cl,1
wile:
mov al,N
cmp cl,al
ja van
mov eax,0
mov al,cl
add eax,edi
mov edx,0
div ebx
add esi,eax
inc cl
jmp wile
van:
ret
main endp
end main