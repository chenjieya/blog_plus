---
title: "@vue:mounted生命周期"
tags:
  - vue
  - vue3
  - 生命周期
categories:
  - 解决方案
  - Vue
mathjax: true
date: 2024-08-27 14:41:07
description: Vue3中使用指令生命周期
---
## 1. 执行顺序

今天突然刷到一个陌生的语法`@vue：mounted`，这个说是vue生命周期中的写法。我去[vue官网](https://cn.vuejs.org/guide/introduction)并没有找到相关的介绍。最后在[vue迁移指南](https://v3-migration.vuejs.org/zh/breaking-changes/vnode-lifecycle-events.html)中找到了简单的介绍，既然是迁移文档中的内容，那说明原本的Vue2也是有相关的语法的。在Vue2中的语法是`@hook:mounted`。**该语法是写在模板中的，他代表的是某个元素或者组件的生命周期**

简单进行一下介绍，生命周期我们基本关心的就是执行的顺序，我们下面用`mounted`生命周期简单看一下：

```vue
<script setup>
// 父组件 parent.vue
import { ref, onMounted } from 'vue'
import Comp from './Comp.vue';

const msg = ref('Hello World!')
onMounted(() => {
  console.log('组件中的mounted', 4)
})
</script>

<template>
  <h1 >{{ msg }}</h1>
  <input v-model="msg" @vue:mounted="() => {console.log('xxxxx', 1)}" />
  <Comp @vue:mounted="() => {console.log('子组件指令生命周期', 3)}" />
</template>
```

```vue
<script setup>
// 子组件 Comp.vue
import { onMounted } from 'vue';
onMounted(() => {
  console.log('子组件中的onmounted', 2)
})
</script>

<template>
  <div>
    <div>子组件</div>
  </div>
</template>
```

效果展示：
![image.png](https://picgo-1300696809.cos.ap-beijing.myqcloud.com/202408271456086.png)


> 执行顺序： 父组件input元素先加载完成 > 子组件加载完成 > 子组件的指令生命周期加载完成 > 父组件加载完成

## 2. 使用场景

执行顺序了解之后，我们在了解一下应用场景，在该项目中，我想在进入页面的时候就默认聚焦到我input框上。

```vue
 <input v-model="msg" @vue:mounted="({el}) => {el.focus()}" />
```

![image.png](https://picgo-1300696809.cos.ap-beijing.myqcloud.com/202408271510913.png)


这样就完成了！