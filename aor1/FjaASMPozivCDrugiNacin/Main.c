#include<stdio.h>
void obidjiMatricuPoKolonama(int vr, int kol, int adresaMatrice)
{
	_asm {
		mov eax, 0
		mov ebx, 0
		mov al, byte ptr kol
		mov bl, byte ptr vr
		dec bl
		mul bl
		;mov bl, 4
		mul bl
		mov edx,eax
		mov eax,0
		mov ebx,0
		mov ecx,kol
		mov esi,0
		petlja:
		mov ebx, 0
			wile :
			cmp ebx, edx
			ja van
			mov edi, adresaMatrice
			add edi, ebx
			add edi, esi
			mov al, [edi]

			add ebx, kol
			;add ebx, kol
			;	add ebx, kol
			;	add ebx, kol
			jmp wile
			;add esi, 4
			van:
			inc esi
		loop petlja

	}
}
int main(int* argc, char* argv[])
{
	int n;
	int m;
	char* matrica;
	scanf("%d", &n);
	scanf("%d", &m);
	matrica = (char*)malloc(n *m* sizeof(char));
	for (int i = 0;i < n;i++)
	{
		
		for (int j = 0;j < m;j++)
			matrica[i*m+j] = i + j;
	}
	int adresaMatrice;
	_asm{
			lea eax,matrica
			mov adresaMatrice,eax
	}
	obidjiMatricuPoKolonama(n, m, adresaMatrice);

	return 0;
}