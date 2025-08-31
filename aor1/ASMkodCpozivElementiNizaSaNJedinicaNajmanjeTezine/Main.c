#include<stdio.h>
extern int brojiElemente(int k, int n, int niz);
int main(int* argc, char* argv[])
{
	int niz[] = { 5,2,23,3,55,9,10,12 };
	int brojElemenata = brojiElemente(3, 8, niz);
	printf("Broj elemenata sa 3 jedinice najmanje tezine: %d\n", brojElemenata);
	return 0;
}