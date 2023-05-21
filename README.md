# CS61CPU

## 简介

CS61C的第三个Project，主要围绕用logisim设计一个支持处理RV32架构指令的CPU的datapath和control logic部分，以及实现一个简单的二级流水线功能。
关于整个项目的详情请见：<a href="https://cs61c.org/sp23/projects/proj3/">Project 3: CS61CPU</a>

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

4. 请确保您的电脑上有<u>**Java 16或更高版本的Java环境**</u>和<u>**Python 3.6或更高版本的Python环境**</u>，如果您需要帮助来安装它们，可以参考<a href="https://cs61c.org/sp23/labs/lab00/#windows">这里</a>。

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

## 支持的RISC-V指令
### I-Type Instructions
<table>
<tbody><tr>
<td><b>Instruction</b></td>
<td><b>Type</b></td>
<td><b>Opcode</b></td>
<td><b>Funct3</b></td>
<td><b>Funct7</b></td>
<td><b>Operation</b></td>
</tr>
<tr>
<td><code>addi rd, rs1, imm</code></td>
<td rowspan="4">I</td>
<td rowspan="8"><code>0x13</code></td>
<td><code>0x0</code></td>
<td></td>
<td><code>rd = rs1 + imm</code></td>
</tr>
<tr>
<td><code>andi rd, rs1, imm</code></td>
<td><code>0x7</code></td>
<td></td>
<td><code>rd = rs1 &amp; imm</code></td>
</tr>
<tr>
<td><code>ori rd, rs1, imm</code></td>
<td><code>0x6</code></td>
<td></td>
<td><code>rd = rs1 | imm</code></td>
</tr>
<tr>
<td><code>xori rd, rs1, imm</code></td>
<td><code>0x4</code></td>
<td></td>
<td><code>rd = rs1 ^ imm</code></td>
</tr>
<tr>
<td><code>slli rd, rs1, imm</code></td>
<td rowspan="3">I*</td>
<td><code>0x1</code></td>
<td><code>0x00</code></td>
<td><code>rd = rs1 &lt;&lt; imm</code></td>
</tr>
<tr>
<td><code>srli rd, rs1, imm</code></td>
<td><code>0x5</code></td>
<td><code>0x00</code></td>
<td><code>rd = rs1 &gt;&gt; imm</code> (Zero-extend)</td>
</tr>
<tr>
<td><code>srai rd, rs1, imm</code></td>
<td><code>0x5</code></td>
<td><code>0x20</code></td>
<td><code>rd = rs1 &gt;&gt; imm</code> (Sign-extend)</td>
</tr>
<tr>
<td><code>slti rd, rs1, imm</code></td>
<td>I</td>
<td><code>0x2</code></td>
<td></td>
<td><code>rd = (rs1 &lt; imm) ? 1 : 0</code></td>
</tr>
</tbody></table>

### R-Type Instructions
<table>
<tbody><tr>
<td><b>Instruction</b></td>
<td><b>Type</b></td>
<td><b>Opcode</b></td>
<td><b>Funct3</b></td>
<td><b>Funct7</b></td>
<td><b>Operation</b></td>
</tr>
<tr>
<td><code>add rd, rs1, rs2</code></td>
<td rowspan="12">R</td>
<td rowspan="12"><code>0x33</code></td>
<td><code>0x0</code></td>
<td><code>0x00</code></td>
<td><code>rd = rs1 + rs2</code></td>
</tr>
<tr>
<td><code>sub rd, rs1, rs2</code></td>
<td><code>0x0</code></td>
<td><code>0x20</code></td>
<td><code>rd = rs1 - rs2</code></td>
</tr>
<tr>
<td><code>and rd, rs1, rs2</code></td>
<td><code>0x7</code></td>
<td><code>0x00</code></td>
<td><code>rd = rs1 &amp; rs2</code></td>
</tr>
<tr>
<td><code>or rd, rs1, rs2</code></td>
<td><code>0x6</code></td>
<td><code>0x00</code></td>
<td><code>rd = rs1 | rs2</code></td>
</tr>
<tr>
<td><code>xor rd, rs1, rs2</code></td>
<td><code>0x4</code></td>
<td><code>0x00</code></td>
<td><code>rd = rs1 ^ rs2</code></td>
</tr>
<tr>
<td><code>sll rd, rs1, rs2</code></td>
<td><code>0x1</code></td>
<td><code>0x00</code></td>
<td><code>rd = rs1 &lt;&lt; rs2</code></td>
</tr>
<tr>
<td><code>srl rd, rs1, rs2</code></td>
<td><code>0x5</code></td>
<td><code>0x00</code></td>
<td><code>rd = rs1 &gt;&gt; rs2</code> (Zero-extend)</td>
</tr>
<tr>
<td><code>sra rd, rs1, rs2</code></td>
<td><code>0x5</code></td>
<td><code>0x20</code></td>
<td><code>rd = rs1 &gt;&gt; rs2</code> (Sign-extend)</td>
</tr>
<tr>
<td><code>slt rd, rs1, rs2</code></td>
<td><code>0x2</code></td>
<td><code>0x00</code></td>
<td><code>rd = (rs1 &lt; rs2) ? 1 : 0</code></td>
</tr>
<tr>
<td><code>mul rd, rs1, rs2</code></td>
<td><code>0x0</code></td>
<td><code>0x01</code></td>
<td><code>rd = (rs1 * rs2)[31:0]</code></td>
</tr>
<tr>
<td><code>mulh rd, rs1, rs2</code></td>
<td><code>0x1</code></td>
<td><code>0x01</code></td>
<td><code>rd = (rs1 * rs2)[63:32]</code> (Signed)</td>
</tr>
<tr>
<td><code>mulhu rd, rs1, rs2</code></td>
<td><code>0x3</code></td>
<td><code>0x01</code></td>
<td><code>rd = (rs1 * rs2)[63:32]</code> (Unsigned)</td>
</tr>
</tbody></table>

### B-Type Instructions
<table>
<tbody><tr>
<td><b>Instruction</b></td>
<td><b>Type</b></td>
<td><b>Opcode</b></td>
<td><b>Funct3</b></td>
<td><b>Operation</b></td>
</tr>
<tr>
<td><code>beq rs1, rs2, offset</code></td>
<td rowspan="6">B</td>
<td rowspan="6"><code>0x63</code></td>
<td><code>0x0</code></td>
<td class="c8"><code>
if(rs1 == rs2)
<br>
&nbsp;PC = PC + offset
</code></td>
</tr>
<tr>
<td><code>bge rs1, rs2, offset</code></td>
<td><code>0x5</code></td>
<td class="c8"><code>
if(rs1 &gt;= rs2 (signed))
<br>
&nbsp;PC = PC + offset
</code></td>
</tr>
<tr>
<td><code>bgeu rs1, rs2, offset</code></td>
<td><code>0x7</code></td>
<td class="c8"><code>
if(rs1 &gt;= rs2 (unsigned))
<br>
&nbsp;PC = PC + offset
</code></td>
</tr>
<tr>
<td><code>blt rs1, rs2, offset</code></td>
<td><code>0x4</code></td>
<td class="c8"><code>
if(rs1 &lt; rs2 (signed))
<br>
&nbsp;PC = PC + offset
</code></td>
</tr>
<tr>
<td><code>bltu rs1, rs2, offset</code></td>
<td><code>0x6</code></td>
<td class="c8"><code>
if(rs1 &lt; rs2 (unsigned))
<br>
&nbsp;PC = PC + offset
</code></td>
</tr>
<tr>
<td><code>bne rs1, rs2, offset</code></td>
<td><code>0x1</code></td>
<td class="c8"><code>
if(rs1 != rs2)
<br>
&nbsp;PC = PC + offset
</code></td>
</tr>
</tbody></table>

### Loading and Storing Instructions
<table>
<colgroup>
<col span="1" style="width: 20%;">
<col span="1" style="width: 5%;">
<col span="1" style="width: 5%;">
<col span="1" style="width: 5%;">
<col span="1" style="width: 65%;">
</colgroup>
<tbody><tr>
<td><b>Instruction</b></td>
<td><b>Type</b></td>
<td><b>Opcode</b></td>
<td><b>Funct3</b></td>
<td><b>Operation</b></td>
</tr>
<tr>
<td><code>lb rd, offset(rs1)</code></td>
<td rowspan="3">I</td>
<td rowspan="3"><code>0x03</code></td>
<td><code>0x0</code></td>
<td><code>rd = </code>1 byte of memory at address <code>rs1 + imm</code>, sign-extended</td>
</tr>
<tr>
<td><code>lh rd, offset(rs1)</code></td>
<td><code>0x1</code></td>
<td><code>rd = </code>2 bytes of memory starting at address <code>rs1 + imm</code>, sign-extended</td>
</tr>
<tr>
<td><code>lw rd, offset(rs1)</code></td>
<td><code>0x2</code></td>
<td><code>rd = </code>4 bytes of memory starting at address <code>rs1 + imm</code></td>
</tr>
<tr>
<td><code>sb rs2, offset(rs1)</code></td>
<td rowspan="3">S</td>
<td rowspan="3"><code>0x23</code></td>
<td><code>0x0</code></td>
<td>Stores least-significant byte of <code>rs2</code> at the address <code>rs1 + imm</code> in memory</td>
</tr>
<tr>
<td><code>sh rs2, offset(rs1)</code></td>
<td><code>0x1</code></td>
<td>Stores the 2 least-significant bytes of <code>rs2</code> starting at the address <code>rs1 + imm</code> in memory</td>
</tr>
<tr>
<td><code>sw rs2, offset(rs1)</code></td>
<td><code>0x2</code></td>
<td>Stores <code>rs2</code> starting at the address <code>rs1 + imm</code> in memory</td>
</tr>
</tbody></table>

### J-Type and U-type Instructions and jalr
<table>
<tbody><tr>
<td><b>Instruction</b></td>
<td><b>Type</b></td>
<td><b>Opcode</b></td>
<td><b>Funct3</b></td>
<td><b>Operation</b></td>
</tr>
<tr>
<td><code>jal rd, imm</code></td>
<td>J</td>
<td><code>0x6f</code></td>
<td></td>
<td class="c8"><code>
rd = PC + 4
<br>
&nbsp;PC = PC + offset
</code></td>
</tr>
<tr>
<td><code>jalr rd, rs1, imm</code></td>
<td>I</td>
<td><code>0x67</code></td>
<td><code>0x0</code></td>
<td class="c8"><code>
rd = PC + 4
<br>
&nbsp;PC = rs1 + imm
</code></td>
</tr>
<tr>
<td><code>auipc rd, imm</code></td>
<td rowspan="2">U</td>
<td><code>0x17</code></td>
<td></td>
<td><code>rd = PC + imm</code></td>
</tr>
<tr>
<td><code>lui rd, imm</code></td>
<td><code>0x37</code></td>
<td></td>
<td><code>rd = imm</code></td>
</tr>
</tbody></table>
