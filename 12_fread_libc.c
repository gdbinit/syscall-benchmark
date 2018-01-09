/*
 * Test code to measure the time of fread() via libSystem
 */
#include <stdio.h>
#include <unistd.h>

int main() 
{
	FILE* file = fopen("/dev/zero", "r");
	int data = 0;
	for (ssize_t i = TOTAL_EXECS; i > 0; i--) 
	{
		fread(&data, sizeof(data), 1, file);
	}
	fclose(file);
	return 0;
}
