# Lab 1: Preliminary - RISCV Cross Compiler

## Lab 简介

学习一种指令集，最直观的方法就是运行工作在该指令集上的程序。本实验从这个目标入手，辅以 Docker 使用方法入门，旨在让大家熟悉相关的开发环境。

在 amd64/x86 架构的操作系统中编译运行 RISC-V 架构的 c 程序，需要使用 RISC-V 交叉编译器，并使用模拟器模拟运行。

本轮实验主要由以下任务组成

- 运行交叉编译器编译程序，使用模拟器（Emulator）执行代码。
- 使用交叉编译器的 objdump 导出代码，指明程序主入口和工作原理。
- 一些相关的扩展研究。
- 根据单周期 CPU 实现指令集的需求，自行设计测试指令。

本实验的实验环境已经由 Docker 打包，直接下载镜像即可运行。

## 前期准备

### 硬件需求

本实验对硬件需求较低，一般的笔记本电脑都可运行（在i7-6650U上测试无问题），但请至少准备 >17GB 的硬盘空间。如果有同学遇上硬件问题，可以申请使用学校的服务器。

### 依赖安装

实验需要安装 Docker 和 Docker Compose 以及 git。

#### Docker

Docker 的安装文档如下

- Windows https://docs.docker.com/docker-for-windows/install/
- macOS https://docs.docker.com/docker-for-mac/install/
- Linux
  - Debian https://docs.docker.com/engine/install/debian/
  - Ubuntu https://docs.docker.com/engine/install/ubuntu/
  - CentOS https://docs.docker.com/engine/install/centos/
  - Fedora https://docs.docker.com/engine/install/fedora/

建议在 Windows 中启用 wsl2（Windows Subsystem for Linux），相关资料可以在网上搜索到。如安装过程出现问题，请随时联系。

如果 Docker CE 下载过慢，可以使用 ustc 国内镜像加速 http://mirrors.ustc.edu.cn/help/docker-ce.html 。

实验用的 git 仓库内有适用于 Debian 的 Docker 的安装脚本。

#### Docker Compose

Windows 和 macOS 的 Docker Desktop 都自带了 Docker Compose，使用 Linux 的同学请参考文档 https://docs.docker.com/compose/install/ 安装。

#### Git

https://git-scm.com/

#### 额外 Docker 设置

为了能够在校内服务器下载 Docker 镜像，请在 Docker 设置中添加信任不安全（http）的仓库

```
{
  "insecure-registries": [
    "10.176.122.240"
  ]
}
```

## 实验步骤

### 指南

clone 仓库

```bash
git clone https://github.com/CA-2022Spring-Lab/Lab1
# or git clone https://gitee.com/CA-2022Spring-Lab/Lab1
cd RISCV-cross-compiler
```

> 该实验的 Docker Image 为根据 RV64i 指令集架构编译的 riscv-gnu-toolchain 交叉编译工具，同时包含 RISCV64 的 qemu 虚拟机环境。

> 也可以直接使用目录下的 Dockerfile

进入仓库，拉取镜像

校园网或校内 VPN 拉取镜像命令

```bash
docker pull 10.176.122.240/lab1/riscv-toolchain-with-qemu:newlib64
docker tag 10.176.122.240/lab1/riscv-toolchain-with-qemu:newlib64 riscv-toolchain
```

公网环境拉取镜像命令

```bash
docker pull hoshinotouko/riscv-toolchain-with-qemu:newlib64
docker tag hoshinotouko/riscv-toolchain-with-qemu:newlib64 riscv-toolchain
```

pull 完成后，运行 `docker-compose up -d` 启动实验环境，然后运行 `docker exec -it riscv-toolchain bash` 进入实验容器。

实验结束后，执行 `exit` 退出容器，并执行 `docker-compose down` 关闭容器。

### 实验目标

直接在仓库中的 `./src/` 文件夹下编辑代码，对应位置已经映射到容器中的 `/src` 文件夹。请自行查阅如何通过交叉编译器编译 RISC-V 代码，并在 qemu 虚拟机内执行对应二进制文件。

参考指令为 `riscv64-unknown-elf-gcc` ， `riscv64-unknown-elf-objdump`，和 `qumu-riscv64` 。

src 文件夹下有 `helloworld.c` 和 `check_prime.c` 两个 c 文件，请使用上述工具编译并导出对应的 RISC-V 汇编代码，并完成以下目标。

1. 对于 `helloworld.c` ，指出 printf 的函数调用，并指出对应返回地址。
2. 对于 `check_prime.c` ，在编译器 O0 优化下，分别指出两个循环体和两个 if 判断的位置。
3. 对于 `check_prime.c` ，分别使用 O0 优化和 O3 优化编译并导出，指出两种优化的区别，并说明对程序编译和执行的利弊。
4. 参考 `check_prime.c` ，编写一个输出1-1000内所有质数的程序，并使用 `qumu-riscv64` 执行。
5. 根据七条指令的单周期 CPU 设计需求，自行设计用于测试后续单周期 CPU 的指令（包含以下指令，要求有循环，不少于30条）。
   - add
   - addi
   - jal
   - jalr
   - sw
   - lw
   - beq

## 评分标准 (10 + 5) / 10

- Hello World (2/10)
- Check Prime (5/10)
- 单周期测试指令 (3/10)
- （附加题）参考 Docker 构建的代码和 riscv-toolchain 文档，分别构建 RV32i（32bit） 和 RV64i 的交叉编译环境，指出两种环境的区别，并用程序构造一种在 RV64i 独有的指令。(5/10)