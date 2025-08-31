.386
.model flat,c
.data
a db 35h
b db 78h
s dword ?
.stack 4096
.code
main proc
mov ecx,0
mov edi,0
wile:
	mov esi,ecx
	sub esi,100
	js telo
	jnz van
	telo:
	;u ovom delu koda imamo mapiranja instrukcija za racunanje  (a*b)^2
	; cistimo registar eax da bi smo u al stavili a a u ah stavili b, s obzirom da su oba 8 bitni podaci
	mov eax,0
	mov al,a
	mov ah,b
	mul ah
	;nakon ove naredbe u ax imamo a*b ciju vrednost kopiramo i u bx da bismo imali 2 registra sa a*b vrednosti
	mov bx,ax
	mov edx,0
	mul bx
	; ovom naredbom smo pomnozili a*b sa a*b cime dobijamo 16bitno (a*b)^2 u registru dx:ax
	;nama je potrebno radi poredjenja sa 32bit s da rezultat u dx:ax smestimo ceo u eax zbog cega 
	;privremeno smestamo nizih 16 bit u bx a u ax visih 16bit rotiramo eax udesno za 16 bit i u ax smestamo nizih 16bit koji su privremeno bili u bx
	mov bx,ax
	mov ax,dx
	shl eax,16
	mov ax,bx
	mov esi,edi
	sub esi,eax
	js dalje
	jnz van
	dalje:
	inc ecx
	;ovde racunamo drugi izraz: [(a-1)*b]/2
	;najpe cistimo eax da bi smo zatim u njega ubacili a pa cemo eax da dekrementiramo da bismo dobili a-1 u nejemi
	mov eax,0
	mov al,a
	mov esi,ecx
	sub esi,eax
	js drugiIzraz
	add edi,eax
	drugiIzraz:
	dec eax
	; u ebx stavljamo b da bi smo mogli da pomnozimo a-1 sto je u al sa b sto je u bl i rezultat smestili u ax
	mov ebx,0
	mov bl,b
	mul bl
	;nakon rezultata (a-1)*b u ax delimo taj 16bit izraz 8bitnom brojem 2 koji se nalazi u bl 
	mov bl,2
	mov edx,0
	xor edx,edx
	div bx
	;cistimo ostatak da bi smo u eax dobili samo ceo deo kolicnika koga sabiramo sa s koje se nalazi u edi a na kraju ce se upisati u memoriju
	mov dx,0
	add edi,eax


jmp wile
van:
mov s,edi
ret
main endp
end main