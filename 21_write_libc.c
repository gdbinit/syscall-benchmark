/*
 * Test code to measure the time of the write() system call via libSystem
 */
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

int main() 
{
	int fd = open("/dev/null", O_WRONLY);
	int data = 0;
	for (ssize_t i = TOTAL_EXECS; i > 0; i--) 
	{
		write(fd, &data, sizeof(data));
	}
	close(fd);
	return 0;
}
