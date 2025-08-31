#include<stdio.h>
//extern char* izmeniText(char text, int n);
int main(int argc, char* argv[])
{
	char text[100];
	int n=0;
	printf("Unesite tekst u jednoj liniji\n");
	fgets(text, 100 * sizeof(char), stdin);
	while (text[n] != '\n')
		n++;
	char* newText = izmeniText(text, n);
	int i = 0;
	printf("Izmenjen tekst glasi: ");
	while (newText[i] != '0')
	{
		printf("%c", newText[i]);
		i++;
	}

	

	return 0;
}