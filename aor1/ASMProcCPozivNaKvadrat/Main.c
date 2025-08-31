#include<stdio.h>
extern int power2(short broj, char stepen);
int main(int* argc, char* argv[])
{
	int broj = 3;
	int stepen = 4;
	power2(broj, stepen);
	_asm {
		mov broj,eax
	}
	printf("Rezultat je \n %d", broj);
	return 0;
}