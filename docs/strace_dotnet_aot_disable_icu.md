## syscalls

Without ICU significantly reduce openat.

```shell
$ DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1 strace -c ./bin/hello_csharp_aot
Hello, World
% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ------------------
 18.23    0.000144           5        28         7 openat
 14.18    0.000112           6        18           rt_sigaction
 14.05    0.000111          55         2           clone
  8.48    0.000067           2        30           read
  6.84    0.000054          13         4           ioctl
  6.46    0.000051           2        22           mprotect
  4.81    0.000038           6         6           rt_sigprocmask
  4.68    0.000037          18         2           write
  3.16    0.000025           1        20           mmap
  2.78    0.000022           1        21           close
  2.78    0.000022           1        17           madvise
  2.53    0.000020           1        20           fstat
  2.28    0.000018          18         1           pipe2
  1.65    0.000013           4         3           pread64
  1.39    0.000011           3         3           sched_getaffinity
  1.27    0.000010          10         1           fcntl
  1.14    0.000009           9         1           lseek
  1.14    0.000009           3         3           getpid
  1.14    0.000009           2         4           prlimit64
  1.01    0.000008           8         1           gettid
  0.00    0.000000           0         4           munmap
  0.00    0.000000           0         3           brk
  0.00    0.000000           0         1         1 access
  0.00    0.000000           0         1           execve
  0.00    0.000000           0         1           sysinfo
  0.00    0.000000           0         2           statfs
  0.00    0.000000           0         1           arch_prctl
  0.00    0.000000           0         1           set_tid_address
  0.00    0.000000           0         1         1 get_mempolicy
  0.00    0.000000           0         1           set_robust_list
  0.00    0.000000           0         1           getrandom
  0.00    0.000000           0         2           membarrier
  0.00    0.000000           0         1           rseq
  0.00    0.000000           0         1         1 clone3
------ ----------- ----------- --------- --------- ------------------
100.00    0.000790           3       228        10 total
```

## Why so many openat (loader)?

Disabling ICU stop searching icu.

```shell
$ DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1 strace -f -e trace=openat,newfstatat,access -s 200 ./bin/hello_csharp_aot 2>&1
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
strace: Process 187 attached
[pid   186] openat(AT_FDCWD, "/sys/fs/cgroup//memory.max", O_RDONLY) = 3
[pid   186] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index0/size", O_RDONLY) = 3
[pid   186] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index0/level", O_RDONLY) = 3
[pid   186] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index1/size", O_RDONLY) = 3
[pid   186] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index1/level", O_RDONLY) = 3
[pid   186] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index2/size", O_RDONLY) = 3
[pid   186] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index2/level", O_RDONLY) = 3
[pid   186] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index3/size", O_RDONLY) = 3
[pid   186] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index3/level", O_RDONLY) = 3
[pid   186] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index4/size", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid   186] openat(AT_FDCWD, "/proc/meminfo", O_RDONLY) = 3
[pid   186] openat(AT_FDCWD, "/proc/self/maps", O_RDONLY|O_CLOEXEC) = 3
strace: Process 188 attached
[pid   186] openat(AT_FDCWD, "/root/.terminfo/x/xterm", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   186] openat(AT_FDCWD, "/root/.terminfo/78/xterm", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   186] openat(AT_FDCWD, "/etc/terminfo/x/xterm", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   186] openat(AT_FDCWD, "/etc/terminfo/78/xterm", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   186] openat(AT_FDCWD, "/lib/terminfo/x/xterm", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   186] openat(AT_FDCWD, "/lib/terminfo/78/xterm", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   186] openat(AT_FDCWD, "/usr/share/terminfo/x/xterm", O_RDONLY|O_CLOEXEC) = 6
Hello, World
[pid   188] +++ exited with 0 +++
[pid   187] +++ exited with 0 +++
+++ exited with 0 +++
```

## ldd

How many dependencies?

```shell
$ DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1 ldd ./bin/hello_csharp_aot
        linux-vdso.so.1 (0x00007fff45fe1000)
        libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x000075ca57075000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x000075ca56e63000)
        /lib64/ld-linux-x86-64.so.2 (0x000075ca572c3000)
```
