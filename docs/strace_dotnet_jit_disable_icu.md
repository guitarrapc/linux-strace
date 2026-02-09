## syscalls

Without ICU significantly reduce openat.

```shell
$ DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1 strace -c ./bin/hello_csharp
Hello, World
% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ------------------
 22.62    0.002220           7       314           mprotect
 14.36    0.001410          11       128           mmap
 12.74    0.001251          16        77        28 openat
  7.71    0.000757          14        52           read
  4.49    0.000441           9        45           fstat
  3.95    0.000388          55         7           clone
  3.80    0.000373           9        38        34 readlink
  3.50    0.000344          18        19           munmap
  3.48    0.000342           8        39           close
  3.28    0.000322          21        15           rt_sigprocmask
  2.56    0.000251          11        21           pread64
  2.07    0.000203           8        23           madvise
  1.79    0.000176          11        16        12 newfstatat
  1.78    0.000175           7        24           rt_sigaction
  1.34    0.000132           6        22           fcntl
  1.07    0.000105          11         9           stat
  1.03    0.000101          10        10           prlimit64
  0.99    0.000097          97         1           bind
  0.69    0.000068           6        10           brk
  0.68    0.000067          11         6         6 access
  0.57    0.000056          28         2           mknodat
  0.52    0.000051           6         8           write
  0.37    0.000036           7         5         2 unlink
  0.35    0.000034           4         8           futex
  0.34    0.000033          16         2           pipe2
  0.34    0.000033           8         4           membarrier
  0.33    0.000032          32         1           socket
  0.32    0.000031           7         4           sched_getaffinity
  0.31    0.000030           6         5           getpid
  0.31    0.000030          15         2           sysinfo
  0.31    0.000030          15         2           statfs
  0.22    0.000022          22         1           gettid
  0.21    0.000021           5         4           ioctl
  0.20    0.000020          10         2           sigaltstack
  0.18    0.000018          18         1           memfd_create
  0.12    0.000012          12         1           ftruncate
  0.12    0.000012          12         1           fchmod
  0.12    0.000012          12         1         1 clone3
  0.11    0.000011          11         1           listen
  0.10    0.000010          10         1           set_tid_address
  0.09    0.000009           9         1           getsid
  0.09    0.000009           9         1         1 get_mempolicy
  0.09    0.000009           9         1           set_robust_list
  0.09    0.000009           9         1           getrandom
  0.08    0.000008           8         1           arch_prctl
  0.08    0.000008           8         1           rseq
  0.07    0.000007           7         1           lseek
  0.00    0.000000           0         1           execve
------ ----------- ----------- --------- --------- ------------------
100.00    0.009816          10       940        84 total
```


## Why so many openat (loader)?

```shell
$ DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1 strace -f -e trace=openat,newfstatat,access -s 200 ./bin/hello_csharp 2>&1
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libdl.so.2", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/librt.so.1", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libgcc_s.so.1", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libpthread.so.0", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libm.so.6", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libstdc++.so.6", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/glibc-hwcaps/x86-64-v4/liblttng-ust-tracepoint.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "/lib/x86_64-linux-gnu/glibc-hwcaps/x86-64-v4/", 0x7fff38292300, 0) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/glibc-hwcaps/x86-64-v3/liblttng-ust-tracepoint.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "/lib/x86_64-linux-gnu/glibc-hwcaps/x86-64-v3/", 0x7fff38292300, 0) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/glibc-hwcaps/x86-64-v2/liblttng-ust-tracepoint.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "/lib/x86_64-linux-gnu/glibc-hwcaps/x86-64-v2/", 0x7fff38292300, 0) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/liblttng-ust-tracepoint.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "/lib/x86_64-linux-gnu/", {st_mode=S_IFDIR|0755, st_size=16384, ...}, 0) = 0
openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/glibc-hwcaps/x86-64-v4/liblttng-ust-tracepoint.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/glibc-hwcaps/x86-64-v4/", 0x7fff38292300, 0) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/glibc-hwcaps/x86-64-v3/liblttng-ust-tracepoint.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/glibc-hwcaps/x86-64-v3/", 0x7fff38292300, 0) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/glibc-hwcaps/x86-64-v2/liblttng-ust-tracepoint.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/glibc-hwcaps/x86-64-v2/", 0x7fff38292300, 0) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/liblttng-ust-tracepoint.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/", {st_mode=S_IFDIR|0755, st_size=16384, ...}, 0) = 0
openat(AT_FDCWD, "/lib/glibc-hwcaps/x86-64-v4/liblttng-ust-tracepoint.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "/lib/glibc-hwcaps/x86-64-v4/", 0x7fff38292300, 0) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/lib/glibc-hwcaps/x86-64-v3/liblttng-ust-tracepoint.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "/lib/glibc-hwcaps/x86-64-v3/", 0x7fff38292300, 0) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/lib/glibc-hwcaps/x86-64-v2/liblttng-ust-tracepoint.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "/lib/glibc-hwcaps/x86-64-v2/", 0x7fff38292300, 0) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/lib/liblttng-ust-tracepoint.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "/lib/", {st_mode=S_IFDIR|0755, st_size=4096, ...}, 0) = 0
openat(AT_FDCWD, "/usr/lib/glibc-hwcaps/x86-64-v4/liblttng-ust-tracepoint.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "/usr/lib/glibc-hwcaps/x86-64-v4/", 0x7fff38292300, 0) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/lib/glibc-hwcaps/x86-64-v3/liblttng-ust-tracepoint.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "/usr/lib/glibc-hwcaps/x86-64-v3/", 0x7fff38292300, 0) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/lib/glibc-hwcaps/x86-64-v2/liblttng-ust-tracepoint.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "/usr/lib/glibc-hwcaps/x86-64-v2/", 0x7fff38292300, 0) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/lib/liblttng-ust-tracepoint.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "/usr/lib/", {st_mode=S_IFDIR|0755, st_size=4096, ...}, 0) = 0
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/liblttng-ust-tracepoint.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/liblttng-ust-tracepoint.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/lib/liblttng-ust-tracepoint.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/lib/liblttng-ust-tracepoint.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/workspace/bin/hello_csharp", O_RDONLY) = 3
openat(AT_FDCWD, "/workspace/bin/hello_csharp", O_RDONLY) = 3
openat(AT_FDCWD, "/workspace/bin/hello_csharp", O_RDONLY) = 3
access("", F_OK)                        = -1 ENOENT (No such file or directory)
access("opt/coreservicing", F_OK)       = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/workspace/bin/hello_csharp", O_RDONLY) = 3
access("", F_OK)                        = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/proc/self/mountinfo", O_RDONLY) = 3
openat(AT_FDCWD, "/proc/self/cgroup", O_RDONLY) = 3
strace: Process 128 attached
[pid   127] openat(AT_FDCWD, "/sys/fs/cgroup//cpu.max", O_RDONLY) = 8
[pid   127] openat(AT_FDCWD, "/dev/urandom", O_RDONLY|O_CLOEXEC) = 9
[pid   127] openat(AT_FDCWD, "/proc/127/stat", O_RDONLY) = 10
strace: Process 129 attached
[pid   127] openat(AT_FDCWD, "/sys/devices/system/cpu/online", O_RDONLY|O_CLOEXEC) = 11
[pid   127] openat(AT_FDCWD, "/proc/self/mountinfo", O_RDONLY) = 11
[pid   127] openat(AT_FDCWD, "/proc/self/cgroup", O_RDONLY) = 11
[pid   127] openat(AT_FDCWD, "/proc/127/stat", O_RDONLY) = 11
[pid   127] openat(AT_FDCWD, "/proc/127/stat", O_RDONLY) = 11
strace: Process 130 attached
[pid   130] openat(AT_FDCWD, "/tmp/clr-debug-pipe-127-2260796-in", O_RDONLYstrace: Process 131 attached
 <unfinished ...>
[pid   127] openat(AT_FDCWD, "/proc/127/stat", O_RDONLY) = 14
[pid   127] openat(AT_FDCWD, "/dev/shm/sem.clrst0000007f0000000000227f3c", O_RDWR|O_NOFOLLOW|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   127] openat(AT_FDCWD, "/sys/fs/cgroup//memory.max", O_RDONLY) = 12
[pid   127] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index0/size", O_RDONLY) = 12
[pid   127] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index0/level", O_RDONLY) = 12
[pid   127] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index1/size", O_RDONLY) = 12
[pid   127] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index1/level", O_RDONLY) = 12
[pid   127] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index2/size", O_RDONLY) = 12
[pid   127] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index2/level", O_RDONLY) = 12
[pid   127] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index3/size", O_RDONLY) = 12
[pid   127] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index3/level", O_RDONLY) = 12
[pid   127] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index4/size", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid   127] openat(AT_FDCWD, "/proc/meminfo", O_RDONLY) = 12
[pid   127] openat(AT_FDCWD, "/proc/self/maps", O_RDONLY|O_CLOEXEC) = 12
[pid   127] openat(AT_FDCWD, "/proc/self/maps", O_RDONLY|O_CLOEXEC) = 12
strace: Process 132 attached
[pid   127] openat(AT_FDCWD, "/proc/self/task/132/comm", O_RDWR) = 14
[pid   127] openat(AT_FDCWD, "/workspace/bin/hello_csharp", O_RDONLY) = 12
strace: Process 133 attached
[pid   127] openat(AT_FDCWD, "/proc/self/task/133/comm", O_RDWR) = 16
[pid   127] access("", F_OK)            = -1 ENOENT (No such file or directory)
[pid   127] access("opt/corebreadcrumbs", F_OK) = -1 ENOENT (No such file or directory)
[pid   127] openat(AT_FDCWD, "/workspace/bin/hello_csharp", O_RDONLY) = 14
[pid   127] openat(AT_FDCWD, "/workspace/bin/hello_csharp", O_RDONLY) = 16
[pid   127] openat(AT_FDCWD, "/workspace/bin/hello_csharp", O_RDONLY) = 18
[pid   127] openat(AT_FDCWD, "/workspace/bin/hello_csharp", O_RDONLY) = 20
[pid   127] openat(AT_FDCWD, "/workspace/bin/hello_csharp", O_RDONLY) = 22
[pid   127] openat(AT_FDCWD, "/workspace/bin/hello_csharp", O_RDONLY) = 25
strace: Process 134 attached
[pid   127] openat(AT_FDCWD, "/root/.terminfo/x/xterm", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   127] openat(AT_FDCWD, "/root/.terminfo/78/xterm", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   127] openat(AT_FDCWD, "/etc/terminfo/x/xterm", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   127] openat(AT_FDCWD, "/etc/terminfo/78/xterm", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   127] openat(AT_FDCWD, "/lib/terminfo/x/xterm", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   127] openat(AT_FDCWD, "/lib/terminfo/78/xterm", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   127] openat(AT_FDCWD, "/usr/share/terminfo/x/xterm", O_RDONLY|O_CLOEXEC) = 29
[pid   127] openat(AT_FDCWD, "/workspace/bin/hello_csharp", O_RDONLY) = 30
[pid   127] openat(AT_FDCWD, "/workspace/bin/hello_csharp", O_RDONLY) = 32
Hello, World
[pid   130] <... openat resumed>)       = ?
[pid   133] +++ exited with 0 +++
[pid   132] +++ exited with 0 +++
[pid   131] +++ exited with 0 +++
[pid   130] +++ exited with 0 +++
[pid   129] +++ exited with 0 +++
[pid   128] +++ exited with 0 +++
[pid   134] +++ exited with 0 +++
+++ exited with 0 +++
```

## ldd

How many dependencies?

```shell
$ DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1 ldd ./bin/hello_csharp
        linux-vdso.so.1 (0x00007fff2b8d7000)
        libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x0000720e5c072000)
        librt.so.1 => /lib/x86_64-linux-gnu/librt.so.1 (0x0000720e5c06d000)
        libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x0000720e5c03f000)
        libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x0000720e5c03a000)
        libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x0000720e5bf51000)
        libstdc++.so.6 => /lib/x86_64-linux-gnu/libstdc++.so.6 (0x0000720e5bcd1000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x0000720e5babf000)
        /lib64/ld-linux-x86-64.so.2 (0x0000720e5cc3c000)
```
