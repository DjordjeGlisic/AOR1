.386
.model flat,c
PUBLIC procedura
.data
.stack 4096
.code
procedura proc
push ebp
mov ebp,esp
pushfd
push ebx
push ecx
push edx
push edi
push esi
mov esi,0
mov edi,0
mov ecx,[ebp+12]

petlja:
mov edx,[ebp+8]
add edx,esi
mov eax,0
mov ax,[edx]
cmp ax,0
jge ink
mov ebx,[ebp+16]
add ebx,edi
mov [ebx],ax
add edi,2
ink:
add esi,2
loop petlja
mov eax,edi
shr eax,1
pop esi
pop edi
pop edx
pop ecx
pop ebx
popfd
pop ebp
ret
procedura endp
end