#include<stdio.h>
extern  void strKonverz(char ulaz, char izlaz);
int main(int* argc, char* argv[])
{
	printf("Unesite recenicu sa velikim i malim slovima");
	char recenica[] = "Ovo Je Neki String\0";
	char prevedena[100];

	strKonverz(recenica, prevedena);
	int i = 0;
	printf("Recenica prevedena sve u mala slova\n");
	while (prevedena[i] != -52)
	{

		printf("%c ", prevedena[i]);
		i++;
	}

	return 0;
}