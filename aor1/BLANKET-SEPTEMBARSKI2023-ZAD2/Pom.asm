.386
.model flat,c
PUBLIC izmeniText
.data
.stack 4096
.code
izmeniText proc
push ebp
mov ebp,esp
push ebx
push ecx
push edx
push edi
push esi
pushfd
mov edi,0
mov esi,0
wile:
mov eax,[ebp+12]
cmp esi,eax
je van
drugiWile:
mov eax,[ebp+8]
add eax,esi
mov ebx,eax
mov eax,0
mov al,byte ptr [ebx]
cmp al,'_'
jne drugiVan
inc esi
jmp drugiWile
drugiVan:
mov eax,[ebp+12]
cmp esi,eax
je van
izlaz:
inc edi
mov ebx,esi
mov edx,'a'
wileRec:
mov eax,[ebp+8]
add eax,esi
mov ecx,eax
mov eax,0
mov al,byte ptr [ecx]
mov ecx,[ebp+12]
cmp eax,ecx
je vanRec
cmp al,'_'
je vanRec
cmp dl,al
jae slovo
mov dl,al
slovo:
inc esi
jmp wileRec
vanRec:
cmp esi,ecx
jne prva
mov eax,[ebp+8]
add eax,esi
mov [eax],dl
jmp kraj
prva:
cmp edi,1
je kraj
mov eax,[ebp+8]
add eax,ebx
dec eax
mov [eax],dl
kraj:
jmp wile
van:
mov eax,[ebp+8]
popfd
pop esi
pop edi
pop edx
pop ecx
pop ebx
pop ebp
ret 8
izmeniText endp
end izmeniText