#include<stdio.h>
#include<malloc.h>
extern int procedura(int a, int n, int b);
int main(int argc, char* argv[])
{
	int n;
	int m;
	printf("Unesite prvo broj vrsta a nakon toga broj kolona matrice\n");
	scanf("%d", &n);
	scanf("%d", &m);
	short int** matrica = (short int**)malloc(n * sizeof(short int*));
	for (int i = 0;i < n;i++)
	{
		matrica[i] = (short int*)malloc(m * sizeof(short int));
		printf("[");
		for (int j = 0;j < m;j++)
		{
			printf("matrica[%d][%d]=", i, j);
			int pom;
			scanf("%d", &pom);
			matrica[i][j] = (short int)pom;
			printf(",");
		}
		printf("]\n");

	}

	short int niz[100];
	int count = 0;
	for (int i = 0;i < n;i++)
	{
		int N = procedura(matrica[i], m, &niz[count]);
		count += N;
	}
	printf("Rezultujuci niz=[");
	for (int i = 0;i < count;i++)
	{
		short int pom = niz[i];
		printf("%d ", pom);
	}
	printf("]\n");
	return 0;
}
