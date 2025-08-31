.386
.model flat,c
.data
niz dword 0abcdh,0ab23h,7271h,3214h,0a11bh,0aabfh,0ac13h,0
.stack 4096

.code
procedura proc
push ebp
mov ebp,esp
pushfd
pushad
mov ecx,32
mov eax,[ebp+8]
mov ebx,0
petlja:
shr eax,1
jnc kraj
inc ebx
kraj:
loop petlja
mov edx,0
mov eax,ebx
mov ecx,0
mov cl,2
div ecx
cmp edx,0
jne jedan
mov eax,0
jmp inic
jedan:
mov eax,1
inic:
mov [ebp+8],eax
popad
popfd
pop ebp
ret
procedura endp
main proc
mov edi,0
mov ecx,0
mov esi,0
wile:
mov eax,0
mov ebx,niz[ecx]
push ebx
call procedura
pop ebx
add eax,ebx
cmp eax,1
jne v
mov edx,ecx
mov ecx,esi
cmp esi,0
jne pet
xor edi,eax
jmp v
pet:
mov eax,1
mov ebx,2
unutrasnja:
mul bl
loop unutrasnja
xor edi,eax
mov ecx,edx
v:
add ecx,4
inc esi
cmp niz[ecx],0
je van
jmp wile
van:
mov eax,edi
ret
main endp
end main