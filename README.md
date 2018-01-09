# syscall-benchmark for macOS Meltdown patches benchmarking

C and assembler test cases to measure macOS system call performance.

Use compile.sh script to compile. Pass an argument to the script with the number of loop iterations in each test (default is 100 million).

Then use bench.sh script to execute all the tests. Pass an argument with the number of test cycles to run per test (default is 10).

Results can be found in results.log file.

Original code from https://github.com/arkanis/syscall-benchmark
