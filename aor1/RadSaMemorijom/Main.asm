.386
.model flat,c
.data
	n db 5
	m db 6
	x dword 12345678h, 3h
	a db 2h
	b dw 03a4bh
	;izlgled memorije na adresi je 05 06 78 56 34 12 03 00 00 00 02 4b 3a 

.code
	main proc
		;int main(){int n=5;int m=6; n+=6;}
		;mov eax,0
		;mov al,5
		;add al,m
		; promenljiva sa vrednoscu 12345678h upisana u memoriju i adresa memorije u eax registar, vise promenljivih u memoriju i dohvatanje 8,16,32 bita u acc
		lea edx,x
		; eksplicitno navodjenje sirine
		mov al,byte ptr x; u al se nalazi 78
		mov ah,byte ptr x+1; u ah se nalazi 56
		mov ax,word ptr x+2; u ax se nalazi 1234 
		mov eax,dword ptr x+4; u eax se nalazi 00 00 00 03
		; implicitno navodjenje sirine
		lea edx,n
		mov eax,0
		mov ax,[edx];u ax je 06 05
		mov ax,[edx+2]; u ax je 56 78
		mov ax,[edx+7]; u ax je 00 00
		mov eax,[edx+7]; u eax je 00 00 00 00 02
		mov ebx,0abcdefabh
		mov [edx+7],ebx
		mov [edx+7], byte ptr 0fch
		ret
	main endp
	end main