.386
.model flat,c
.data
pom dword ?
N dw 7
SUM1 dword ?
SUM2 dword ?
.stack 4096
.code
main proc
mov edi,0
mov esi,0
mov ecx,2
wile:
mov eax,0
mov ax,N
cmp ecx,eax
ja van
mov eax,ecx
shl eax,1
inc 
mov ebx,ecx
mov edx,ecx
add bx,dx
adc ebx,0
add bx,dx
adc ebx,0
inc ebx
mul ebx
mov ebx,ecx
mul ebx
mov ebx,ecx
inc ebx
div ebx
mov pom,eax
mov eax,ecx
mov ebx,2
div bx
mov eax,pom
cmp dx,0
jne smanji
add esi,eax
adc edi,0
jmp ink
smanji:
sub esi,eax
jns ink:
sub edi,1
ink:
inc ecx
jmp wile
van:
mov esi,SUM2
mov edi,SUM1
ret
main endp
end main