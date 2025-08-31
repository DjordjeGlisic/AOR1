#include<stdio.h>
int main()
{
	int a;
	int b = 8;
	scanf("%d", &a);
	
	_asm {
		mov eax, a
		;mnozimo a sa 2
		mov ebx,2
		mul bl
		mov ebx,b
		add eax,ebx
		mov b,eax

	}
	printf("%d", b);
	return 0;
}