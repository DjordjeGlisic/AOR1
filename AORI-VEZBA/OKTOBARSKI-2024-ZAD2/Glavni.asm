.386
.model flat,c
PUBLIC PROCEDURA
.data
.stack 4096
.code
PROCEDURA proc
push ebp
mov ebp,esp
push eax
push ebx
push ecx
push edx
push esi
push edi
pushfd
mov edx,0
				mov esi,0
				mov ebx,0
				mov edi,[ebp+20]
				mov ecx,[ebp+8]
				spoljni:
				mov eax,[ebp+16]
				shl eax,1
				cmp esi,eax
				jae vanSpoljni
				mov ebx,0
				unutrasnji :
				mov eax,[ebp+16]
				mov ecx,[ebp+12]
				dec ecx
				mul cl
				shl eax,1
				cmp ebx,eax
				ja vanUnutrasnji
				
				mov ecx,[ebp+8]
				add ecx,ebx
				add ecx,esi
				mov eax,0
				mov ax,[ecx]
				mov [edi],ax
				add edi,2
				mov eax,[ebp+16]
				shl eax,1
				add ebx,eax
				jmp unutrasnji
				vanUnutrasnji:
				add esi,2
				jmp spoljni
				vanSpoljni:
				mov ecx,3
				petlja:
				mov ebx,0
				mov [edi],bx
				add edi,2
				loop petlja
popfd
pop edi
pop esi
pop edx
pop ecx
pop ebx
pop eax
pop ebp
ret
PROCEDURA endp
end
