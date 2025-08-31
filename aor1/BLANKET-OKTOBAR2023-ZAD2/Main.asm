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
pom dword ?
count dword ?
podatak db ?
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
mov eax,[ebp+16]
mov ebx,0
mov edx,1
mov edi,-1
mov esi,-1
wile:
mov eax,[ebp+12]
cmp edx,eax
ja van
mov ecx,0
mov count,ecx
mov ecx,[ebp+8]
mov pom,esi
mov esi,0
petlja:
mov eax,[ebp+16]
add eax,ebx
add eax,esi
mov al,byte ptr [eax]
mov podatak,al
mov eax,0
mov al,podatak
cmp eax,'_'
je dalje
mov eax,count
inc eax
mov count,eax
dalje:
inc esi
loop petlja
mov eax,count
cmp eax,edi
jle ink
mov edi,eax
mov esi,edx
mov pom,esi
ink:
inc edx
add ebx,[ebp+8]
mov esi,pom
jmp wile

van:
mov [ebp+16],esi
popfd
pop esi
pop edi
pop edx
pop ecx
pop ebx
pop eax
pop ebp
ret 8
	
nadjiRec endp
start proc
lea eax,mat
push eax
mov eax,N
push eax
mov eax,M
push eax
call nadjiRec
pop eax
mov maxVrsta,eax

ret
start endp
end start