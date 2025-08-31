.386
.model flat,c
.data
N dword 4
M dword 5
mat BYTE '_','_','A','K','I'
	BYTE 'P','E','T','A','R'
	BYTE 'Z','I','K','A','_'
	BYTE '_','P','E','R','A'
maxVrsta dword ?
.stack 4096
.code
nadjiRec proc
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
mov ecx,[ebp+8]
mov edx,0
petlja:
mov eax,[ebp+12]
add eax,edx
mov eax,[eax]
cmp eax,'_'
je preskok
inc edi
preskok:
inc edx
loop petlja
popfd
pop esi
pop edi
pop ecx
pop ebx
pop eax
pop ebx
ret 4
	
nadjiRec endp
start proc
lea eax,mat
mov ebx,0
mov esi,-1
mov edi,-1
mov ecx,N
mov edx,1
wile:
cmp edx,ecx
je van
add eax,ebx
push eax
mov eax,M
push eax
call nadjiRec
pop eax
cmp eax,edi
jbe dalje
mov edi,eax
mov esi,ebx
dalje:
inc edx
add ebx,M
jmp wile
van:
mov maxVrsta,edi
ret
start endp
end