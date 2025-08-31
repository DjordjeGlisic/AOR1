PUBLIC procedura
.386
.model flat,c
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
mov eax,[ebp+8]
inc eax
mov ebx,0
mov bl,[eax]
mov ecx,[ebp+8]
mov edx,0
mov dl,[ecx]
wile:
cmp bl,'0'
je van
cmp bl,dl
jne van
inc esi
inc eax
mov ebx,0
mov bl,[eax]
jmp wile
van:
mov eax,esi
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