#include<stdio.h>
extern void okreni(int niz, int n);
int main(int argc, char* argv[])
{
	int n;
	printf("Unesite dimenzije matrice");
	scanf("%d", &n);
	int** matrica;
	matrica = (int**)malloc(n * sizeof(int*));
	for (int i = 0; i < n; i++) {
		matrica[i] = (int*)malloc(n * sizeof(int));
		for (int j = 0; j < n; j++) {
			{
				printf("\nUnesite a[%d][%d]= ", i, j);
				scanf("%d", & matrica[i][j]);
			}

		}
	}
	for (int i = 0;i < n;i++)
	{
			okreni(matrica[i], n);
	}
	for (int i = 0;i < n;i++)
	{
		printf("[");
		for (int j = 0;j < n;j++)
		{
			printf("a[%d][%d]=%d", i, j, matrica[i][j]);
		}
		printf("]");
		printf("\n");
	}
}