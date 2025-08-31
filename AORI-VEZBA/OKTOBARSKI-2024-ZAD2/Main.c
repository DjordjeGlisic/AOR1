#include<stdio.h>
#include<malloc.h>
extern void PROCEDURA(int matrica, int n, int m, int niz);
void KreirajNiz(short* matrica, int n, int m, short* niz)
{
	_asm {
				mov edx,0
				mov esi,0
				mov ebx,0
				mov edi,niz
				mov ecx,matrica
				spoljni:
				mov eax,m
				shl eax,1
				cmp esi,eax
				jae vanSpoljni
				mov ebx,0
				unutrasnji :
				mov eax,m
				mov ecx,n
				dec ecx
				mul cl
				shl eax,1
				cmp ebx,eax
				ja vanUnutrasnji
				
				mov ecx,matrica
				add ecx,ebx
				add ecx,esi
				mov eax,0
				mov ax,[ecx]
				mov [edi],ax
				add edi,2
				mov eax,m
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

	}
}
int main(int argc, char* argv[])
{
	int n, m;
	printf("Uneiste najpre broj vrsta zatim broj kolona matrice\n");
	scanf("%d", &n);
	scanf("%d", &m);
	/*short** A = (short**)malloc(n * sizeof(short));
	for (int i = 0;i < n;i++)
	{
		A[i] = (short*)malloc(m * sizeof(short));
		for (int j = 0;j < m;j++)
		{
			printf("A[%d][%d]=", i, j);
			int pom;
			scanf("%d", &pom);
			A[i][j] = (short)pom;
		}
	}
	*/
	short* A = (short*)malloc(n * m * sizeof(int));
	int br = 1;
	for (int i = 0;i < n * m;i++)
		A[i] = br++;
	short niz[100];
	//KreirajNiz(A, n, m, niz);
	PROCEDURA(A, n, m, niz);
	int kraj = 0;
	int i = 0;
	printf("Niz koji prikazuje obilazak matrice po kolonama [");
	while (!kraj)
	{
		if (niz[i] == 0)
		{
			int izraz1 = i - 1 >= 0 && niz[i - 1] == 0 && niz[i + 1] == 0?1:0;
			int izraz2=niz[i+1]==0&&niz[i+2]==0?1:0;
			//int izraz2 = (p  <= n && niz[i + 1] == 0 && niz[i + 2] = 0)? 1:0;
			if (izraz1==1||izraz2==1)
				kraj = 1;
		
		}
		if (!kraj)
			printf(" %d ", niz[i]);
		i++;
	}
	printf("]\n");
	return 0;
}