.386
.model flat,c
.data
X dword 40
Y dword 15
Z dword 4
.stack 4096
.code
main proc
mov esi,0
wile:
cmp esi,100
jae van
mov edx,X
mov edi,Y
cmp edx,edi
jb van
mov ebx,Y
inc ebx
mov eax,X
mov cl,2
shl eax,cl
mov edx,0
div ebx
mov ebx,Y
mov edx,Z
mov cl,1
shr ebx,cl
mov cl,2
shr edx,cl
add ebx,edx
inc esi
mov Y,ebx
mov X,eax
jmp wile
van:
ret
main endp
end main