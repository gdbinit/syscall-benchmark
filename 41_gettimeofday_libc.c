/*
 * Test code to measure the time of the gettimeofday() system call via libSystem
 */

#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <unistd.h>

int
main(int argc, char *argv[])
{
	struct timeval tv;
	for (ssize_t i = TOTAL_EXECS; i > 0; i--)
 	{
 		/* optimized by system library using commpage_gettimeofday */
  		gettimeofday(&tv, NULL);
 	}
 	return 0;
}
