## syscalls

```shell
$ strace -c ./bin/hello_go
Hello World
% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ------------------
  0.00    0.000000           0         1           read
  0.00    0.000000           0         1           write
  0.00    0.000000           0         1           close
  0.00    0.000000           0        20           mmap
  0.00    0.000000           0       114           rt_sigaction
  0.00    0.000000           0         6           rt_sigprocmask
  0.00    0.000000           0        31           rt_sigreturn
  0.00    0.000000           0         2           madvise
  0.00    0.000000           0         2           clone
  0.00    0.000000           0         1           execve
  0.00    0.000000           0         6           fcntl
  0.00    0.000000           0         2           sigaltstack
  0.00    0.000000           0         1           arch_prctl
  0.00    0.000000           0         1           gettid
  0.00    0.000000           0         4           futex
  0.00    0.000000           0         1           sched_getaffinity
  0.00    0.000000           0         1           openat
  0.00    0.000000           0         1           prlimit64
------ ----------- ----------- --------- --------- ------------------
100.00    0.000000           0       196           total
```

## openat by loader

```shell
$ strace -f -e trace=openat,newfstatat,access -s 200 ./bin/hello_go 2>&1
openat(AT_FDCWD, "/sys/kernel/mm/transparent_hugepage/hpage_pmd_size", O_RDONLY) = 3
strace: Process 239 attached
strace: Process 240 attached
[pid   238] --- SIGURG {si_signo=SIGURG, si_code=SI_TKILL, si_pid=238, si_uid=0} ---
strace: Process 241 attached
strace: Process 242 attached
strace: Process 243 attached
Hello World
[pid   243] +++ exited with 0 +++
[pid   242] +++ exited with 0 +++
[pid   241] +++ exited with 0 +++
[pid   240] +++ exited with 0 +++
[pid   239] +++ exited with 0 +++
+++ exited with 0 +++
```

## write by runtime

```shell
$ strace -e write ./bin/hello_go > /dev/null
--- SIGURG {si_signo=SIGURG, si_code=SI_TKILL, si_pid=5462, si_uid=0} ---
--- SIGURG {si_signo=SIGURG, si_code=SI_TKILL, si_pid=5462, si_uid=0} ---
--- SIGURG {si_signo=SIGURG, si_code=SI_TKILL, si_pid=5462, si_uid=0} ---
write(1, "Hello World\n", 12)           = 12
+++ exited with 0 +++
```

## ldd

How many dependencies?

```shell
$ ldd ./bin/hello_go
        not a dynamic executable
```
