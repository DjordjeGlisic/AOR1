.386
.model flat,c
.data
TEKST db 'p','r','v','a','_','r','e','c','_','_','d','r','u','g','a','_','r','e','c','_','_','_','t','r','e','c','a','_','_','_','r','e','c'
K dword 4
.stack 4096
.code
procedura proc
push ebp
mov ebp,esp
push ecx
push edx
push edi
push esi
pushfd
mov edx,0
mov ecx,[ebp+12]
mov esi,0
mov edi,0
traziRec:
mov ebx,[ebp+8]
cmp edx,ebx
jae nadjeno
mov eax,0
mov al,[ecx]
cmp al,'0'
je nadjeno
cmp al,'_'
jne el
blanko:
mov eax,0
mov al,[ecx]
cmp al,'_'
jne rec
inc ecx
jmp blanko
rec:
inc edx
jmp ink
el:
inc ecx
ink:
jmp traziRec
nadjeno:
cmp edx,ebx
jne kraj
mov eax,[ebp+12]
mov esi,ecx
sub esi,eax
traziKraj:
mov eax,0
mov al,[ecx]
cmp al,'_'
je dalje
cmp al,'0'
je dalje
inc ecx
jmp traziKraj
dalje:
mov eax,[ebp+12]
mov edi,ecx
sub edi,eax
kraj:
mov eax,esi
mov ebx,edi
popfd
pop edi
pop esi
pop edx
pop ecx
pop ebp
ret 4
procedura endp
main proc
lea eax,TEKST
push eax
mov eax,K
push eax
call procedura
mov edi,eax
mov esi,ebx
main endp
end main