### 实验环境安装

在wsl/虚拟机中运行docker

```sh
docker pull calvinhaynes412/mit6.s081:v1.3.1

docker run -d calvinhaynes412/mit6.s081:v1.3.1 \
-p 9022:22 \
-p 9848:8848 \
-v /mydata/mit6.s081:/mit6.s081 \
--name mit6_s081_container 

```

映射卷是因为可以内外传输文件，不用其他传输方法

网页端密码：mit6s081

添加容器内/mit6.s081目录的权限，然后克隆仓库

git clone https://github.com/z20s11q/MIT6.S081-2020-labs.git

vscode左下角--附加到正在运行的容器--选择克隆的仓库地址

改变vscode快捷键ctrl + p为ctrl + alt + p，因为在qemu内，ctrl+p可以列出当前运行的进程

### 编写文件并测试

在user目录编写.c文件，在项目根目录makefile文件中，添加$U/_filename，filename是编写的.c文件的文件名，不带后缀。

然后make qemu后自动进入qemu中。

测试命令：./grade-lab-util filename，filename是编写的.c文件的文件名

测试所有并打分./grade-lab-util



