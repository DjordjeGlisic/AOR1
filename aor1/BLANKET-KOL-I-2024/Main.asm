.386
.model flat,c
.data
	a1 dword 050607h
	b1 dword ?
	a2 dw 0b208h
	b2 dword ?
	a3 dw 0a565h
	b3 dword 'AORL'
.stack 4096
.code
main proc
;smestamo a1 u eax i a2 u bx da bi smo preko ta 2 registra izvrsili sabiranje a1+a2
	mov eax,a1
	mov ebx,0
	mov bx,a2
	;sabiramo ax i bx odnosno nizih 16 bitova a1 sa celim brojem-svim bitovima broja a2
	add ax,bx
	jnc preskok
	; u dx smestamo rezultat da bismo mogli da saberemo potencijalni izlazni prenos sa visih 16 bitova sabirka a1
	mov edx,0
	mov dx,ax
	; da bi smo mogli da radimo sa visim 16 bitova a1 treba nam pomeranje celog eax udesno za 16 bita
	shr eax,16
	; dodajemo izlazni prenos cf visim bitovima promenljive a1
	adc ax,0
	;vracamo broj a1 u eax tako sto gornjih 16 bitova vracamo na bitove najvece tezine u registru eax a u ax smestamo nizih 16 bitova
	shl eax,16
	mov ax,dx
	; u bx smestamo a2 da bi smo podelili a1+a2 ciji rezultat u eax imamo sa a2 koga smestamo u bx
	preskok:
	mov ebx,0
	mov bx,a2
	; s obzirom da deljenje eax sa bx nije moguce vec se sa 16bit reg deli samo dx:ax moramo visih 16 bitova postaviti u dx a nizih zadrzati u ax
	; to cinimo tako sto u cx privremeno smestamo nizih 16 pa pomeramo eax udesno za 16 i sadrzaj ax smestamo u dx i ax inicijalizujemo na cx odnosno nizim
	; 16 bitovima broja a1+a2
	mov ecx,0
	mov cx,ax
	shr eax,16
	mov edx,0
	mov dx,ax
	mov ax,cx
	;delimo a1+a2<=>dx:ax sa a2<=>bx
	div bx
	;ceo deo kolicnika, on se nalazi u eax smestamo u b1
	mov b1,eax
	; ostatak kolicnika smestamo u eax s obzirom da zelimo da ga pomnozimo sa a3
	mov eax,edx
	mov ebx,0
	mov bx,a3
	;smestamo u bx a3 i sada mozemo mnozenjem ax i bx pomnziti ostatak((a1+a2)/a2) sa a3
	mul bx
	;rezultat se nalazi u formi dx-visih 16 bitova ax-nizih 16 bitova
	; tako rasporedjen rezultat zelimo da smestimo u eax tako sto ax smestamo u bx privremeno a u ax smestamo dx pa pomeramo eax ulevo za 16
	;i u ax smestamo bx
	mov bx,ax
	mov ax,dx

	shl eax,16
	mov ax,bx
	;uzimamo adresu promenljive b2 da bismo u njoj smestili sadrzaj eax indirektin registarskim adresiranjem
	lea ebx,b2
	mov [ebx],eax
	ret
main endp
end main