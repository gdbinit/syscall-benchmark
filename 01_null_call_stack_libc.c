/*
 * Test code to measure the time of a small function call.
 */
#include <unistd.h>

__attribute__ ((optnone)) 
int foo(void) 
{
	return 0;
}

__attribute__ ((optnone))
int main(void) 
{
	for (ssize_t i = TOTAL_EXECS; i > 0; i--)
	{
		foo();
	}
	return 0;
}
