#include<stdio.h>
int racunajSumuNiza( int* n,int niz[])
{
	int sum = 0;
	for (int i = 0;i < *n;i++)
		sum += niz[i];
	return sum;
}
int main()
{
	int n = 10;
	int niz[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
	_asm {
		lea eax,niz
		push eax
		lea eax,n
		push eax
		call dword ptr racunajSumuNiza
		mov n,eax
		add esp,8


	}
	printf("Suma je %d", n);
	return 0;
}
