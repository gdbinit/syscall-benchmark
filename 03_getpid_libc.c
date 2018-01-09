/*
 * Test code to measure the time of a small system call via libSystem
 */
#include <sys/types.h>
#include <unistd.h>

int main() 
{
	for (ssize_t i = TOTAL_EXECS; i > 0; i--)
	{
		/* this is cached inside /usr/lib/system/libsystem_kernel.dylib implementation! */
		getpid();
	}
	return 0;
}
