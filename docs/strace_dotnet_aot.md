## syscalls

```shell
$ strace -c ./bin/hello_csharp_aot
Hello, World
% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ------------------
 28.49    0.001753          13       127        83 openat
 13.99    0.000861          14        61           mmap
  9.51    0.000585          16        35           read
  7.78    0.000479          10        44           close
  7.36    0.000453          10        43           fstat
  6.19    0.000381          14        27           mprotect
  5.31    0.000327          15        21           munmap
  3.17    0.000195          12        16        12 newfstatat
  3.10    0.000191          11        17           madvise
  2.60    0.000160           8        18           rt_sigaction
  2.39    0.000147          73         2           clone
  2.00    0.000123          20         6           rt_sigprocmask
  0.91    0.000056          14         4           ioctl
  0.86    0.000053          26         2           write
  0.65    0.000040          10         4           prlimit64
  0.57    0.000035           8         4           brk
  0.50    0.000031          10         3           pread64
  0.50    0.000031          10         3           sched_getaffinity
  0.49    0.000030          10         3           getpid
  0.49    0.000030          15         2           statfs
  0.44    0.000027           9         3           futex
  0.31    0.000019          19         1         1 get_mempolicy
  0.29    0.000018          18         1           pipe2
  0.29    0.000018           9         2           membarrier
  0.24    0.000015          15         1           fcntl
  0.24    0.000015          15         1           set_robust_list
  0.23    0.000014          14         1           sysinfo
  0.18    0.000011          11         1           rseq
  0.16    0.000010          10         1           arch_prctl
  0.16    0.000010          10         1           getrandom
  0.15    0.000009           9         1           lseek
  0.15    0.000009           9         1           gettid
  0.15    0.000009           9         1           set_tid_address
  0.15    0.000009           9         1         1 clone3
  0.00    0.000000           0         1         1 access
  0.00    0.000000           0         1           execve
------ ----------- ----------- --------- --------- ------------------
100.00    0.006154          13       461        98 total
```


## Why so many openat (loader)?

It searches ICU for every version 90 > 89 > 88 ... 75 > 74 (found!), then loader started. Most openat are caused by searching ICU.

```shell
$ strace -f -e trace=openat,newfstatat,access -s 200 ./bin/hello_csharp_aot 2>&1
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libm.so.6", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/sys/devices/system/cpu/online", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/proc/self/mountinfo", O_RDONLY) = 3
openat(AT_FDCWD, "/proc/self/cgroup", O_RDONLY) = 3
openat(AT_FDCWD, "/proc/self/mountinfo", O_RDONLY) = 3
openat(AT_FDCWD, "/proc/self/cgroup", O_RDONLY) = 3
openat(AT_FDCWD, "/sys/fs/cgroup//cpu.max", O_RDONLY) = 3
strace: Process 160 attached
[pid   159] openat(AT_FDCWD, "/sys/fs/cgroup//memory.max", O_RDONLY) = 3
[pid   159] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index0/size", O_RDONLY) = 3
[pid   159] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index0/level", O_RDONLY) = 3
[pid   159] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index1/size", O_RDONLY) = 3
[pid   159] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index1/level", O_RDONLY) = 3
[pid   159] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index2/size", O_RDONLY) = 3
[pid   159] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index2/level", O_RDONLY) = 3
[pid   159] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index3/size", O_RDONLY) = 3
[pid   159] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index3/level", O_RDONLY) = 3
[pid   159] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index4/size", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/proc/meminfo", O_RDONLY) = 3
[pid   159] openat(AT_FDCWD, "/proc/self/maps", O_RDONLY|O_CLOEXEC) = 3
strace: Process 161 attached
[pid   159] openat(AT_FDCWD, "/root/.terminfo/x/xterm", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/root/.terminfo/78/xterm", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/etc/terminfo/x/xterm", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/etc/terminfo/78/xterm", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/lib/terminfo/x/xterm", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/lib/terminfo/78/xterm", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/usr/share/terminfo/x/xterm", O_RDONLY|O_CLOEXEC) = 6
[pid   159] openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 6
[pid   159] openat(AT_FDCWD, "/lib/x86_64-linux-gnu/glibc-hwcaps/x86-64-v4/libicuuc.so.90", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] newfstatat(AT_FDCWD, "/lib/x86_64-linux-gnu/glibc-hwcaps/x86-64-v4/", 0x7ffc1064fc30, 0) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/lib/x86_64-linux-gnu/glibc-hwcaps/x86-64-v3/libicuuc.so.90", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] newfstatat(AT_FDCWD, "/lib/x86_64-linux-gnu/glibc-hwcaps/x86-64-v3/", 0x7ffc1064fc30, 0) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/lib/x86_64-linux-gnu/glibc-hwcaps/x86-64-v2/libicuuc.so.90", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] newfstatat(AT_FDCWD, "/lib/x86_64-linux-gnu/glibc-hwcaps/x86-64-v2/", 0x7ffc1064fc30, 0) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libicuuc.so.90", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] newfstatat(AT_FDCWD, "/lib/x86_64-linux-gnu/", {st_mode=S_IFDIR|0755, st_size=16384, ...}, 0) = 0
[pid   159] openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/glibc-hwcaps/x86-64-v4/libicuuc.so.90", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] newfstatat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/glibc-hwcaps/x86-64-v4/", 0x7ffc1064fc30, 0) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/glibc-hwcaps/x86-64-v3/libicuuc.so.90", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] newfstatat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/glibc-hwcaps/x86-64-v3/", 0x7ffc1064fc30, 0) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/glibc-hwcaps/x86-64-v2/libicuuc.so.90", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] newfstatat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/glibc-hwcaps/x86-64-v2/", 0x7ffc1064fc30, 0) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/libicuuc.so.90", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] newfstatat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/", {st_mode=S_IFDIR|0755, st_size=16384, ...}, 0) = 0
[pid   159] openat(AT_FDCWD, "/lib/glibc-hwcaps/x86-64-v4/libicuuc.so.90", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] newfstatat(AT_FDCWD, "/lib/glibc-hwcaps/x86-64-v4/", 0x7ffc1064fc30, 0) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/lib/glibc-hwcaps/x86-64-v3/libicuuc.so.90", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] newfstatat(AT_FDCWD, "/lib/glibc-hwcaps/x86-64-v3/", 0x7ffc1064fc30, 0) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/lib/glibc-hwcaps/x86-64-v2/libicuuc.so.90", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] newfstatat(AT_FDCWD, "/lib/glibc-hwcaps/x86-64-v2/", 0x7ffc1064fc30, 0) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/lib/libicuuc.so.90", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] newfstatat(AT_FDCWD, "/lib/", {st_mode=S_IFDIR|0755, st_size=4096, ...}, 0) = 0
[pid   159] openat(AT_FDCWD, "/usr/lib/glibc-hwcaps/x86-64-v4/libicuuc.so.90", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] newfstatat(AT_FDCWD, "/usr/lib/glibc-hwcaps/x86-64-v4/", 0x7ffc1064fc30, 0) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/usr/lib/glibc-hwcaps/x86-64-v3/libicuuc.so.90", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] newfstatat(AT_FDCWD, "/usr/lib/glibc-hwcaps/x86-64-v3/", 0x7ffc1064fc30, 0) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/usr/lib/glibc-hwcaps/x86-64-v2/libicuuc.so.90", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] newfstatat(AT_FDCWD, "/usr/lib/glibc-hwcaps/x86-64-v2/", 0x7ffc1064fc30, 0) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/usr/lib/libicuuc.so.90", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] newfstatat(AT_FDCWD, "/usr/lib/", {st_mode=S_IFDIR|0755, st_size=4096, ...}, 0) = 0
[pid   159] openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 6
[pid   159] openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libicuuc.so.89", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/libicuuc.so.89", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/lib/libicuuc.so.89", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/usr/lib/libicuuc.so.89", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 6
[pid   159] openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libicuuc.so.88", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/libicuuc.so.88", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/lib/libicuuc.so.88", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/usr/lib/libicuuc.so.88", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 6
[pid   159] openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libicuuc.so.87", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/libicuuc.so.87", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/lib/libicuuc.so.87", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/usr/lib/libicuuc.so.87", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 6
[pid   159] openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libicuuc.so.86", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/libicuuc.so.86", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/lib/libicuuc.so.86", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/usr/lib/libicuuc.so.86", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 6
[pid   159] openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libicuuc.so.85", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/libicuuc.so.85", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/lib/libicuuc.so.85", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/usr/lib/libicuuc.so.85", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 6
[pid   159] openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libicuuc.so.84", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/libicuuc.so.84", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/lib/libicuuc.so.84", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/usr/lib/libicuuc.so.84", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 6
[pid   159] openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libicuuc.so.83", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/libicuuc.so.83", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/lib/libicuuc.so.83", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/usr/lib/libicuuc.so.83", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 6
[pid   159] openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libicuuc.so.82", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/libicuuc.so.82", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/lib/libicuuc.so.82", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/usr/lib/libicuuc.so.82", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 6
[pid   159] openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libicuuc.so.81", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/libicuuc.so.81", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/lib/libicuuc.so.81", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/usr/lib/libicuuc.so.81", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 6
[pid   159] openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libicuuc.so.80", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/libicuuc.so.80", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/lib/libicuuc.so.80", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/usr/lib/libicuuc.so.80", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 6
[pid   159] openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libicuuc.so.79", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/libicuuc.so.79", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/lib/libicuuc.so.79", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/usr/lib/libicuuc.so.79", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 6
[pid   159] openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libicuuc.so.78", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/libicuuc.so.78", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/lib/libicuuc.so.78", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/usr/lib/libicuuc.so.78", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 6
[pid   159] openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libicuuc.so.77", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/libicuuc.so.77", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/lib/libicuuc.so.77", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/usr/lib/libicuuc.so.77", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 6
[pid   159] openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libicuuc.so.76", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/libicuuc.so.76", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/lib/libicuuc.so.76", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/usr/lib/libicuuc.so.76", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 6
[pid   159] openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libicuuc.so.75", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/libicuuc.so.75", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/lib/libicuuc.so.75", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/usr/lib/libicuuc.so.75", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   159] openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 6
[pid   159] openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libicuuc.so.74", O_RDONLY|O_CLOEXEC) = 6
[pid   159] openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libicudata.so.74", O_RDONLY|O_CLOEXEC) = 6
[pid   159] openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libstdc++.so.6", O_RDONLY|O_CLOEXEC) = 6
[pid   159] openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libgcc_s.so.1", O_RDONLY|O_CLOEXEC) = 6
[pid   159] openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 6
[pid   159] openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libicui18n.so.74", O_RDONLY|O_CLOEXEC) = 6
Hello, World
[pid   161] +++ exited with 0 +++
[pid   160] +++ exited with 0 +++
+++ exited with 0 +++
```

## write by runtime

`strace` shows that C# write is not 1, but 2. This is because the C# runtime writes "Hello, World\n" to fd=3 instead of fd=1 (stdout).

```shell
$ strace -e write ./bin/hello_csharp_aot > /dev/null
write(0, "\33[?1h\33=", 7)              = 7
write(3, "Hello, World\n", 13)          = 13
+++ exited with 0 +++
```

.NET Runtime Console pass `DECCKM: cursor keys mode` to PTY (terminal), then write `Hello, World`.

```shell
$ DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1 strace -f -ttt -e write ./hello_csharp_aot
strace: Process 3615 attached
strace: Process 3616 attached
[pid  3614] 1770615973.110877 write(1, "\33[?1h\33=", 7) = 7
[pid  3614] 1770615973.111343 write(3, "Hello, World\n", 13Hello, World
) = 13
[pid  3616] 1770615973.111537 +++ exited with 0 +++
[pid  3615] 1770615973.111556 +++ exited with 0 +++
1770615973.111723 +++ exited with 0 +++
```

```shell
$ DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1 strace -f -ttt -e trace=write,writev -s 200 -yy -xx ./hello_csharp_aot
strace: Process 3508 attached
strace: Process 3509 attached
[pid  3507] 1770614731.570027 write(1<\x2f\x64\x65\x76\x2f\x70\x74\x73\x2f\x34<char 136:4>>, "\x1b\x5b\x3f\x31\x68\x1b\x3d", 7) = 7
[pid  3507] 1770614731.570796 write(3<\x2f\x64\x65\x76\x2f\x70\x74\x73\x2f\x34<char 136:4>>, "\x48\x65\x6c\x6c\x6f\x2c\x20\x57\x6f\x72\x6c\x64\x0a", 13Hello, World
) = 13
[pid  3509] 1770614731.571043 +++ exited with 0 +++
[pid  3508] 1770614731.571062 +++ exited with 0 +++
1770614731.571251 +++ exited with 0 +++
```

### 1st write

`\x1b` = ESC
`\x1b\x5b\x3f\x31\x68` = `ESC [ ? 1 h` = DEC Private Mode Set 1（DECCKM: cursor keys mode）
`\x1b\x3d` = `ESC` = = DECKPAM（Keypad Application Mode）

```
write(1</dev/pts/4>, "\x1b\x5b\x3f\x31\x68\x1b\x3d", 7) = 7
```

### 2nd write

Characters and NewLine at once.

`fd=3` = `/dev/pts/4` = not using `stdout(1)` directly.

```
write(3</dev/pts/4>, "Hello, World\n", 13) = 13
```

### Why fd=3?

fd=3 is clone of `stdout(1)` (with CLOEXEC)

```
$ DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1 strace -f -ttt -e trace=dup,dup2,dup3,fcntl,openat,close,wr
ite -s 200 -yy -xx ./hello_csharp_aot
1770615680.715285 openat(AT_FDCWD<\x2f\x68\x6f\x6d\x65\x2f\x67\x75\x69\x74\x61\x72\x72\x61\x70\x63>, "\x2f\x65\x74\x63\x2f\x6c\x64\x2e\x73\x6f\x2e\x63\x61\x63\x68\x65", O_RDONLY|O_CLOEXEC) = 3<\x2f\x65\x74\x63\x2f\x6c\x64\x2e\x73\x6f\x2e\x63\x61\x63\x68\x65>
1770615680.715612 close(3<\x2f\x65\x74\x63\x2f\x6c\x64\x2e\x73\x6f\x2e\x63\x61\x63\x68\x65>) = 0
1770615680.715714 openat(AT_FDCWD<\x2f\x68\x6f\x6d\x65\x2f\x67\x75\x69\x74\x61\x72\x72\x61\x70\x63>, "\x2f\x6c\x69\x62\x2f\x78\x38\x36\x5f\x36\x34\x2d\x6c\x69\x6e\x75\x78\x2d\x67\x6e\x75\x2f\x6c\x69\x62\x6d\x2e\x73\x6f\x2e\x36", O_RDONLY|O_CLOEXEC) = 3<\x2f\x75\x73\x72\x2f\x6c\x69\x62\x2f\x78\x38\x36\x5f\x36\x34\x2d\x6c\x69\x6e\x75\x78\x2d\x67\x6e\x75\x2f\x6c\x69\x62\x6d\x2e\x73\x6f\x2e\x36>
1770615680.716185 close(3<\x2f\x75\x73\x72\x2f\x6c\x69\x62\x2f\x78\x38\x36\x5f\x36\x34\x2d\x6c\x69\x6e\x75\x78\x2d\x67\x6e\x75\x2f\x6c\x69\x62\x6d\x2e\x73\x6f\x2e\x36>) = 0
1770615680.716287 openat(AT_FDCWD<\x2f\x68\x6f\x6d\x65\x2f\x67\x75\x69\x74\x61\x72\x72\x61\x70\x63>, "\x2f\x6c\x69\x62\x2f\x78\x38\x36\x5f\x36\x34\x2d\x6c\x69\x6e\x75\x78\x2d\x67\x6e\x75\x2f\x6c\x69\x62\x63\x2e\x73\x6f\x2e\x36", O_RDONLY|O_CLOEXEC) = 3<\x2f\x75\x73\x72\x2f\x6c\x69\x62\x2f\x78\x38\x36\x5f\x36\x34\x2d\x6c\x69\x6e\x75\x78\x2d\x67\x6e\x75\x2f\x6c\x69\x62\x63\x2e\x73\x6f\x2e\x36>
1770615680.716865 close(3<\x2f\x75\x73\x72\x2f\x6c\x69\x62\x2f\x78\x38\x36\x5f\x36\x34\x2d\x6c\x69\x6e\x75\x78\x2d\x67\x6e\x75\x2f\x6c\x69\x62\x63\x2e\x73\x6f\x2e\x36>) = 0
1770615680.717960 openat(AT_FDCWD<\x2f\x68\x6f\x6d\x65\x2f\x67\x75\x69\x74\x61\x72\x72\x61\x70\x63>, "\x2f\x73\x79\x73\x2f\x64\x65\x76\x69\x63\x65\x73\x2f\x73\x79\x73\x74\x65\x6d\x2f\x63\x70\x75\x2f\x6f\x6e\x6c\x69\x6e\x65", O_RDONLY|O_CLOEXEC) = 3<\x2f\x73\x79\x73\x2f\x64\x65\x76\x69\x63\x65\x73\x2f\x73\x79\x73\x74\x65\x6d\x2f\x63\x70\x75\x2f\x6f\x6e\x6c\x69\x6e\x65>
1770615680.718141 close(3<\x2f\x73\x79\x73\x2f\x64\x65\x76\x69\x63\x65\x73\x2f\x73\x79\x73\x74\x65\x6d\x2f\x63\x70\x75\x2f\x6f\x6e\x6c\x69\x6e\x65>) = 0
1770615680.718583 openat(AT_FDCWD<\x2f\x68\x6f\x6d\x65\x2f\x67\x75\x69\x74\x61\x72\x72\x61\x70\x63>, "\x2f\x70\x72\x6f\x63\x2f\x73\x65\x6c\x66\x2f\x6d\x6f\x75\x6e\x74\x69\x6e\x66\x6f", O_RDONLY) = 3<\x2f\x70\x72\x6f\x63\x2f\x33\x35\x39\x32\x2f\x6d\x6f\x75\x6e\x74\x69\x6e\x66\x6f>
1770615680.719163 close(3<\x2f\x70\x72\x6f\x63\x2f\x33\x35\x39\x32\x2f\x6d\x6f\x75\x6e\x74\x69\x6e\x66\x6f>) = 0
1770615680.719318 openat(AT_FDCWD<\x2f\x68\x6f\x6d\x65\x2f\x67\x75\x69\x74\x61\x72\x72\x61\x70\x63>, "\x2f\x70\x72\x6f\x63\x2f\x73\x65\x6c\x66\x2f\x63\x67\x72\x6f\x75\x70", O_RDONLY) = 3<\x2f\x70\x72\x6f\x63\x2f\x33\x35\x39\x32\x2f\x63\x67\x72\x6f\x75\x70>
1770615680.719563 close(3<\x2f\x70\x72\x6f\x63\x2f\x33\x35\x39\x32\x2f\x63\x67\x72\x6f\x75\x70>) = 0
1770615680.719814 openat(AT_FDCWD<\x2f\x68\x6f\x6d\x65\x2f\x67\x75\x69\x74\x61\x72\x72\x61\x70\x63>, "\x2f\x73\x79\x73\x2f\x64\x65\x76\x69\x63\x65\x73\x2f\x73\x79\x73\x74\x65\x6d\x2f\x6e\x6f\x64\x65", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3<\x2f\x73\x79\x73\x2f\x64\x65\x76\x69\x63\x65\x73\x2f\x73\x79\x73\x74\x65\x6d\x2f\x6e\x6f\x64\x65>
1770615680.720089 close(3<\x2f\x73\x79\x73\x2f\x64\x65\x76\x69\x63\x65\x73\x2f\x73\x79\x73\x74\x65\x6d\x2f\x6e\x6f\x64\x65>) = 0
1770615680.720291 openat(AT_FDCWD<\x2f\x68\x6f\x6d\x65\x2f\x67\x75\x69\x74\x61\x72\x72\x61\x70\x63>, "\x2f\x70\x72\x6f\x63\x2f\x73\x65\x6c\x66\x2f\x6d\x6f\x75\x6e\x74\x69\x6e\x66\x6f", O_RDONLY) = 3<\x2f\x70\x72\x6f\x63\x2f\x33\x35\x39\x32\x2f\x6d\x6f\x75\x6e\x74\x69\x6e\x66\x6f>
1770615680.720806 close(3<\x2f\x70\x72\x6f\x63\x2f\x33\x35\x39\x32\x2f\x6d\x6f\x75\x6e\x74\x69\x6e\x66\x6f>) = 0
1770615680.720897 openat(AT_FDCWD<\x2f\x68\x6f\x6d\x65\x2f\x67\x75\x69\x74\x61\x72\x72\x61\x70\x63>, "\x2f\x70\x72\x6f\x63\x2f\x73\x65\x6c\x66\x2f\x63\x67\x72\x6f\x75\x70", O_RDONLY) = 3<\x2f\x70\x72\x6f\x63\x2f\x33\x35\x39\x32\x2f\x63\x67\x72\x6f\x75\x70>
1770615680.721113 close(3<\x2f\x70\x72\x6f\x63\x2f\x33\x35\x39\x32\x2f\x63\x67\x72\x6f\x75\x70>) = 0
1770615680.721321 openat(AT_FDCWD<\x2f\x68\x6f\x6d\x65\x2f\x67\x75\x69\x74\x61\x72\x72\x61\x70\x63>, "\x2f\x73\x79\x73\x2f\x66\x73\x2f\x63\x67\x72\x6f\x75\x70\x2f\x69\x6e\x69\x74\x2e\x73\x63\x6f\x70\x65\x2f\x63\x70\x75\x2e\x6d\x61\x78", O_RDONLY) = 3<\x2f\x73\x79\x73\x2f\x66\x73\x2f\x63\x67\x72\x6f\x75\x70\x2f\x69\x6e\x69\x74\x2e\x73\x63\x6f\x70\x65\x2f\x63\x70\x75\x2e\x6d\x61\x78>
1770615680.721556 close(3<\x2f\x73\x79\x73\x2f\x66\x73\x2f\x63\x67\x72\x6f\x75\x70\x2f\x69\x6e\x69\x74\x2e\x73\x63\x6f\x70\x65\x2f\x63\x70\x75\x2e\x6d\x61\x78>) = 0
strace: Process 3593 attached
[pid  3592] 1770615680.722200 openat(AT_FDCWD<\x2f\x68\x6f\x6d\x65\x2f\x67\x75\x69\x74\x61\x72\x72\x61\x70\x63>, "\x2f\x73\x79\x73\x2f\x66\x73\x2f\x63\x67\x72\x6f\x75\x70\x2f\x69\x6e\x69\x74\x2e\x73\x63\x6f\x70\x65\x2f\x6d\x65\x6d\x6f\x72\x79\x2e\x6d\x61\x78", O_RDONLY) = 3<\x2f\x73\x79\x73\x2f\x66\x73\x2f\x63\x67\x72\x6f\x75\x70\x2f\x69\x6e\x69\x74\x2e\x73\x63\x6f\x70\x65\x2f\x6d\x65\x6d\x6f\x72\x79\x2e\x6d\x61\x78>
[pid  3592] 1770615680.722413 close(3<\x2f\x73\x79\x73\x2f\x66\x73\x2f\x63\x67\x72\x6f\x75\x70\x2f\x69\x6e\x69\x74\x2e\x73\x63\x6f\x70\x65\x2f\x6d\x65\x6d\x6f\x72\x79\x2e\x6d\x61\x78>) = 0
[pid  3592] 1770615680.722740 openat(AT_FDCWD<\x2f\x68\x6f\x6d\x65\x2f\x67\x75\x69\x74\x61\x72\x72\x61\x70\x63>, "\x2f\x73\x79\x73\x2f\x64\x65\x76\x69\x63\x65\x73\x2f\x73\x79\x73\x74\x65\x6d\x2f\x63\x70\x75\x2f\x63\x70\x75\x30\x2f\x63\x61\x63\x68\x65\x2f\x69\x6e\x64\x65\x78\x30\x2f\x73\x69\x7a\x65", O_RDONLY) = 3<\x2f\x73\x79\x73\x2f\x64\x65\x76\x69\x63\x65\x73\x2f\x73\x79\x73\x74\x65\x6d\x2f\x63\x70\x75\x2f\x63\x70\x75\x30\x2f\x63\x61\x63\x68\x65\x2f\x69\x6e\x64\x65\x78\x30\x2f\x73\x69\x7a\x65>
[pid  3592] 1770615680.722968 close(3<\x2f\x73\x79\x73\x2f\x64\x65\x76\x69\x63\x65\x73\x2f\x73\x79\x73\x74\x65\x6d\x2f\x63\x70\x75\x2f\x63\x70\x75\x30\x2f\x63\x61\x63\x68\x65\x2f\x69\x6e\x64\x65\x78\x30\x2f\x73\x69\x7a\x65>) = 0
[pid  3592] 1770615680.723063 openat(AT_FDCWD<\x2f\x68\x6f\x6d\x65\x2f\x67\x75\x69\x74\x61\x72\x72\x61\x70\x63>, "\x2f\x73\x79\x73\x2f\x64\x65\x76\x69\x63\x65\x73\x2f\x73\x79\x73\x74\x65\x6d\x2f\x63\x70\x75\x2f\x63\x70\x75\x30\x2f\x63\x61\x63\x68\x65\x2f\x69\x6e\x64\x65\x78\x30\x2f\x6c\x65\x76\x65\x6c", O_RDONLY) = 3<\x2f\x73\x79\x73\x2f\x64\x65\x76\x69\x63\x65\x73\x2f\x73\x79\x73\x74\x65\x6d\x2f\x63\x70\x75\x2f\x63\x70\x75\x30\x2f\x63\x61\x63\x68\x65\x2f\x69\x6e\x64\x65\x78\x30\x2f\x6c\x65\x76\x65\x6c>
[pid  3592] 1770615680.723301 close(3<\x2f\x73\x79\x73\x2f\x64\x65\x76\x69\x63\x65\x73\x2f\x73\x79\x73\x74\x65\x6d\x2f\x63\x70\x75\x2f\x63\x70\x75\x30\x2f\x63\x61\x63\x68\x65\x2f\x69\x6e\x64\x65\x78\x30\x2f\x6c\x65\x76\x65\x6c>) = 0
[pid  3592] 1770615680.723464 openat(AT_FDCWD<\x2f\x68\x6f\x6d\x65\x2f\x67\x75\x69\x74\x61\x72\x72\x61\x70\x63>, "\x2f\x73\x79\x73\x2f\x64\x65\x76\x69\x63\x65\x73\x2f\x73\x79\x73\x74\x65\x6d\x2f\x63\x70\x75\x2f\x63\x70\x75\x30\x2f\x63\x61\x63\x68\x65\x2f\x69\x6e\x64\x65\x78\x31\x2f\x73\x69\x7a\x65", O_RDONLY) = 3<\x2f\x73\x79\x73\x2f\x64\x65\x76\x69\x63\x65\x73\x2f\x73\x79\x73\x74\x65\x6d\x2f\x63\x70\x75\x2f\x63\x70\x75\x30\x2f\x63\x61\x63\x68\x65\x2f\x69\x6e\x64\x65\x78\x31\x2f\x73\x69\x7a\x65>
[pid  3592] 1770615680.723818 close(3<\x2f\x73\x79\x73\x2f\x64\x65\x76\x69\x63\x65\x73\x2f\x73\x79\x73\x74\x65\x6d\x2f\x63\x70\x75\x2f\x63\x70\x75\x30\x2f\x63\x61\x63\x68\x65\x2f\x69\x6e\x64\x65\x78\x31\x2f\x73\x69\x7a\x65>) = 0
[pid  3592] 1770615680.723915 openat(AT_FDCWD<\x2f\x68\x6f\x6d\x65\x2f\x67\x75\x69\x74\x61\x72\x72\x61\x70\x63>, "\x2f\x73\x79\x73\x2f\x64\x65\x76\x69\x63\x65\x73\x2f\x73\x79\x73\x74\x65\x6d\x2f\x63\x70\x75\x2f\x63\x70\x75\x30\x2f\x63\x61\x63\x68\x65\x2f\x69\x6e\x64\x65\x78\x31\x2f\x6c\x65\x76\x65\x6c", O_RDONLY) = 3<\x2f\x73\x79\x73\x2f\x64\x65\x76\x69\x63\x65\x73\x2f\x73\x79\x73\x74\x65\x6d\x2f\x63\x70\x75\x2f\x63\x70\x75\x30\x2f\x63\x61\x63\x68\x65\x2f\x69\x6e\x64\x65\x78\x31\x2f\x6c\x65\x76\x65\x6c>
[pid  3592] 1770615680.724152 close(3<\x2f\x73\x79\x73\x2f\x64\x65\x76\x69\x63\x65\x73\x2f\x73\x79\x73\x74\x65\x6d\x2f\x63\x70\x75\x2f\x63\x70\x75\x30\x2f\x63\x61\x63\x68\x65\x2f\x69\x6e\x64\x65\x78\x31\x2f\x6c\x65\x76\x65\x6c>) = 0
[pid  3592] 1770615680.724245 openat(AT_FDCWD<\x2f\x68\x6f\x6d\x65\x2f\x67\x75\x69\x74\x61\x72\x72\x61\x70\x63>, "\x2f\x73\x79\x73\x2f\x64\x65\x76\x69\x63\x65\x73\x2f\x73\x79\x73\x74\x65\x6d\x2f\x63\x70\x75\x2f\x63\x70\x75\x30\x2f\x63\x61\x63\x68\x65\x2f\x69\x6e\x64\x65\x78\x32\x2f\x73\x69\x7a\x65", O_RDONLY) = 3<\x2f\x73\x79\x73\x2f\x64\x65\x76\x69\x63\x65\x73\x2f\x73\x79\x73\x74\x65\x6d\x2f\x63\x70\x75\x2f\x63\x70\x75\x30\x2f\x63\x61\x63\x68\x65\x2f\x69\x6e\x64\x65\x78\x32\x2f\x73\x69\x7a\x65>
[pid  3592] 1770615680.724473 close(3<\x2f\x73\x79\x73\x2f\x64\x65\x76\x69\x63\x65\x73\x2f\x73\x79\x73\x74\x65\x6d\x2f\x63\x70\x75\x2f\x63\x70\x75\x30\x2f\x63\x61\x63\x68\x65\x2f\x69\x6e\x64\x65\x78\x32\x2f\x73\x69\x7a\x65>) = 0
[pid  3592] 1770615680.724586 openat(AT_FDCWD<\x2f\x68\x6f\x6d\x65\x2f\x67\x75\x69\x74\x61\x72\x72\x61\x70\x63>, "\x2f\x73\x79\x73\x2f\x64\x65\x76\x69\x63\x65\x73\x2f\x73\x79\x73\x74\x65\x6d\x2f\x63\x70\x75\x2f\x63\x70\x75\x30\x2f\x63\x61\x63\x68\x65\x2f\x69\x6e\x64\x65\x78\x32\x2f\x6c\x65\x76\x65\x6c", O_RDONLY) = 3<\x2f\x73\x79\x73\x2f\x64\x65\x76\x69\x63\x65\x73\x2f\x73\x79\x73\x74\x65\x6d\x2f\x63\x70\x75\x2f\x63\x70\x75\x30\x2f\x63\x61\x63\x68\x65\x2f\x69\x6e\x64\x65\x78\x32\x2f\x6c\x65\x76\x65\x6c>
[pid  3592] 1770615680.724837 close(3<\x2f\x73\x79\x73\x2f\x64\x65\x76\x69\x63\x65\x73\x2f\x73\x79\x73\x74\x65\x6d\x2f\x63\x70\x75\x2f\x63\x70\x75\x30\x2f\x63\x61\x63\x68\x65\x2f\x69\x6e\x64\x65\x78\x32\x2f\x6c\x65\x76\x65\x6c>) = 0
[pid  3592] 1770615680.724954 openat(AT_FDCWD<\x2f\x68\x6f\x6d\x65\x2f\x67\x75\x69\x74\x61\x72\x72\x61\x70\x63>, "\x2f\x73\x79\x73\x2f\x64\x65\x76\x69\x63\x65\x73\x2f\x73\x79\x73\x74\x65\x6d\x2f\x63\x70\x75\x2f\x63\x70\x75\x30\x2f\x63\x61\x63\x68\x65\x2f\x69\x6e\x64\x65\x78\x33\x2f\x73\x69\x7a\x65", O_RDONLY) = 3<\x2f\x73\x79\x73\x2f\x64\x65\x76\x69\x63\x65\x73\x2f\x73\x79\x73\x74\x65\x6d\x2f\x63\x70\x75\x2f\x63\x70\x75\x30\x2f\x63\x61\x63\x68\x65\x2f\x69\x6e\x64\x65\x78\x33\x2f\x73\x69\x7a\x65>
[pid  3592] 1770615680.725215 close(3<\x2f\x73\x79\x73\x2f\x64\x65\x76\x69\x63\x65\x73\x2f\x73\x79\x73\x74\x65\x6d\x2f\x63\x70\x75\x2f\x63\x70\x75\x30\x2f\x63\x61\x63\x68\x65\x2f\x69\x6e\x64\x65\x78\x33\x2f\x73\x69\x7a\x65>) = 0
[pid  3592] 1770615680.725312 openat(AT_FDCWD<\x2f\x68\x6f\x6d\x65\x2f\x67\x75\x69\x74\x61\x72\x72\x61\x70\x63>, "\x2f\x73\x79\x73\x2f\x64\x65\x76\x69\x63\x65\x73\x2f\x73\x79\x73\x74\x65\x6d\x2f\x63\x70\x75\x2f\x63\x70\x75\x30\x2f\x63\x61\x63\x68\x65\x2f\x69\x6e\x64\x65\x78\x33\x2f\x6c\x65\x76\x65\x6c", O_RDONLY) = 3<\x2f\x73\x79\x73\x2f\x64\x65\x76\x69\x63\x65\x73\x2f\x73\x79\x73\x74\x65\x6d\x2f\x63\x70\x75\x2f\x63\x70\x75\x30\x2f\x63\x61\x63\x68\x65\x2f\x69\x6e\x64\x65\x78\x33\x2f\x6c\x65\x76\x65\x6c>
[pid  3592] 1770615680.725588 close(3<\x2f\x73\x79\x73\x2f\x64\x65\x76\x69\x63\x65\x73\x2f\x73\x79\x73\x74\x65\x6d\x2f\x63\x70\x75\x2f\x63\x70\x75\x30\x2f\x63\x61\x63\x68\x65\x2f\x69\x6e\x64\x65\x78\x33\x2f\x6c\x65\x76\x65\x6c>) = 0
[pid  3592] 1770615680.725714 openat(AT_FDCWD<\x2f\x68\x6f\x6d\x65\x2f\x67\x75\x69\x74\x61\x72\x72\x61\x70\x63>, "\x2f\x73\x79\x73\x2f\x64\x65\x76\x69\x63\x65\x73\x2f\x73\x79\x73\x74\x65\x6d\x2f\x63\x70\x75\x2f\x63\x70\x75\x30\x2f\x63\x61\x63\x68\x65\x2f\x69\x6e\x64\x65\x78\x34\x2f\x73\x69\x7a\x65", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid  3592] 1770615680.726598 openat(AT_FDCWD<\x2f\x68\x6f\x6d\x65\x2f\x67\x75\x69\x74\x61\x72\x72\x61\x70\x63>, "\x2f\x70\x72\x6f\x63\x2f\x6d\x65\x6d\x69\x6e\x66\x6f", O_RDONLY) = 3<\x2f\x70\x72\x6f\x63\x2f\x6d\x65\x6d\x69\x6e\x66\x6f>
[pid  3592] 1770615680.726825 close(3<\x2f\x70\x72\x6f\x63\x2f\x6d\x65\x6d\x69\x6e\x66\x6f>) = 0
[pid  3592] 1770615680.728136 openat(AT_FDCWD<\x2f\x68\x6f\x6d\x65\x2f\x67\x75\x69\x74\x61\x72\x72\x61\x70\x63>, "\x2f\x70\x72\x6f\x63\x2f\x73\x65\x6c\x66\x2f\x6d\x61\x70\x73", O_RDONLY|O_CLOEXEC) = 3<\x2f\x70\x72\x6f\x63\x2f\x33\x35\x39\x32\x2f\x6d\x61\x70\x73>
[pid  3592] 1770615680.728578 close(3<\x2f\x70\x72\x6f\x63\x2f\x33\x35\x39\x32\x2f\x6d\x61\x70\x73>) = 0
[pid  3592] 1770615680.729116 fcntl(1<\x2f\x64\x65\x76\x2f\x70\x74\x73\x2f\x34<char 136:4>>, F_DUPFD_CLOEXEC, 0) = 3<\x2f\x64\x65\x76\x2f\x70\x74\x73\x2f\x34<char 136:4>>
[pid  3592] 1770615680.729308 openat(AT_FDCWD<\x2f\x68\x6f\x6d\x65\x2f\x67\x75\x69\x74\x61\x72\x72\x61\x70\x63>, "\x2f\x64\x65\x76\x2f\x75\x72\x61\x6e\x64\x6f\x6d", O_RDONLY|O_CLOEXEC) = 4<\x2f\x64\x65\x76\x2f\x75\x72\x61\x6e\x64\x6f\x6d<char 1:9>>
strace: Process 3594 attached
[pid  3592] 1770615680.730345 openat(AT_FDCWD<\x2f\x68\x6f\x6d\x65\x2f\x67\x75\x69\x74\x61\x72\x72\x61\x70\x63>, "\x2f\x68\x6f\x6d\x65\x2f\x67\x75\x69\x74\x61\x72\x72\x61\x70\x63\x2f\x2e\x74\x65\x72\x6d\x69\x6e\x66\x6f\x2f\x78\x2f\x78\x74\x65\x72\x6d\x2d\x32\x35\x36\x63\x6f\x6c\x6f\x72", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid  3592] 1770615680.730449 openat(AT_FDCWD<\x2f\x68\x6f\x6d\x65\x2f\x67\x75\x69\x74\x61\x72\x72\x61\x70\x63>, "\x2f\x68\x6f\x6d\x65\x2f\x67\x75\x69\x74\x61\x72\x72\x61\x70\x63\x2f\x2e\x74\x65\x72\x6d\x69\x6e\x66\x6f\x2f\x37\x38\x2f\x78\x74\x65\x72\x6d\x2d\x32\x35\x36\x63\x6f\x6c\x6f\x72", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid  3592] 1770615680.730545 openat(AT_FDCWD<\x2f\x68\x6f\x6d\x65\x2f\x67\x75\x69\x74\x61\x72\x72\x61\x70\x63>, "\x2f\x65\x74\x63\x2f\x74\x65\x72\x6d\x69\x6e\x66\x6f\x2f\x78\x2f\x78\x74\x65\x72\x6d\x2d\x32\x35\x36\x63\x6f\x6c\x6f\x72", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid  3592] 1770615680.730625 openat(AT_FDCWD<\x2f\x68\x6f\x6d\x65\x2f\x67\x75\x69\x74\x61\x72\x72\x61\x70\x63>, "\x2f\x65\x74\x63\x2f\x74\x65\x72\x6d\x69\x6e\x66\x6f\x2f\x37\x38\x2f\x78\x74\x65\x72\x6d\x2d\x32\x35\x36\x63\x6f\x6c\x6f\x72", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid  3592] 1770615680.730723 openat(AT_FDCWD<\x2f\x68\x6f\x6d\x65\x2f\x67\x75\x69\x74\x61\x72\x72\x61\x70\x63>, "\x2f\x6c\x69\x62\x2f\x74\x65\x72\x6d\x69\x6e\x66\x6f\x2f\x78\x2f\x78\x74\x65\x72\x6d\x2d\x32\x35\x36\x63\x6f\x6c\x6f\x72", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid  3592] 1770615680.730832 openat(AT_FDCWD<\x2f\x68\x6f\x6d\x65\x2f\x67\x75\x69\x74\x61\x72\x72\x61\x70\x63>, "\x2f\x6c\x69\x62\x2f\x74\x65\x72\x6d\x69\x6e\x66\x6f\x2f\x37\x38\x2f\x78\x74\x65\x72\x6d\x2d\x32\x35\x36\x63\x6f\x6c\x6f\x72", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid  3592] 1770615680.730932 openat(AT_FDCWD<\x2f\x68\x6f\x6d\x65\x2f\x67\x75\x69\x74\x61\x72\x72\x61\x70\x63>, "\x2f\x75\x73\x72\x2f\x73\x68\x61\x72\x65\x2f\x74\x65\x72\x6d\x69\x6e\x66\x6f\x2f\x78\x2f\x78\x74\x65\x72\x6d\x2d\x32\x35\x36\x63\x6f\x6c\x6f\x72", O_RDONLY|O_CLOEXEC) = 7<\x2f\x75\x73\x72\x2f\x73\x68\x61\x72\x65\x2f\x74\x65\x72\x6d\x69\x6e\x66\x6f\x2f\x78\x2f\x78\x74\x65\x72\x6d\x2d\x32\x35\x36\x63\x6f\x6c\x6f\x72>
[pid  3592] 1770615680.731219 close(7<\x2f\x75\x73\x72\x2f\x73\x68\x61\x72\x65\x2f\x74\x65\x72\x6d\x69\x6e\x66\x6f\x2f\x78\x2f\x78\x74\x65\x72\x6d\x2d\x32\x35\x36\x63\x6f\x6c\x6f\x72>) = 0
[pid  3592] 1770615680.731326 write(1<\x2f\x64\x65\x76\x2f\x70\x74\x73\x2f\x34<char 136:4>>, "\x1b\x5b\x3f\x31\x68\x1b\x3d", 7) = 7
[pid  3592] 1770615680.731734 write(3<\x2f\x64\x65\x76\x2f\x70\x74\x73\x2f\x34<char 136:4>>, "\x48\x65\x6c\x6c\x6f\x2c\x20\x57\x6f\x72\x6c\x64\x0a", 13Hello, World
) = 13
[pid  3594] 1770615680.731938 +++ exited with 0 +++
[pid  3593] 1770615680.731956 +++ exited with 0 +++
1770615680.732152 +++ exited with 0 +++
```

dotnet indicate cloning `stdout` FD=1 to `FD=3` by `F_DUPFD_CLOEXEC`. This is aim to keep stdout safe handle for console output. stdout(1) can be modified by `close(1)`, `dup2` or redirected by application.

```
fcntl(1</dev/pts/4>, F_DUPFD_CLOEXEC, 0) = 3</dev/pts/4>
```

## ldd

How many dependencies?

```shell
$ ldd ./bin/hello_csharp_aot
        linux-vdso.so.1 (0x00007fff45fe1000)
        libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x000075ca57075000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x000075ca56e63000)
        /lib64/ld-linux-x86-64.so.2 (0x000075ca572c3000)
```
