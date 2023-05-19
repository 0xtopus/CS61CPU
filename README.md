# CS61CPU

## 简介

CS61C的第三个Project，主要围绕用logisim设计一个支持处理RV32架构指令的CPU的datapath和control logic部分，以及实现一个简单的二级流水线功能。

## 使用方法

1. 请确保您安装了Git命令行工具：<a href="https://git-scm.com/download/win">Download git for windows</a>。
2. 在Git命令行工具里运行下列命令，Clone此仓库到本地：

```bash
git clone git@github.com:0xtopus/CS61CPU.git
```

3. 下载logisim和Venus：将此仓库clone到本地后，使用Git命令行工具打开此仓库，运行：

```bash
bash test.sh download_tools
```

4. 请确保您的电脑上有<u>**Java 16或更高版本的Java环境**</u>和**<u>Python 3.6或更高版本的Python环境</u>**，如果您需要帮助来安装它们，可以参考<a href="https://cs61c.org/sp23/labs/lab00/#windows">这里</a>。

5. 在确保您安装了上述软件后，在Git的命令行窗口切换到仓库目录里，使用下列命令运行logisim：

```bash
java -jar tools/logisim-evolution.jar
```

6. 在logisim里，点击菜单栏里的`File`-->`Open`即可到对对应的目录下打开文件。所有相关的电路设计文件都在`cpu`目录下。运行测试后会自动生成测试电路以供调试。所有测试自动生成的电路在`test`目录下的对应文件夹中，以`.circ`为后缀名。更多logisim用法请参考<a href="https://cs61c.org/sp23/labs/lab05/#exercise-1-introduction">这里</a>。

7. 要运行测试，在Git命令行窗口里运行下列命令查看所有的测试指令：

```bash
bash test.sh
```

或者到<a href="https://cs61c.org/sp23/projects/proj3/">Project3的说明页</a>里找到各个部分的测试命令。

注意，由于最终的CPU里实现了2级流水线，所以在运行测试时需要在末尾加上`-p`，比如：

```bash
# 测试part_a：
bash test.sh part_a -p

# 测试I-Type指令：
bash test.sh test_integration_immediates -p

# 测试一些基本程序
bash test.sh test_integration_programs -p
```

运行测试后会生成对应的电路，在`test`目录下的对应文件夹中，以`.circ`为后缀名。您可以用logisim打开它们，你可以在菜单栏里的Simulate里控制CLK信号对其进行调试，更多请参考<a href="https://cs61c.org/sp23/labs/lab05/#exercise-3-storing-state">lab05的Exercise3的相关部分</a>。

在`test`目录下的对应文件夹中还有叫做`in`的文件夹，里面的文件是对应的测试运行时的RISC-V汇编代码。

你可以在`integration-custom`文件夹里的`in`里面创建自己的RISC-V测试代码文件。
