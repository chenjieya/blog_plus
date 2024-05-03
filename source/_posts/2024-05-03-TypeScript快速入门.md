---
title: TypeScript快速入门
tags:
  - TypeScript
categories:
  - 前端基础
mathjax: true
sticky: 1
swiper_index: 1
comment: true
abbrlink: a9b8502c
date: 2024-05-03 14:44:10
description: TypeScript 是一种由微软开发的自由和开源的编程语言。它是 JavaScript 的一个超集，而且本质上向这个语言添加了可选的静态类型和基于类的面向对象编程。
---

{% note purple no-icon %}
**前言 📝**
本文主要目的是帮助小白快速的上手`TypeScript`项目，并不会深入的去讲解过多的语法。能够满足平时的基本开发需求。
{% endnote %}

## 1. 导言

### 1.1 为什么要使用TypeScript

平时在使用js的时候是运行时错误，只有在运行时候js才知道自己的类型是什么。但是有了`TypeScript`，他会在我们编译的时候就会提示出错误。还有就是可以帮助我们统一代码规范、风格和质量。

## 2. TS演练场

[playground演练场传送门](https://www.typescriptlang.org/play/?#code/DYUwLgBAbgjBC8ECuA7AJiAZgSxSNA3AFBA)

不需要我们安装任何环境，可以直接在演练场中测试代码。并直观的看到编译后的代码以及对应的声明文件。

![image.png](https://picgo-1300696809.cos.ap-beijing.myqcloud.com/202405032344594.png)

## 3. 快速入门

### 3.1 安装与运行

1. 建议全局安装`typescript`
```shell
npm i -g typescript
```

2. 查看安装是否成功
```shell
tsc --version
```

3. 编译ts文件
```shell
# tsc 文件路径
tsc ./src/index.ts
```

到此为止，我们已经可以进行文件的编译了，但是会不会有点麻烦呢。小编现在是在node环境中进行编写代码的，我发现当我写完ts代码的时候，进行tsc命令编译，将代码生成到对应的目录，我在运行最后的js文件。好麻烦啊，运行一个代码就要经历这么多的步骤。不要急，这里推荐一个`npm`包。

4. 建议全局安装`ts-node`
```shell
npm i -g ts-node
```

5. `ts-node`编译并运行文件
ts-node会帮助我们在内存中编译并运行文件，所以在执行`ts-node`命令的时候，并不会替我们生成编译后的`js`文件。
```shell
# ts-node 路径
ts-node ./src/index.ts
```

6. `nodemon`
Nodemon 是一种工具，当检测到目录中的文件更改时，它会自动重新启动 Node 应用程序，从而帮助开发基于Node.js的应用程序。
```shell
npm i nodemon -D
# 使用nodemon来监视当前目录（.）下的文件变化，并在检测到变化时执行 ts-node 命令运行 ./src/index.ts文件
nodemon --exec ts-node ./src/index.ts
```



### 3.2 配置文件

1. `include`指定需要编译的文件
指定需要编译的ts的文件或者目录，默认是匹配我们根目录下面的`**/*`, `**/`代表的是匹配递归到任意子目录，`*`代表的是匹配零个或多个字符（不包括目录分隔符）。我们一般会写成下面这个样子：
```json
{
// 匹配src目录下所有文件夹内的ts文件，包括所有的子目录
 "include": ["src/**/*.ts"]
}
```

2. `outDir`编译文件的输出目录
将ts文件变成js文件之后，js文件的存储位置。

```json
{
	"compilerOptions": {
		"outDit": "./dist"
	}
}
```

3. `exclude`排除编译文件
和`include`相对，该配置项是要指定需要排除编译的文件，默认值有`node_modules、bower_components、jspm_packages、outDir配置的对应目录`

4. `target`指定编译生成的版本；`lib`类型库
`target`是指定生成js的版本，更改target也会更改lib的默认值。而`lib`是Ts需要引用的库，即声明文件。

```json
{
	// ts需要编译的文件
	"include": ["src/**/*.ts"],
	"compilerOptions": {
	// 编译的版本
	"target": "ES2017",
	// 找到对应的类型库
	"lib": ["ES2017", "DOM", "DOM.Iterable"],
	// 编译后的文件输出目录
	"outDir": "./dist"
	}
}
```



{% note warning modern %}
如果`tsconfig.json`配置文件存在，则在执行`tsc`命令的时候，不需要在后面添加文件路径了。
{% endnote %}


{% note warning modern %}
1. 如果进行类型推导，直接给变量赋值`null`或`undefined`,默认类型是**any**。
2. 因为`const`声明的变量不能更改，所以默认的类型就是常量字面量类型。
{% endnote %}

