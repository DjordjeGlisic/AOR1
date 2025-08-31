.386
.model flat,c
PUBLIC modifikujNiz
.data
.stack 4096
.code
modifikujNiz proc
push ebp
mov ebp,esp
pushfd
push eax
push ebx
push ecx
push edx
push esi
push edi
mov edx,0
mov ecx,0
wile:
mov esi,[ebp+20]
cmp ecx,esi
jae van
mov esi,[ebp+24]
add esi,edx
mov edi,[ebp+8]
cmpsd
js ifg
jz ifg
mov edi,[ebp+12]
mov esi,[ebp+24]
add esi,edx
cmpsd
jns ifg
jz ifg
mov edi,[ebp+24]
add edi,edx
mov esi,[ebp+16]
movsd
ifg:
add edx,4
inc ecx
jmp wile
van:
pop edi
pop esi
pop edx
pop ecx
pop ebx
pop eax
popfd
pop ebp
ret
modifikujNiz endp
end