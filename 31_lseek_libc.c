/*
 * Test code to measure the time of the lseek() system call via libSystem
 */
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>

int main() 
{
	int fd = open("/tmp/lseek_test_file", O_WRONLY);
	for (ssize_t i = TOTAL_EXECS; i > 0; i--) 
	{
		if (lseek(fd, 4, SEEK_SET) < 0)
		{
			return 1;
		}
		if (lseek(fd, 0, SEEK_SET) < 0)
		{
			return 1;
		}
	}
	close(fd);
	return 0;
}
