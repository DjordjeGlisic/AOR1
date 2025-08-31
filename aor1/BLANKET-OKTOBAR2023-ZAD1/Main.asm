.386
.model flat,c
.data
n dw 0ah
pom dw ?
sum dword ?
.stack 4096
.code
main proc
mov eax,0
mov ax,n
mov esi,eax
mov eax,2
mov ebx,1
mov ecx,1
wile:
cmp ax,n
ja van
cmp bx,n
jae van
mov edx,0
mov dx,n
sub dx,bx
mov edi,eax
mul dx
mov pom,ax
mov ax,dx
shl eax,16
mov ax,pom
mov edx,edi
drugiWile:
cmp edx,0
je va
shr eax,1
dec edx
jmp drugiWile
va:
cmp cx,1
jne els
sub esi,eax
jmp ink
els:
add esi,eax
ink:
mov eax,edi
inc eax
inc ebx
cmp cx,1
jne wi
mov ecx,0
jmp wile
wi:
mov ecx,1
jmp wile
van:
mov sum,esi
ret
main endp
end main
