#include<stdio.h>
extern int sumaVrste(int n,int m,int vrsta, int matrica);
int main(int* argc, char* argv[])
{
	int matrica[][4] = { {1,7,8,2},{0,3,9,4},{5,11,12,15} };
	printf("Unesite sumu koje vrste da se izracuna\n");
	int n;
	scanf("%d", &n);
	sumaVrste(3,4,n - 1, matrica);
	_asm {
		mov n,eax
	}
	printf("Suma unete vrste je %d\n", n);

	return 0;
}