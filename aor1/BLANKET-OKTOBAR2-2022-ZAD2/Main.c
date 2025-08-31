#include<stdio.h>

extern int procedura(int niz);
int main(int agc, char* argv[])
{
	int count = 0;
	//char s[100];
	/*while(1)
	{
		printf("Unesite %d element stringa\n", count);
		cin("%c", &s[count++]);
		if (s[count-1] == '0')
			break;

	}*/
	char s[] = { 'a','a','a','a','b','c','c','b','b','b','e','f','f','f','f','f','d','0'};
	count = 0;
	int index = 0;
	char nov[100];
	while (s[count] != '0')
	{
		int adresa = s;
		adresa += count;
		int br = procedura(adresa);
		if (br > 1)
		{
			nov[index++] = br+1;
			nov[index++] = s[count];
			count += br + 1;
		}
		else
		{

			nov[index++] = s[count];
			count++;
		}
		
	}
	printf("Transformisan string:[ ");
	for (int i = 0;i < index;i++)
		printf("%c ", nov[i]);
	printf("]\n");
	return 0;
}