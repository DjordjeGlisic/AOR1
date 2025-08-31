#include<stdio.h>
#include<malloc.h>
extern void PROCEDURA(int niz, int n);
int main(int argc, char* argv[])
{
	int n=4;
	printf("Unesite dimenziju kvadratne marice\n");
	//scanf("%d", &n);
	int** A = (int**)malloc(n* sizeof(int*));
	for (int i = 0;i < n;i++)
		A[i] = (int*)malloc(n * sizeof(int));
	int br = 1;
	for (int i = 0;i < n;i++)
	{
		for (int j = 0;j < n;j++)
		{
			//scanf("%d", &A[i * n + j]);
			A[i][j] = br++;
		}
	}
	int pol = n / 2;
	int ost = n - pol-1;
	for (int i = 0;i < n;i++)
	{
		PROCEDURA(&A[i][pol], ost);

	}
	printf("Matrica nakon poziva procedure\n");
	for (int i = 0;i < n;i++)
	{
		printf("[");
		for (int j = 0;j < n;j++)
			printf(" %d ", A[i ][ j]);
		printf("]\n");
	}
	for(int  i=0;i<n;i++)
		free(A[i]);
	free(A);
	return 0;
}