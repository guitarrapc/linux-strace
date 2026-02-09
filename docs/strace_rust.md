# syscalls

```shell
$ strace -c ./bin/hello_rust
Hello World
% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ------------------
 15.37    0.000083          16         5           mprotect
  9.26    0.000050          10         5           rt_sigaction
  9.07    0.000049           9         5           read
  8.89    0.000048          12         4           close
  7.22    0.000039          19         2           munmap
  6.30    0.000034           8         4           openat
  6.30    0.000034          17         2           prlimit64
  5.93    0.000032          10         3           sigaltstack
  5.37    0.000029           2        13           mmap
  4.44    0.000024          24         1           write
  3.70    0.000020           6         3           brk
  3.15    0.000017          17         1           arch_prctl
  2.59    0.000014          14         1           poll
  2.04    0.000011          11         1           sched_getaffinity
  1.85    0.000010           2         4           fstat
  1.85    0.000010          10         1           rseq
  1.67    0.000009           9         1           gettid
  1.67    0.000009           9         1           set_tid_address
  1.67    0.000009           9         1           set_robust_list
  1.67    0.000009           9         1           getrandom
  0.00    0.000000           0         2           pread64
  0.00    0.000000           0         1         1 access
  0.00    0.000000           0         1           execve
------ ----------- ----------- --------- --------- ------------------
100.00    0.000540           8        63         1 tota
```


## openat by loader

```shell
$ strace -f -e trace=openat,newfstatat,access -s 200 ./bin/hello_rust 2>&1
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libgcc_s.so.1", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/proc/self/maps", O_RDONLY|O_CLOEXEC) = 3
Hello World
+++ exited with 0 +++
```

## write by runtime

```shell
$ strace -e write ./bin/hello_rust > /dev/null
write(1, "Hello World\n", 12)           = 12
+++ exited with 0 +++
```

# ldd

How many dependencies?

```shell
$ ldd ./bin/hello_rust
        linux-vdso.so.1 (0x00007ffffd13b000)
        libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x0000745c096da000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x0000745c094c8000)
        /lib64/ld-linux-x86-64.so.2 (0x0000745c09766000)
```
