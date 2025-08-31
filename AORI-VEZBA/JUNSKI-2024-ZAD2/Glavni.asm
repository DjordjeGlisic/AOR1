.386
.model flat,c
PUBLIC PROCEDURA
.data
.stack 4096
.code
PROCEDURA proc

push ebp
mov ebp,esp
push eax
push ebx
push ecx
push edx
push edi
push esi
pushfd
mov edi,0
mov esi,[ebp+12]
shl esi,2
wile:
cmp edi,esi
jae van
mov eax,[ebp+8]
mov ebx,eax
add eax,edi
add ebx,esi
mov ecx,[eax]
mov edx,[ebx]
mov [eax],edx
mov [ebx],ecx
add edi,4
sub esi,4
jmp wile
van:
popfd
pop esi
pop edi
pop edx
pop ecx
pop ebx
pop eax
pop ebp
ret
PROCEDURA endp
end