---
title: "\U0001F96C 深入了解TypeScript类型"
tags:
  - TypeScript
categories:
  - 前端基础
mathjax: true
abbrlink: 93c701ab
date: 2024-05-06 20:53:42
description:
---
{% note purple no-icon %}

**前言 📝**
1. {% post_link 深入了解TypeScript类型  🥬 深入了解TypeScript类型%} ⇦ 当前位置 🪂

{% endnote %}

## 1. any与unknown

### 1.1 any

在TS中，编译时一切都要有类型，如果你和TS类型检查器无法确定类型是什么，默认为`any`。这是兜底的类型，是TS中所有类型的教父。

```javascript
let a: any = 666;
let b: any = ['danger'];
let c = a + b;
```

正常情况下，第三个语句应该在TS中报错才对（谁会去计算一个数字和一个数组之和呢？）

但是如果显示声明了any标注，就不会报错，其实这里的做法就和原生JS的处理一模一样了。

换句话说，如果要使用any，一定要显示标注，如果TS推导出值的类型为any（例如忘记注解函数的参数，或者引入没有类型的JavaScript模块），将抛出运行时异常。

```javascript
let foo; // any

function func(foo, bar) { } // error 参数"foo","bar"隐式具有“any”类型。
```

> 默认情况下，Typescript是宽容的，在推导出类型为any时其实不会报错，如果在`tsconfig.json`中启用了`noImplcitAny`标志，就会遇到隐式any类型时报错。
>
> `noImplcitAny`隶属于TSC的`strict`标志家族，如果已经在`tsconfig.json`中启用了`strict`，那就不需要专门设置`noImplcitAny`标志了，效果是一样的。

有时候我们可能确实需要一个表示任意类型的变量，特别是从javascript代码移植到typescript的时候。比较明显的比如`console.log()`方法就能接收任意类型的参数。

当然默认情况下，你看到的应该是这样的

```javascript
 log(...data: any[]): void;
```

我们现在能看到类型提示，这是由于VS Code编辑器结合着`lib.dom.d.ts`文件提供的TS支持。

如果已经安装了`@types/node`，可以得到nodejs对于`console.log`函数更加细致的提示：

```javascript
log(message?: any, ...optionalParams: any[]): void;
```

> 关于@types的内容，我们在快速入门中已经说过。
>
> Node.js 的核心模块和某些第三方模块并不是天然支持Typescript的。这就意味着，如果在 TypeScript 项目中使用这些模块时，编译器无法得知这些模块的类型信息，从而无法提供类型检查和自动补全的功能。比如下面的代码会报错：

```typescript
const fs = require('fs'); // error 找不到名称require,需要Nodejs类型定义
```

>
> 我们可以手动安装nodejs的TypeScript 社区[DefinitelyTyped](https://github.com/DefinitelyTyped/DefinitelyTyped) 提供的声明文件库。当使用 TypeScript 开发 Node.js 项目时，`@types/node` 库可以为 Node.js 的核心模块和常用的第三方模块提供类型定义，以便在开发过程中获得类型检查和自动补全的支持。

```javascript
npm i @types/node -D
```

> 这样上面代码`const fs = require('fs');`也找到的对应的类型支持，在TS文件中不会再报错了。

总的来说，你可以在 any 类型变量上任意地进行操作，包括赋值、访问、方法调用等等，此时可以认为类型推导与检查是被完全禁用的：

```javascript
let anyVar: any = null;
anyVar.foo.bar.fn();
anyVar[0][1][2].prop;
```

正如我们一开始就强调的 **【any兜底的类型，是TS中所有类型的教父】**

> **any能兼容所有类型，也能够被所有类型兼容**

这一作用其实也意味着类型世界给你开了一个外挂，无论什么时候，你都可以使用 any 类型跳过类型检查。当然，运行时出了问题就需要你自己负责了。

any 类型的万能性也导致我们经常滥用它，比如类型不兼容了就 any 一下，类型不想写了也 any 一下，不确定可能会是啥类型还是 any 一下。此时的 `TypeScript` 就变成了令人诟病的 `AnyScript`。

### 1.2 unknown

> 少数情况下，如果确实无法预知一个值的类型，不要使用any，更合理的方式是使用 unknown

unknown也表示任何值，**一个 unknown 类型的变量可以再次赋值为任意其它类型，但只能赋值给 any 与 unknown 类型的变量**

```javascript
let a: unknown = 30;
let b = a === 30;

let c: any = 30;
let d:number = c + 10;

let e: unknown = "string";
e = 123;
let f: any = e;
// let f:string = e; // error 不能将类型unknown分配给类型string
//let f = e + 10; //error "e"的类型为"未知"
if(typeof e === "number") {
  let g = e + 10;
}
```

1. TS不会把任何值推导为`unknown`类型，必须显式注解
2. `unknown`类型的值可以比较
3. `unknown`类型的变量可以赋值给`any`或者`unknown`类型的其他变量
4. 但是执行操作时不能假定`unknown`类型的值为某种特定的类型（比如上面的运算，注意和any的区别），必须先向TS证明一个值确实是某个类型，可以使用typeof

简单的说，**any 放弃了所有的类型检查，而 unknown 并没有**。

```javascript
let anyFn:any;
let unknownFn: unknown;

anyFn.foo();
unknownFn.foo(); // error 对象的类型为"unknown"
```

**在类型未知的情况下，更推荐使用 unknown 标注**。这相当于你使用额外的心智负担保证了类型在各处的结构，后续重构为具体类型时也可以获得最初始的类型信息，同时还保证了类型检查的存在。当然，unknown 用起来很麻烦。



## 2. boolean与类型字面量

`number`,`boolean`,`string`,`symbol`,`bigint`这些js本身就支持的基础类型使用起来很简单，ts的书写几乎感觉不到和js的差别，而且支持很多种书写的方式，当然中间还隐藏着一些很重要的细节。拿boolean举例来说：

```javascript
let a = true;
var b = false;
const c = true;
let d: boolean = true;
let e: true = true;
let f: false = false;
//let g: true = false; // error 不能将类型false分配给类型true
```

1. **可以让TS推导出值的类型为boolean（a，b）**
2. **可以明确的告诉TS，值的类型为boolean（d）**
3. **可以明确的告诉TS，值为某个具体的boolean值（e，f和g）**
4. **可以让TS推导出(const)值为某个具体的布尔值（c）**

首先我们常见的写法是1-4（行），要么使用TS自己的类型推导，要么我们自己定义好boolean类型，这是我们开始就介绍的方式。但是，5-7（行）的写法是什么意思？

其实写法也很直观，我们大概也能猜到，**变量e和f不是普通的boolean类型，而是值只为true和false的boolean类型**

> 把类型设为某个值，就限制了e和f在所有布尔值中只能取指定的那个值。这个特性称为类型字面量（type literal）
> **类型字面量：仅仅表示一个值的类型**

由于类型字面已经限定了具体的类型true或者false，因此上面代码第7行的错误就可以理解了：

```javascript
let g: true = false; // error 不能将类型false分配给类型true
```

特别注意一下第三行的代码：`const c = true;`，这里的变量c的类型是类型字面量true。

> 因为const声明的基本类型的值，赋值之后便无法修改，因此TS推导出的是范围最窄的类型


## 3. number与bigint

有了上面boolean类型的说明，其他的基本数据类型基本一致

> bigint是ES11(ES2020)新增的一种基本数据类型，在JS中，可以用 Number 表示的最大整数为 2^53 - 1，可以写为 Number.MAX_SAFE_INTEGER。如果超过了这个界限，那么就可以用 BigInt 来表示，它可以表示任意大的整数。
>
> 在一个整数字面量后面加 n 的方式定义一个 bigint，或者调用函数 BigInt()
>
> **注意这里强调的问题：ES11（ES2020），如果编译的时候没有指定tsconfig的target（指定代码编译成的版本）和lib（TSC假定运行代码的环境）为es2020以上的版本，或者执行tsc的时候，没有指定--target为es2020以上版本，将会编译报错**

```javascript
let a = 123;
let b = Infinity * 0.10;
const c = 567;
let d = a < b;
let e: number = 100;
let f: 26.218 = 26.218;
// let g: 26.218 = 10; // error 不能将类型10分配给类型26.218

let a1 = 1234n;
const b1 = BigInt(1234);
const b2 = 1234n;;
let d1 = a < a1;
// let e1 = 1234.5n; // error bigint字面量必须是整数
// let f1: bigint = 1234; // error 不能将类型number分配给类型bigint
let g1: bigint = 100n; 
let h1: 100n = 100n;
```

1. **可以让TS推导出值的类型为number/bigint（a，b，a1，b1）**
2. **可以明确的告诉TS，值的类型为number/bigint（e，f1）**
3. **可以明确的告诉TS，值为某个具体的number/bigint值（e，f，g，g1，h1）**
4. **可以让TS推导出(const)值为某个具体的number/bigint值（c，b2）**

## 4. string

与boolean和number形式是一样的，而且string字符串形式同样有单引号`''`,双引号`""`和模板字符串\`\`的形式

> 模板字符串还可以有其他的作用，这个在后期再给大家介绍

## 5. symbol

symbol 符号是ES6新增的一种基本数据类型。

> **注意**：如果编译的时候没有指定tsconfig的target和lib为es6（ES2015）以上的版本，或者执行tsc的时候，没有指定--target为es2015以上版本，将会编译报错

symbol经常用于代替对象和映射的字符串键，确保使用正确的键，以防键被意外设置。

```javascript
let a = Symbol('a');
let b: symbol = Symbol('a');

console.log(a === b);  // false

let obj = {
  name: 'Symbol',
  [a]: 'jack',
  [b]: function () {
    console.log('ts')
  }
}
console.log(obj);

for (let key in obj) {
  console.log("---", key);
}
```

>  Symbol('a')使用指定的名称新建了一个符号，这个符号是唯一的，不与其他任何符号相等，即便再使用相同的名称创建一个符号也是如此。
>
>  symbol 属性不参与 `for..in` 循环。`Object.keys()`也会忽略他们

当然 symbol也能进行全局注册：

```typescript
let id1 = Symbol.for('id')

const user = {
  [id1]: 123
}

console.log(user[id1]) // 123
console.log(id1)      // Symbol(id)

let id2 = Symbol.for('id')

console.log(id1 === id2) // true
console.log(user[id2]) // 123
console.log(id2)      // Symbol(id)
```

`Symbol.for()` 方法创建前，会首先搜索 **全局符号注册表** ，看看是否存在一个键值为 `id` 的 **符号值** 。如果存在就会返回已存在的 **符号值** ；否则创建一个新的 **符号值** 

但是，如果使用const声明的symbol将会是`unique symbol`类型

```javascript
const c = Symbol('a'); // typeof c
const d: unique symbol = Symbol('a'); // typeof d
//let e: unique symbol = Symbol('a'); // error unique symbol的变量必须为const

console.log(c === c);
console.log(c === d); // error 此比较没有意义，类型typeof c和typeof d没有重叠
```

`unique symbol`类型与其他字面量类型其实是一样的，比如`1`，`true`，`"hello"`，创建的是表示特定符号的类型


## 6. 类型拓宽

类型拓宽（type widening）是理解TS类型推导机制的关键。

> 一般来说，TS在推导类型的时候会放宽要求，故意推导出一个更宽泛的类型，而不限定为每个具体的类型。

声明变量时如果运行以后修改变量的值（例如使用`let`和`var`声明），变量类型将拓宽，从字面值放大到包含该字面量的基础类型

```javascript
let a = 'x';  // string
let b = 123;  // number
let c = true; //boolean
```

然而，使用`const`声明不可变的变量时，情况不同，会自动的把**类型缩窄**：

```javascript
const a = 'x'  // 'x'
const b = 123  // 123
const c = true // true
```

我们当然可以显示的标注类型防止类型拓宽

```javascript
let a:'x' = 'x';   // 'x'
let b:123 = 123;   // 123
let c:true = true; // true
```

不过使用**`const`声明的对象，并不会缩窄推导的类型**

```typescript
const obj = {
  b: 123  // b是number类型
}
```

因为Javascript对象是可变的，所以在Typescript看来，创建对象之后你可能会更新对象


## 7. null与undefined

在JavaScript中，`null`与`undefined`都表示缺少什么，Typescript也支持这两个值，并且都有各自的类型，类型名称就是null与undefined。

这两个类型比较特殊，在TS中，`undefined`类型只有`undefined`一个值，`null`类型也只有`null`一个值。

我们在写JavaScript的时候，这两个在语义上有细微的差别，`undefined`一般表示尚未定义，而`null`表示缺少值。

`null`与`undefined`在**没有开启`strictNullChecks`检查的情况下**（tsconfig.json中设置了`strict:true`默认开始，如果想关闭，可以设置`strictNullChecks:false`），**会被视为其他类型的子类型**，比如string类型会被认为包含了`null`与`undefined`

> `null`与`undefined`也是单独的类型是带有Javascript思维，在遇到复杂结构的时候经常会思考遗漏的问题。最重要的就是忽略类型兼容性的问题。

```typescript
const temp1:undefined = undefined;
const temp2: null = null;

const temp3: string = null; // 仅在关闭了strictNullChecks时才成立
const temp4: string = undefined; // 仅在关闭了strictNullChecks时才成立

let temp5 = undefined; // any
let temp6:string = null; // 仅在关闭了strictNullChecks时才成立

// 仅在关闭了strictNullChecks时才成立
function getStr(): string { 
  if(Math.random() > 0.5) {
    return null
  }
  return "hello";
}

type User = {
  name: string;
  age: number;
};

function getUser(): User {
  if (Math.random() > 0.5) { 
    return null;
  }
  return {
    name: "John",
    age: 30,
  }
}
```


## 8. void

在JavaScript中，`void`有特殊的用法，比如

```javascript
<a href="javascript:void(0)">点击</a>
```

我们在界面经常这样写来表示阻止a标签的默认行为.

这里的 `void(0)` 等价于 `void 0`，即 `void expression` 的语法，我们可以使用它来执行一个立即执行函数（IIFE）

```javascript
void function(){
  alert(111);
}();
```

在Typescript中，`void`也表示一种类型，用于描述一个内部没有 `return` 语句，或者没有显式 `return` 一个值的函数的返回值，如：

```javascript
function fn1() {}
function fn2() {
  return;
}
function fn3() {
  return undefined;
}

let m1 = fn1();
let m2 = fn2();
let m3 = fn3();
console.log(m1, m2, m3);
```

`fn1` 与 `fn2` 的返回值类型都会被隐式推导为 `void`，只有显式返回了 `undefined` 值的 `fn3` 其返回值类型才被推导为了 `undefined`

> **注：**`fn3`只有在`tsconfig.json`中开启了`strictNullChecks:true`的情况下，其返回值类型才会被推导为`undefined`，如果没有开启`strict`模式，或者关闭了`strictNullChecks`，fn3函数的返回值类型会被默认推导为`any`

虽然 fn3 的返回值类型会被推导为 undefined，但仍然可以使用 void 类型进行标注

```javascript
function fn3():void {
  return undefined;
}
```

 `undefined` 能够被赋值给 `void` 类型的变量，就像在 JavaScript 中一个没有返回值的函数会默认返回一个 `undefined` ，其实主要还是为了兼容性。但是，在`strict`模式下，null 类型会报错，除非关闭`strictNullChecks`

```javascript
function fn3():void {
  return undefined;
}
function fn4():void {
  return null; // error 不能将类型null分配给类型void，关闭strictNullChecks不报错
}

let v1: void = undefined;
let v2: void = null; // error 不能将类型null分配给类型void，关闭strictNullChecks不报错
```

