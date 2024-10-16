---
title: "\U0001F4DF  watchEffect收集到的依赖"
tags:
  - watchEffect
  - vue3
categories:
  - 解决方案
mathjax: true
description: >-
  函数在运行期间，出现了读取响应式数据被拦截的情况，我们就称之为两者之间产生了依赖，这个依赖（也就是一个对应关系）是会被收集的，方便响应式数据发生变化时重新执行对应的函数。
abbrlink: '64172476'
date: 2024-10-03 13:43:41
---

{% note purple no-icon %}

**前言 📝**

前置知识是要熟悉掌握数据响应式。如果不是很了解可以先去看小编的另外几篇文章。

传送门 🚥🚥🚥： {% post_link 建立一个响应式系统  🥬 建立一个响应式系统%} 

{% endnote %}
## 1. 依赖

谁和谁之间有依赖关系？

> **响应式数据**和**函数**之间有依赖关系。**当函数在运行期间用到了响应式数据，那么我们可以称之为两者之间有依赖**。

但还有一点需要明确，那就是什么是用到？

> **所谓用到，是指函数在运行期间出现了读取成员被拦截的情况，这样才算是用到**。

>完整表述：**函数在运行期间，出现了读取响应式数据被拦截的情况，我们就称之为两者之间产生了依赖，这个依赖（也就是一个对应关系）是会被收集的，方便响应式数据发生变化时重新执行对应的函数**。


通过下面的伪代码，简单的看一下：

```js
var a;
function foo() {
  console.log(a);
}
// 没有依赖关系，a 不是响应式数据
```

```js
var a = ref(1);
function foo() {
  console.log(a);
}
// 没有依赖关系，虽然用到了响应式数据，但是没有出现读取拦截的情况
```

```js
var a = ref({ b: 1 });
const k = a.value;
const n = k.b;
function foo() {
  a;
  a.value;
  k.b;
  n;
}
// 有依赖关系
// foo 依赖 a 的 value 属性
// foo 依赖 k 的 b 属性
```

> 总而言之： **只需要判断在函数的运行期间，是否存在读取操作行为的拦截，只要存在这种类型的拦截，那么该函数就和该响应式数据存在依赖关系**。
>
>不过，有一种情况需要注意，那就是**异步**。**如果在函数的运行期间存在异步代码，那么之后的代码统统不看了**。

```js
var a = ref({ b: 1 });
const k = a.value;
const n = k.b;
async function foo() {
  a;
  a.value; // 产生依赖，依赖 value 属性
  await 1;
  k.b; // 没有依赖，因为它是异步后面的代码
  n;
}
```


## 2. 函数

**函数必须是被监控的函数**。

- effect
- watchEffect
- watch
- 组件渲染函数

>因此总结一下：**只有被监控的函数，在它的同步代码运行期间，读取操作被拦截的响应式数据，才会建立依赖关系，建立了依赖关系之后，响应式数据发生变化，对应的函数才会重新执行**。


```js
import { ref, watchEffect } from "vue";
const state = ref({ a: 1 });
const k = state.value;
const n = k.a;
watchEffect(() => {
  // 首先判断依赖关系
  console.log("运行");
  state; // 没有依赖关系产生
  state.value; // 会产生依赖关系，依赖 value 属性
  state.value.a; // 会产生依赖关系，依赖 value 和 a 属性
  n; // 没有依赖关系
});
setTimeout(() => {
  state.value = { a: 3 }; // 要重新运行
}, 500);
```

```js
import { ref, watchEffect } from "vue";
const state = ref({ a: 1 });
const k = state.value;
const n = k.a;
watchEffect(() => {
  console.log("运行");
  state;
  state.value; // value
  state.value.a; // value a
  n;
});
setTimeout(() => {
  //   state.value; // 不会重新运行
  state.value.a = 1; // 不会重新运行
}, 500);
```

```js
import { ref, watchEffect } from "vue";
const state = ref({ a: 1 });
const k = state.value;
const n = k.a;
watchEffect(() => {
  console.log("运行");
  state;
  state.value; // value
  state.value.a; // value、a
  n;
});
setTimeout(() => {
  k.a = 2; // 这里相当于是操作了 proxy 对象的成员 a
  // 要重新运行
  // 如果将上面的 state.value.a; 这句话注释掉，就不会重新运行
}, 500);
```

```js
import { ref, watchEffect } from "vue";
let state = ref({ a: 1 });
const k = state.value;
const n = k.a;
watchEffect(() => {
  console.log("运行");
  state;
  state.value.a; // value、a
  n;
});
setTimeout(() => {
  state.value.a = 2; // 要重新运行
}, 500);
setTimeout(() => {
  //   k.a = 3; // 要重新运行
  k.a = 2; // 因为值没有改变，所以不会重新运行
}, 1000);
```

```js
import { ref, watchEffect } from "vue";
const state = ref({ a: 1 });
const k = state.value;
const n = k.a;
watchEffect(() => {
  console.log("运行");
  state.value.a = 2; // 注意这里的依赖仅仅只有 value 属性
});
setTimeout(() => {
  //   state.value.a = 100; // 不会重新运行的
  state.value = {}; // 要重新运行
}, 500);
```

```js
import { ref, watchEffect } from "vue";
let state = ref({ a: 1 });
const k = state.value;
const n = k.a;
watchEffect(() => {
  console.log("运行");
  state.value.a; // value、a
});
setTimeout(() => {
  state.value = { a: 1 }; // 要重新执行
}, 500);
setTimeout(() => {
  state.value.a = 2; // 要重新执行
}, 1000);
```

```js
import { ref, watchEffect } from "vue";
let state = ref({ a: 1 });
const k = state.value;
const n = k.a;
watchEffect(() => {
  console.log("运行");
  state.value.a; // value、a
  k.a; // 返回的 proxy 对象的 a 成员
});
setTimeout(() => {
  state.value = { a: 1 }; // 要重新运行
}, 500);
setTimeout(() => {
  k.a = 3; // 会重新执行
}, 1000);
setTimeout(() => {
  state.value.a = 4; // 会重新执行
}, 1500);
```

什么时候会产生依赖收集？

**只有被监控的函数，在它的同步代码运行期间，读取操作被拦截的响应式数据，才会建立依赖关系，建立了依赖关系之后，响应式数据发生变化，对应的函数才会重新执行**。

