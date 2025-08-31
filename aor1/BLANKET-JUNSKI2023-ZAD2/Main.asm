.386
.model flat,c
.data
N dword 4
MAT dword 1,7,9,6
	dword 2,0,1,3
	dword 4,2,1,0
	dword 3,2,1,1
NIZ dword 10 DUP(0)
pom dword ?
pom2 dword ?

.stack 4096
.code
procedura proc
push ebp
mov ebp,esp
pushfd
push eax
push ebx
push ecx
push edx
push esi
push edi
mov esi,[ebp+12]
mov edi,[ebp+8]
mov eax,0
mov edx,edi
mov ecx,edi
dec ecx
petlja:
add edx,edi
loop petlja
mov ecx,[ebp+8]
sub ecx,eax
mov pom2,ecx
wajl:
cmp eax,edx
ja vaan
mov ecx,pom2
dec ecx
cmp ecx,0
je dodaj

mov pom2,ecx
mov ebx,eax
add ebx,4
un:
mov esi,[ebp+12]
add esi,eax
mov edi,[ebp+12]
add edi,ebx
mov esi,[esi]
mov edi,[edi]
cmp esi,edi
jle els
mov pom,esi
mov esi,[ebp+12]
add esi,eax
mov [esi],edi
mov edi,[ebp+12]
add edi,ebx
mov esi,pom
mov [edi],esi
els:
add ebx,4

loop un
dodaj:
add eax,4
jmp wajl
vaan:
pop edi
pop esi
pop edx
pop ecx
pop ebx
pop eax
popfd
pop ebp
ret 8
procedura endp
main proc
mov edx,N
dec edx
mov eax,edx
mov edx,4
mul dl
mov edx,eax
mov ecx,0
mov ebx,N
dec ebx
mov eax,N

mul bl
mov ebx,4
mul bl
mov ebx,0
wile:
cmp ebx,eax
ja van
lea edi,NIZ
add edi,ecx
lea esi,MAT
add esi,ebx
add esi,edx
mov esi,[esi]
mov [edi],esi
add ecx,4
sub edx,N
add ebx,N
add ebx,N
add ebx,N
add ebx,N
jmp wile
van:
lea eax,NIZ
push eax
mov eax,N
push eax
call procedura
mov ebx,0
mov edx,N
dec edx
mov eax,4
mul dl
mov edx,eax
mov ecx,0
mov eax,N
mov ebx,eax
dec ebx
mul bl
mov ebx,4
mul bl
mov ebx,0
wile2:
cmp ebx,eax
ja van2
lea esi,MAT
lea edi,NIZ
add esi,ebx
add esi,edx
add edi,ecx
mov edi,[edi]
mov [esi],edi
add ecx,4
sub edx,4
add ebx,N
add ebx,N
add ebx,N
add ebx,N
jmp wile2
van2:

ret
main endp
end main