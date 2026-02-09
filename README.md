# linux-strace

Write Hello World programs in various languages and analyze syscalls with strace. (see original [HasutoSasaki/linux-system-playground](https://github.com/HasutoSasaki/linux-system-playground))

See docs/ for each language detailed analysis.

- [C](docs/strace_c.md)
- [Go](docs/strace_go.md)
- [Go (linkshared)](docs/strace_go_linkshared.md)
- [Rust](docs/strace_rust.md)
- [.NET JIT](docs/strace_dotnet_jit.md)
    - [.NET JIT specifying ICU version](docs/strace_dotnet_jit_specify_icu.md)
    - [.NET JIT disabling ICU](docs/strace_dotnet_jit_disable_icu.md)
- [.NET AOT](docs/strace_dotnet_aot.md)
    - [.NET AOT specifying ICU version](docs/strace_dotnet_aot_specify_icu.md)
    - [.NET AOT disabling ICU](docs/strace_dotnet_aot_disable_icu.md)

## Setup

Build and run container image.

```shell
docker buildx build -t strace-playground .
docker run -it -v $(pwd):/workspace strace-playground
```

Container has following versions.

```shell
$ gcc --version
gcc (Ubuntu 13.3.0-6ubuntu2~24.04) 13.3.0
Copyright (C) 2023 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

$ rustc --version
rustc 1.93.0 (254b59607 2026-01-19)

$ go version
go version go1.24.1 linux/amd64

$ dotnet --list-sdks
10.0.102 [/root/.dotnet/sdk]
```


## Build

Build and Run

```shell
mkdir -p bin
gcc hello_c/main.c -o ./bin/hello_c
rustc hello_rust/main.rs -o ./bin/hello_rust
cd hello_go && go build -o ../bin/hello_go && cd ..
cd hello_go && go build -linkshared -o ../bin/hello_go_linkshared && cd ..
dotnet publish -c Release -r linux-x64 -o ./bin hello_csharp/hello_csharp.csproj
dotnet publish -c Release -r linux-x64 -o ./bin hello_csharp_aot/hello_csharp_aot.csproj
```

## strace

strace statistics of each "Hello World" binary.

```shell
strace -c ./bin/hello_c
strace -c ./bin/hello_rust
strace -c ./bin/hello_go
strace -c ./bin/hello_csharp
strace -c ./bin/hello_csharp_aot
```

See `openat` calls by loader.

```shell
strace -f -e trace=openat,newfstatat,access -s 200 ./bin/hello_c 2>&1
```

See `write` calls by runtime.

```shell
strace -e write ./bin/hello_c > /dev/null
```

## TIPS

How to find your icu versions. You have `74` for following case.

```shell
$ ldconfig -p | grep -E 'libicu(uc|i18n)\.so' | head -n 50
        libicuuc.so.74 (libc6,x86-64) => /lib/x86_64-linux-gnu/libicuuc.so.74
        libicui18n.so.74 (libc6,x86-64) => /lib/x86_64-linux-gnu/libicui18n.so.74
```

# Reference

https://dev.classmethod.jp/articles/strace-c-go-rust-python-node-js-hello-world/
