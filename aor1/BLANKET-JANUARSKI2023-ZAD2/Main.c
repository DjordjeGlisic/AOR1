#include<stdio.h>
extern void modifikujNiz(int x, int y, int z, int n, int niz);
int main(int argc, char* argv[])
{
	int* niz;
	char n;
	printf("Unesite  slovo koje ce odgovarati broju elemenata niza\n");
	scanf("%c", &n);
	niz = malloc(n * sizeof(int));
	int brojac = 1;
	for (int i = 0;i < n;i++)
	{
		niz[i] = brojac++;
		printf("niz[%d]=%d", i,niz[i]);
		
		printf("\n");
	}
	printf("Unesite skalar kojim ce biti zamenjeni oni elementi koji su izmedju prvog i poslednjeg po vrednosti\n");
	int* a=malloc(sizeof(int));
	scanf("%d", a);
	int* x = &niz[0];
	int* y = &niz[n - 1];
	int m = (int)n;
	modifikujNiz(x, y, a, m, niz);
	printf("NIZ=[");
	for (int i = 0;i < n;i++)
	{
		printf("%d ", niz[i]);
	
	}
	printf("]\n");
	return 0;
}