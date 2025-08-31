.386
.model flat,c
.data
MAT dw 1,6,11,16
	dw 2,7,12,17
	dw 3,8,13,18
	dw 4,9,14,19
	dw 5,10,15,20
N dword 4
M dword 5
pom dw ?
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
push edi
push esi
mov esi,0
mov ebx,[ebp+8]
mov ecx,ebx
mov edx,0
petlja:
mov eax,[ebp+12]
add eax,edx
mov edi,eax
mov eax,0
mov ax,[edi]
add esi,eax
add edx,2
loop petlja
mov eax,esi
mov pom,ax
shr eax,16
mov edx,0
mov dx,ax
mov ax,pom
div bx
mov [ebp+12],eax
pop esi
pop edi
pop edx
pop ecx
pop ebx
pop eax
popfd
pop ebp
ret 4
procedura endp
main proc
mov esi,4
mov ebx,N
mov eax,M
dec eax
mul bl
mov ebx,2
mul bl
mov edx,eax
mov ebx,0
wile:
cmp ebx,edx
ja van
lea eax,MAT
add eax,ebx
push eax
mov eax,N
push eax
call procedura
pop eax
lea edi,MAT
add edi,ebx
add edi,esi
mov ecx,0
mov cx,[edi]
cmp cx,ax
jbe dalje
mov [edi],ax
dalje:
add ebx,N
add ebx,N
jmp wile
van:
ret
main endp
end main