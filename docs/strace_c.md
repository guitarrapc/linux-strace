## syscalls

```shell
$ strace -c ./bin/hello_c
Hello World
% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
 24.08    0.000046          46         1           munmap
 22.51    0.000043          14         3           brk
 19.90    0.000038          38         1           prlimit64
 16.75    0.000032          32         1           write
 10.99    0.000021          21         1           getrandom
  5.76    0.000011           3         3           fstat
  0.00    0.000000           0         1           read
  0.00    0.000000           0         2           close
  0.00    0.000000           0         8           mmap
  0.00    0.000000           0         3           mprotect
  0.00    0.000000           0         2           pread64
  0.00    0.000000           0         1         1 access
  0.00    0.000000           0         1           execve
  0.00    0.000000           0         1           arch_prctl
  0.00    0.000000           0         1           set_tid_address
  0.00    0.000000           0         2           openat
  0.00    0.000000           0         1           set_robust_list
  0.00    0.000000           0         1           rseq
------ ----------- ----------- --------- --------- ----------------
100.00    0.000191           5        34         1 total
```


## openat by loader

```shell
$ strace -f -e trace=openat,newfstatat,access -s 200 ./bin/hello_c 2>&1
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
Hello World
+++ exited with 0 +++
```

## write by runtime

```shell
$ strace -e write ./bin/hello_c > /dev/null
write(1, "Hello World\n", 12)           = 12
+++ exited with 0 +++
```

## ldd

How many dependencies?

```shell
$ ldd ./bin/hello_c
        linux-vdso.so.1 (0x00007ffe18fbc000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x0000742e398a5000)
        /lib64/ld-linux-x86-64.so.2 (0x0000742e39ac2000)
```
