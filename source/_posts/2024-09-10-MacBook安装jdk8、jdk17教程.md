---
title: "\U0001F389 MacBook安装jdk8、jdk17教程"
tags:
  - jdk
  - Java
  - macbookpro
categories:
  - 后端基础
mathjax: true
description: MacBook苹果电脑安装配置多个jdk，并快速切换jdk版本
abbrlink: 53d10e69
date: 2024-09-10 13:43:28
---
{% note purple no-icon %}

**前言 📝**

无乱学习哪一门语言，第一步都是要先搭建配置该语言的环境。今天学了一下Java。在安装环境的过程中就顺手记录了一下过程。由于我是用mac学习的，所以本文主要记录在MacBook苹果电脑系统下安装JDK及环境变量配置。

{% endnote %}

## 1. 下载JDK

[https://www.oracle.com/cn/java/technologies/downloads/archive/](https://www.oracle.com/cn/java/technologies/downloads/archive/)

![image.png](https://picgo-1300696809.cos.ap-beijing.myqcloud.com/202409101352136.png)


我这里就用[JAVASE8(8u211 and later)](https://www.oracle.com/cn/java/technologies/javase/javase8u211-later-archive-downloads.html)来举个例子，点击进入下载页面。

![image.png](https://picgo-1300696809.cos.ap-beijing.myqcloud.com/202409101354262.png)


选择自己系统对应的版本链接进行下载，我的是苹果M1芯片，选择的是**macOS ARM64 DMG Installer**  ARM64架构的。

下载完之后直接安装就可以了。


## 2. 配置环境变量

```sh
# 进入 JDK 安装目录
cd /Library/Java/JavaVirtualMachines
 
# 查看文件
ls
➜ jdk-1.8.jdk  jdk-17.jdk
 
# 查看路径
pwd
➜ /Library/Java/JavaVirtualMachines
```

![image.png](https://picgo-1300696809.cos.ap-beijing.myqcloud.com/202409101359805.png)


```sh
# 打开环境变量配置文件
vim ~/.bash_profile
```

### 2.1 只安装一个JDK

```sh
# JDK Config
JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-1.8.jdk/Contents/Home
CLASS_PATH="$JAVA_HOME/lib"
PATH="$PATH:$JAVA_HOME/bin"
```

### 2.2 安装多个版本JDK

```sh
# JDK Config
JAVA_HOME_8=/Library/Java/JavaVirtualMachines/jdk-1.8.jdk/Contents/Home
JAVA_HOME_17=/Library/Java/JavaVirtualMachines/jdk-17.jdk/Contents/Home
 
export JAVA_HOME=$JAVA_HOME_8
alias jdk8="export JAVA_HOME=$JAVA_HOME_8 && echo current JDK has switched to oracle jdk version 1.8. && java -version"
alias jdk17="export JAVA_HOME=$JAVA_HOME_17 && echo current JDK has switched to openjdk version 17. && java -version"
 
CLASS_PATH="$JAVA_HOME/lib"
PATH="$PATH:$JAVA_HOME/bin"
```

> 配置文件中`alias`定义的别名`jdk8`、`jdk17`是用来快速切换jdk版本的。


**配置文件发生了更改，必须要重新加载才会生效。**

```sh
# 注意：source后边必须跟"/etc/profile" 这个路径，否则通过alias别名切换jdk版本可能会失败
source /etc/profile ~/.bash_profile

# 验证：查看 JAVA_HOME 目录
echo $JAVA_HOME

# 查看 JDK 版本信息
java -version
```

![image.png](https://picgo-1300696809.cos.ap-beijing.myqcloud.com/202409101406702.png)

这样我们的JDK就已经安装好了。

### 2.3 快速切换JDK版本

```sh
jdk8
-> current JDK has switched to oracle jdk version 1.8.
-> java version "1.8.0_411"
-> Java(TM) SE Runtime Environment (build 1.8.0_411-b09)
-> Java HotSpot(TM) 64-Bit Server VM (build 25.411-b09, mixed mode)

java -version
-> java version "1.8.0_411"
-> Java(TM) SE Runtime Environment (build 1.8.0_411-b09)
-> Java HotSpot(TM) 64-Bit Server VM (build 25.411-b09, mixed mode)

jdk17
-> current JDK has switched to openjdk version 17.
-> java version "17.0.11" 2024-04-16 LTS
-> Java(TM) SE Runtime Environment (build 17.0.11+7-LTS-207)
-> Java HotSpot(TM) 64-Bit Server VM (build 17.0.11+7-LTS-207, mixed mode, sharing)

java -version
-> java version "17.0.11" 2024-04-16 LTS
-> Java(TM) SE Runtime Environment (build 17.0.11+7-LTS-207)
-> Java HotSpot(TM) 64-Bit Server VM (build 17.0.11+7-LTS-207, mixed mode, sharing)
```


![image.png](https://picgo-1300696809.cos.ap-beijing.myqcloud.com/202409101410653.png)


## 3. 解决 jdk not found无法切换版本

### 3.1 重新加载配置文件

**注意： 在加载配置文件的时候要加上“/etc/profile”否则在使用别名的时候可能就失效**

```sh
source /etc/profile ~/.bash_profile
```


### 3.2 zsh终端

如果安装了zsh终端为了避免重启电脑别名失效，在`~/.zshrc`文件末尾，添加如下命令：

```sh
source ~/.bash_profile
```

### 3.3 终极大招

要是还不行，就重启电脑、检查配置文件、重新加载配置文件。还不行的话就问度娘。要相信世上没有解决不了的问题。





