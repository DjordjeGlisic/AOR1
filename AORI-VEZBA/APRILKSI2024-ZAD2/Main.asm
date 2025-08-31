.386
.model flat,c
.data
MAT dword 1,2,3,4,5
	dword 6,7,8,9,10
	dword 11,12,13,14,15
	dword 16,17,18,19,20
	dword 21,22,23,24,25
	dword 26,27,28,29,30
N dword 6
M dword 5
.stack 4096
.code
procedura proc
add ecx,edx
mov [eax],ecx
ret
procedura endp
main proc
mov edi,0
mov ebx,0
wile:
mov eax,N
dec eax
shl eax,2
mov edx,M
mul dl
push eax
cmp ebx,eax
ja van
mov esi,0
mov eax,edi
mov edx,2
div dl
cmp ah,0
je ink2
drugi:
mov eax,M
shl eax,2
cmp esi,eax
jae ink2
mov ecx,ebx
add ecx,esi
sub ecx,eax
mov edx,ebx
add edx,esi
add edx,eax
cmp ecx,0
jl ink1
pop eax
cmp edx,eax
jg ink1
lea eax,MAT
add ecx,eax
add edx,eax
add eax,ebx
add eax,esi
mov ecx,[ecx]
mov edx,[edx]
call procedura
ink1:
add esi,4
jmp drugi
ink2:
mov eax,M
shl eax,2
add ebx,eax
inc edi
jmp wile
van:
ret
main endp
end main