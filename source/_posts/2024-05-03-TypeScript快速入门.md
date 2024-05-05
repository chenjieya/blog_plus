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

> 快速生成配置文件`tsc --init`

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

5. `strict`严格模式，开启严格的类型检查
开启严格类型检查之后，一下的配置会跟随`strict:true`开启
- `alwaysStrict`-在代码中注入`use strict`，ESM模块化默认就是严格模式，commonJs模块化才会生成
- `nolmplictAny`-不允许隐式的`any`
- `nolmplicitThis`-不允许`this`有隐式的`any`类型
- `strictBindCallApply`-严格的`bind\call\apply`检查
- `strictFunctionTypes`-不允许函数参数双向协变
- `strictNullChecks`-不允许把`null、undefined`赋值给其他类型的变量
- `strictPropertyInitalization`-类的实例属性必须初始化
- `useUnkownInCatchVariables`-默认`catch`子句变量为`unknow`，而不是`any`


{% note warning modern %}
如果`tsconfig.json`配置文件存在，则在执行`tsc`命令的时候，不需要在后面添加文件路径了。
{% endnote %}


## 3.3 TS常见类型

### 3.4 any类型

any可以被赋予任何类型的值，直接给变量赋值`null`或`undefined`,默认类型是**any**。

### 3.5 字面量类型

```ts
const v1 = "hello"
```

{% note warning modern %}
1. 如果进行类型推导，直接给变量赋值`null`或`undefined`,默认类型是**any**。
2. 因为`const`声明的变量不能更改，所以默认的类型就是常量字面量类型。
{% endnote %}


### 3.6 联合类型

```ts
// 着三种类型都可以
let v2: string|number|boolean

// 只能是男或者女，字面量类型+联合类型
let v3: "男"｜"女"
```

### 3.7 数组类型

数组类型可以有两种表示方式：`类型[]、Array<类型>`

```ts
const arr1:string[] = ['h', 'e', 'l', 'l', 'o']
const arr2:Array<string> = ['h', 'e', 'l', 'l', 'o']

// 如果不写类型，同时赋值的时候也不写元素，则默认推断出是`any[]`类型
// 如果将配置文件中的`nolmplictAny`配置改为false,他会推断成`never[]`
const arr3 = []

// 数组联合类型
const arr4:(string|number)[] = []
const arr5:Array<string|number> = []
```

### 3.8 元组类型

将数组中的每一项，都规定类型
```ts
const tuple1: [string, number] = ["a", 1]
const position: [number, number] = [39.5436, 117.231]
```


### 3.9 函数相关

#### 3.9.1 函数参数和返回值

如果不需要返回值，则填写`void`

```ts
function add(a: number, b: number): string {
	return a+b+''
}

add(1,2);
```

#### 3.9.2 可选参数

可以在某些参数后面加上`?`，表示参数是非必需传递的。

```ts
function sum(a: number, b: number, c?:number):number {
	return 
}
sum(1,2)
```

 {% note warning modern %}
可选参数必须要在所有必选参数后面
{% endnote %}

#### 3.9.3 默认参数

默认参数本身就是可选参数

```ts
function sum(a: number, b: number, c = 10) {
	return a+b+c
}
sum(1,2)
```

#### 3.9.4 剩余参数

```ts
const fn = (a:number, b: number, ...args: number[]) => {
}
```


#### 3.9.5 泛型

```ts
// 不确定是什么类型，需要传递一个类型过来
function log<T>(a: T): T {
	console.log(a)
	return a
}

log<string>("泛型")


function example<T, K>(a: T, b: K):[T,K] {
	return [a, b]
}

example(1, "1")


function myFilter<T>(arr: T[], callback: (item: T, index?:number) => boolean) {
	const result = [];
	for(let i = 0; i < arr.length; i++) {
		if(callback(item, i)) {
		 result.push(item)
		}
	}
	return result
}

myFilter([1,4,3,5,6], (item) => {
	return item % 2 = 0
})
```

### 3.10 对象字面量类型

对象字面量类型就是字面量类型

```ts
const v4 = {
	name: 'alvis',
	age: 1,
	id: 130
}

=> 类型推导成

const v4: {
	name: string,
	age: number,
	id: number
} = {
	name: 'alvis',
	age: 1,
	id: 130
}
```

### 3.11 自定义类型

#### 3.11.1 类型别名

创建一个类型的新的名字，类型别名可以是任何有效的类型

```ts
// type 名称 = 类型
type Pointer = {
	x: number,
	y: number
} 

type ID = number | string

type Age = number

type User = {
	id: ID,
	name: string,
	age: Age
}

type InfoFn = (id: number, name?: string) => string
```
#### 3.11.2 接口

接口其实是面向对象的概念，所以一般用于定义对象类型

```ts
interface Point {
	x: number,
	y: number
}

interface Person {
	id: ID,
	name: string,
	age: Age
}

interface Book {
	id: number,
	name: string,
	price: number,
	// 函数类型表示方式
	show(id: number): void,
	filter: (id: number) = void,
	info: InfoFn
}
```

### 3.12 交叉类型

交叉类型就是将多个类型合并成一个类型。**类型A & 类型B、 类型A | 类型B**

```ts
type A = {
	id: number,
	name: string
}

type B = {
	age: number
}

type C = A & B

// A和B的任意一个属性都不能少，必须要全部符合A、B两个类型
const objs: C = {
	id: 1,
	name: 'alvis',
	age: 18
}

type D = A | B

// 同时满足类型A和类型B也可以
const obj: D = {
	// 只满足类型A的类型也可以
	id: 1,
	name: 'alvis',
	// 只满足类型B的类型也可以
	age: 18
}
```

### 3.13 类型断言

简单来说，TS会根据上下文进行推测，但是有时候我们可以认为干涉，确定某一个类型。类型断言就是告诉TS编译器，**我知道我在做什么，这里没有类型安全问题，我自己来掌握**，允许我们使用更宽松的方式处理类型问题。

> 语法： `值 as 类型 或者 <类型>值`

```ts
let someValue: any = "this is a string"
let strLeng1 = (someValue as string).length
let strLeng2 = (<string>someValue).length
```

### 3.14非空断言

当你确定某个值不是null或者undefined的时候，可以直接使用非空断言。

> 语法：值!

```ts
let maybeString: string | undefined = "hello"
// 如果不加入非空断言，此时的类型可能是 string | undefined，加上非空断言就确定了此时不是undefined
let defineString = maybeString!
```


### 3.15 可选链操作符（js语法）

```ts
interface Address {
	city?: string
	street?: string
}

interface Student {
	name: string
	address?: Address
}

const student: Student = {
	name: 'alvis',
	address: {
		city: "河北"
	}
}

// address.street可能不存在,如果不存在就直接返回undefined，不再往后走了
let street = student.address?.street
```


## 4. 类型声明

打开`"declaration": true`配置文件，并设置`"declarationDir": "./types"`声明文件的输出目录。然后在`tsc`编译就会生成项目的类型文件。

### 4.1 外部类型声明文件

如果项目中使用了外部的某个第三方库，那么就需要这个库的类型声明文件，这是分了三种情况。

1. 第三方库自带了类型声明文件
2. 社区制作的类型声明文件
3. 没有类型声明文件

主要介绍一下第二种：

去[传送门](https://github.com/DefinitelyTyped/DefinitelyTyped) 下载对应的类型

举个列子
```shell
npm install --save-dev @types/node
```

