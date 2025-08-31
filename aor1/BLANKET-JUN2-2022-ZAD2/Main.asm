.386
.model flat,c
.data
MAT byte 1,2,3,4
	byte 5,6,7,8
	byte 9,10,11,12
	byte 13,14,15,16
N dword 4
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
mov esi,[ebp+12]
mov edi,[ebp+8]
mov eax,0
mov ebx,0
mov al,[esi]
mov bl,[edi]
cmp al,bl
jne sporedna
mov eax,0
jmp glavna
sporedna:
jg elz
mov eax,1
jmp glavna
elz:
mov eax,2
glavna:
pop esi
pop edi
pop edx
pop ecx
pop ebx

popfd
pop ebp
ret 8
procedura endp
main proc
mov ebx,0
mov esi,0
mov eax,N
dec eax
mov ebx,N
mul bl
mov edx,eax
mov ebx,0
wile:
cmp ebx,edx
jae van
mov esi,0
wile2:
mov eax,N
cmp esi,eax
jae van2
lea eax,MAT
add eax,ebx
add eax,esi
push eax
lea eax,MAT
add eax,ebx
add eax,N
add eax,esi
push eax
call procedura
cmp eax,1
jne ifg
lea eax,MAT
add eax,ebx
add eax,esi
lea ecx,MAT
add ecx,ebx
add ecx,N
add ecx,esi
mov edi,ecx
mov ecx,0
mov cl,[edi]
mov [eax],cl
ifg:
inc esi
jmp wile2
van2:
add ebx,N
jmp wile
van:
ret
main endp
end main