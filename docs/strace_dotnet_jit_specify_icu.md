## syscalls

Specifing ICU version significantly reduce openat while uging ICU.

```shell
$ DOTNET_ICU_VERSION_OVERRIDE=74 strace -c ./bin/hello_csharp
Hello, World
% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ------------------
 38.07    0.003370          10       322           mprotect
 16.23    0.001437           9       144           mmap
  9.27    0.000821          10        82        28 openat
  4.80    0.000425           7        55           read
  4.06    0.000359          51         7           clone
  3.66    0.000324           6        50           fstat
  3.28    0.000290          13        21           pread64
  2.64    0.000234           5        44           close
  2.04    0.000181           7        23           madvise
  2.01    0.000178           4        38        34 readlink
  1.86    0.000165          18         9           stat
  1.82    0.000161           7        21           munmap
  1.69    0.000150          18         8           write
  1.66    0.000147           6        22           fcntl
  1.60    0.000142           9        15           rt_sigprocmask
  1.17    0.000104           4        24           rt_sigaction
  1.01    0.000089           9         9           futex
  0.66    0.000058           5        10           brk
  0.59    0.000052          13         4           ioctl
  0.51    0.000045           9         5         2 unlink
  0.40    0.000035           3        10           prlimit64
  0.28    0.000025           5         5           getpid
  0.23    0.000020           5         4           sched_getaffinity
  0.21    0.000019           3         6         6 access
  0.14    0.000012           6         2           pipe2
  0.11    0.000010          10         1           lseek
  0.00    0.000000           0         1           socket
  0.00    0.000000           0         1           bind
  0.00    0.000000           0         1           listen
  0.00    0.000000           0         1           execve
  0.00    0.000000           0         1           ftruncate
  0.00    0.000000           0         1           fchmod
  0.00    0.000000           0         2           sysinfo
  0.00    0.000000           0         1           getsid
  0.00    0.000000           0         2           sigaltstack
  0.00    0.000000           0         2           statfs
  0.00    0.000000           0         1           arch_prctl
  0.00    0.000000           0         1           gettid
  0.00    0.000000           0         1           set_tid_address
  0.00    0.000000           0         1         1 get_mempolicy
  0.00    0.000000           0         2           mknodat
  0.00    0.000000           0        16        12 newfstatat
  0.00    0.000000           0         1           set_robust_list
  0.00    0.000000           0         1           getrandom
  0.00    0.000000           0         1           memfd_create
  0.00    0.000000           0         4           membarrier
  0.00    0.000000           0         1           rseq
  0.00    0.000000           0         1         1 clone3
------ ----------- ----------- --------- --------- ------------------
100.00    0.008853           8       985        84 total
```

## Why so many openat (loader)?

Specifying ICU version stop searching each ICU version.

```shell
$ DOTNET_ICU_VERSION_OVERRIDE=74 strace -f -e trace=openat,newfstatat,access -s 200 ./bin/hello_csharp 2>&1
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
newfstatat(AT_FDCWD, "/lib/x86_64-linux-gnu/glibc-hwcaps/x86-64-v4/", 0x7fffa888a720, 0) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/glibc-hwcaps/x86-64-v3/liblttng-ust-tracepoint.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "/lib/x86_64-linux-gnu/glibc-hwcaps/x86-64-v3/", 0x7fffa888a720, 0) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/glibc-hwcaps/x86-64-v2/liblttng-ust-tracepoint.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "/lib/x86_64-linux-gnu/glibc-hwcaps/x86-64-v2/", 0x7fffa888a720, 0) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/liblttng-ust-tracepoint.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "/lib/x86_64-linux-gnu/", {st_mode=S_IFDIR|0755, st_size=16384, ...}, 0) = 0
openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/glibc-hwcaps/x86-64-v4/liblttng-ust-tracepoint.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/glibc-hwcaps/x86-64-v4/", 0x7fffa888a720, 0) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/glibc-hwcaps/x86-64-v3/liblttng-ust-tracepoint.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/glibc-hwcaps/x86-64-v3/", 0x7fffa888a720, 0) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/glibc-hwcaps/x86-64-v2/liblttng-ust-tracepoint.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/glibc-hwcaps/x86-64-v2/", 0x7fffa888a720, 0) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/liblttng-ust-tracepoint.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/", {st_mode=S_IFDIR|0755, st_size=16384, ...}, 0) = 0
openat(AT_FDCWD, "/lib/glibc-hwcaps/x86-64-v4/liblttng-ust-tracepoint.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "/lib/glibc-hwcaps/x86-64-v4/", 0x7fffa888a720, 0) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/lib/glibc-hwcaps/x86-64-v3/liblttng-ust-tracepoint.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "/lib/glibc-hwcaps/x86-64-v3/", 0x7fffa888a720, 0) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/lib/glibc-hwcaps/x86-64-v2/liblttng-ust-tracepoint.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "/lib/glibc-hwcaps/x86-64-v2/", 0x7fffa888a720, 0) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/lib/liblttng-ust-tracepoint.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "/lib/", {st_mode=S_IFDIR|0755, st_size=4096, ...}, 0) = 0
openat(AT_FDCWD, "/usr/lib/glibc-hwcaps/x86-64-v4/liblttng-ust-tracepoint.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "/usr/lib/glibc-hwcaps/x86-64-v4/", 0x7fffa888a720, 0) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/lib/glibc-hwcaps/x86-64-v3/liblttng-ust-tracepoint.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "/usr/lib/glibc-hwcaps/x86-64-v3/", 0x7fffa888a720, 0) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/lib/glibc-hwcaps/x86-64-v2/liblttng-ust-tracepoint.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "/usr/lib/glibc-hwcaps/x86-64-v2/", 0x7fffa888a720, 0) = -1 ENOENT (No such file or directory)
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
strace: Process 92 attached
[pid    91] openat(AT_FDCWD, "/sys/fs/cgroup//cpu.max", O_RDONLY) = 8
[pid    91] openat(AT_FDCWD, "/dev/urandom", O_RDONLY|O_CLOEXEC) = 9
[pid    91] openat(AT_FDCWD, "/proc/91/stat", O_RDONLY) = 10
strace: Process 93 attached
[pid    91] openat(AT_FDCWD, "/sys/devices/system/cpu/online", O_RDONLY|O_CLOEXEC) = 11
[pid    91] openat(AT_FDCWD, "/proc/self/mountinfo", O_RDONLY) = 11
[pid    91] openat(AT_FDCWD, "/proc/self/cgroup", O_RDONLY) = 11
[pid    91] openat(AT_FDCWD, "/proc/91/stat", O_RDONLY) = 11
[pid    91] openat(AT_FDCWD, "/proc/91/stat", O_RDONLY) = 11
strace: Process 94 attached
[pid    94] openat(AT_FDCWD, "/tmp/clr-debug-pipe-91-2255926-in", O_RDONLYstrace: Process 95 attached
 <unfinished ...>
[pid    91] openat(AT_FDCWD, "/proc/91/stat", O_RDONLY) = 14
[pid    91] openat(AT_FDCWD, "/dev/shm/sem.clrst0000005b0000000000226c36", O_RDWR|O_NOFOLLOW|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid    91] openat(AT_FDCWD, "/sys/fs/cgroup//memory.max", O_RDONLY) = 12
[pid    91] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index0/size", O_RDONLY) = 12
[pid    91] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index0/level", O_RDONLY) = 12
[pid    91] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index1/size", O_RDONLY) = 12
[pid    91] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index1/level", O_RDONLY) = 12
[pid    91] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index2/size", O_RDONLY) = 12
[pid    91] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index2/level", O_RDONLY) = 12
[pid    91] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index3/size", O_RDONLY) = 12
[pid    91] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index3/level", O_RDONLY) = 12
[pid    91] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index4/size", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid    91] openat(AT_FDCWD, "/proc/meminfo", O_RDONLY) = 12
[pid    91] openat(AT_FDCWD, "/proc/self/maps", O_RDONLY|O_CLOEXEC) = 12
[pid    91] openat(AT_FDCWD, "/proc/self/maps", O_RDONLY|O_CLOEXEC) = 12
strace: Process 96 attached
[pid    91] openat(AT_FDCWD, "/proc/self/task/96/comm", O_RDWR) = 14
[pid    91] openat(AT_FDCWD, "/workspace/bin/hello_csharp", O_RDONLY) = 12
strace: Process 97 attached
[pid    91] openat(AT_FDCWD, "/proc/self/task/97/comm", O_RDWR) = 16
[pid    91] access("", F_OK)            = -1 ENOENT (No such file or directory)
[pid    91] access("opt/corebreadcrumbs", F_OK) = -1 ENOENT (No such file or directory)
[pid    91] openat(AT_FDCWD, "/workspace/bin/hello_csharp", O_RDONLY) = 14
[pid    91] openat(AT_FDCWD, "/workspace/bin/hello_csharp", O_RDONLY) = 16
[pid    91] openat(AT_FDCWD, "/workspace/bin/hello_csharp", O_RDONLY) = 18
[pid    91] openat(AT_FDCWD, "/workspace/bin/hello_csharp", O_RDONLY) = 20
[pid    91] openat(AT_FDCWD, "/workspace/bin/hello_csharp", O_RDONLY) = 22
[pid    91] openat(AT_FDCWD, "/workspace/bin/hello_csharp", O_RDONLY) = 25
strace: Process 98 attached
[pid    91] openat(AT_FDCWD, "/root/.terminfo/x/xterm", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid    91] openat(AT_FDCWD, "/root/.terminfo/78/xterm", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid    91] openat(AT_FDCWD, "/etc/terminfo/x/xterm", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid    91] openat(AT_FDCWD, "/etc/terminfo/78/xterm", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid    91] openat(AT_FDCWD, "/lib/terminfo/x/xterm", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid    91] openat(AT_FDCWD, "/lib/terminfo/78/xterm", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid    91] openat(AT_FDCWD, "/usr/share/terminfo/x/xterm", O_RDONLY|O_CLOEXEC) = 29
[pid    91] openat(AT_FDCWD, "/workspace/bin/hello_csharp", O_RDONLY) = 30
[pid    91] openat(AT_FDCWD, "/workspace/bin/hello_csharp", O_RDONLY) = 32
[pid    91] openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 29
[pid    91] openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libicuuc.so.74", O_RDONLY|O_CLOEXEC) = 29
[pid    91] openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libicudata.so.74", O_RDONLY|O_CLOEXEC) = 29
[pid    91] openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 29
[pid    91] openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libicui18n.so.74", O_RDONLY|O_CLOEXEC) = 29
Hello, World
[pid    94] <... openat resumed>)       = ?
[pid    97] +++ exited with 0 +++
[pid    96] +++ exited with 0 +++
[pid    95] +++ exited with 0 +++
[pid    94] +++ exited with 0 +++
[pid    93] +++ exited with 0 +++
[pid    92] +++ exited with 0 +++
[pid    98] +++ exited with 0 +++
+++ exited with 0 +++
```

## ldd

How many dependencies?

```shell
$ DOTNET_ICU_VERSION_OVERRIDE=74 ldd ./bin/hello_csharp
        linux-vdso.so.1 (0x00007ffcefb7e000)
        libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x000071e5f28d6000)
        librt.so.1 => /lib/x86_64-linux-gnu/librt.so.1 (0x000071e5f28d1000)
        libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x000071e5f28a3000)
        libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x000071e5f289e000)
        libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x000071e5f27b5000)
        libstdc++.so.6 => /lib/x86_64-linux-gnu/libstdc++.so.6 (0x000071e5f2535000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x000071e5f2323000)
        /lib64/ld-linux-x86-64.so.2 (0x000071e5f34a0000)
```
