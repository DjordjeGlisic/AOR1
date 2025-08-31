#include<stdio.h>
void pretvoriUNiz(int matrica, int n, int m,int niz)
{
	_asm {
		mov eax, m
		mov ebx, 100
		mul ebx
		;u eax se nalazi 100*m
		mov ebx,2
		mul ebx
		mov edi, niz; u edi se nalazi niz
		mov edx,edi
		mov n, eax; u n se nalazi 3*100*2
		mov ecx,m
		mov esi,0
		petlja:
			mov ebx,0
			wile:
				cmp ebx,n
				ja van
				mov eax,matrica
				add eax,ebx
				add eax,esi
				mov ax,[eax]
				mov [edi],ax
				add edi,2
				add ebx,100
				add ebx,100
			jmp wile
			van :
			add esi,2
		loop petlja
		mov ax,0
		mov word ptr [edi],ax
		add edi,2
		mov word ptr [edi], ax
		add edi, 2
		mov word ptr [edi], ax
		mov niz,edx


	
	}
}
int main(int* argc, char* argv[])
{
	int n;
	int m;
	printf("Unesite najpre broj vrsta,zatim broj kolona matrice");
	scanf("%d", &n);
	scanf("%d", &m);
	short matrica[100][100];
for(int i=0;i<n;i++)
		for (int j = 0;j < m;j++)
		{
			printf("a[%d][%d]? ", i, j);
			int podatak;
			scanf("%d", &podatak);
			matrica[i][j] = (short)podatak;
		}
	short  niz[100];
	pretvoriUNiz(matrica, n, m, niz);
	int br = 0;
	int i = 0;
	while (br < 3)
	{
		if (niz[i] != 0)
			printf("niz[%d]\n", niz[i]);
		else
			br++;
		i++;
	}

	return 0;
}