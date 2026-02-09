## syscalls

Specifing ICU version significantly reduce openat while uging ICU.

```shell
$ DOTNET_ICU_VERSION_OVERRIDE=74 strace -c ./bin/hello_csharp_aot
Hello, World
% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ------------------
 22.68    0.000414           9        45           mmap
 13.86    0.000253           7        35         7 openat
 11.45    0.000209           7        27           mprotect
  7.07    0.000129           3        35           read
  5.37    0.000098           3        28           close
  5.37    0.000098           5        17           madvise
  5.26    0.000096           5        18           rt_sigaction
  5.15    0.000094           3        27           fstat
  4.66    0.000085          14         6           rt_sigprocmask
  3.67    0.000067          33         2           clone
  3.34    0.000061          10         6           munmap
  2.74    0.000050          12         4           ioctl
  2.03    0.000037          18         2           write
  1.48    0.000027           9         3           futex
  1.04    0.000019          19         1           pipe2
  0.77    0.000014           4         3           sched_getaffinity
  0.77    0.000014           3         4           prlimit64
  0.66    0.000012           4         3           pread64
  0.60    0.000011           2         4           brk
  0.55    0.000010          10         1           fcntl
  0.49    0.000009           9         1           lseek
  0.49    0.000009           3         3           getpid
  0.49    0.000009           9         1           gettid
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
100.00    0.001825           6       290        10 total
```

## Why so many openat (loader)?

Specifying ICU version stop searching each ICU version.

```shell
$ DOTNET_ICU_VERSION_OVERRIDE=74 strace -f -e trace=openat,newfstatat,access -s 200 ./bin/hello_csharp_aot
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
strace: Process 175 attached
[pid   174] openat(AT_FDCWD, "/sys/fs/cgroup//memory.max", O_RDONLY) = 3
[pid   174] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index0/size", O_RDONLY) = 3
[pid   174] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index0/level", O_RDONLY) = 3
[pid   174] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index1/size", O_RDONLY) = 3
[pid   174] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index1/level", O_RDONLY) = 3
[pid   174] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index2/size", O_RDONLY) = 3
[pid   174] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index2/level", O_RDONLY) = 3
[pid   174] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index3/size", O_RDONLY) = 3
[pid   174] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index3/level", O_RDONLY) = 3
[pid   174] openat(AT_FDCWD, "/sys/devices/system/cpu/cpu0/cache/index4/size", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid   174] openat(AT_FDCWD, "/proc/meminfo", O_RDONLY) = 3
[pid   174] openat(AT_FDCWD, "/proc/self/maps", O_RDONLY|O_CLOEXEC) = 3
strace: Process 176 attached
[pid   174] openat(AT_FDCWD, "/root/.terminfo/x/xterm", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   174] openat(AT_FDCWD, "/root/.terminfo/78/xterm", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   174] openat(AT_FDCWD, "/etc/terminfo/x/xterm", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   174] openat(AT_FDCWD, "/etc/terminfo/78/xterm", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   174] openat(AT_FDCWD, "/lib/terminfo/x/xterm", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   174] openat(AT_FDCWD, "/lib/terminfo/78/xterm", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
[pid   174] openat(AT_FDCWD, "/usr/share/terminfo/x/xterm", O_RDONLY|O_CLOEXEC) = 6
[pid   174] openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 6
[pid   174] openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libicuuc.so.74", O_RDONLY|O_CLOEXEC) = 6
[pid   174] openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libicudata.so.74", O_RDONLY|O_CLOEXEC) = 6
[pid   174] openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libstdc++.so.6", O_RDONLY|O_CLOEXEC) = 6
[pid   174] openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libgcc_s.so.1", O_RDONLY|O_CLOEXEC) = 6
[pid   174] openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 6
[pid   174] openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libicui18n.so.74", O_RDONLY|O_CLOEXEC) = 6
Hello, World
[pid   176] +++ exited with 0 +++
[pid   175] +++ exited with 0 +++
+++ exited with 0 +++
```

## ldd

How many dependencies?

```shell
$ DOTNET_ICU_VERSION_OVERRIDE=74 ldd ./bin/hello_csharp_aot
        linux-vdso.so.1 (0x00007fff45fe1000)
        libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x000075ca57075000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x000075ca56e63000)
        /lib64/ld-linux-x86-64.so.2 (0x000075ca572c3000)
```
