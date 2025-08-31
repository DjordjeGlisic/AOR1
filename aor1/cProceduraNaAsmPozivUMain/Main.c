#include<stdio.h>
extern void obidjiMatricu(int* n, int* m, int* matrica);
int main()
{
	int vrste;
	int kolone;
	printf("Unesite broj vrsta pa broj kolona matrice");
	scanf("%d", &vrste);
	scanf("%d", &kolone);
	int** mat = malloc(vrste * sizeof(int*));
	for (int i = 0;i < vrste;i++)
	{
		mat[i] = malloc(kolone * sizeof(int));
		for (int j = 0;j < kolone;j++)
		{
			mat[i][j] = i+j;
		}

	}
	obidjiMatricu(&mat, &vrste, &kolone);
	return 0;
}