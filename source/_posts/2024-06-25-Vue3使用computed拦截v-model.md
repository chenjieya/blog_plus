---
title: 🔫 Vue3使用computed拦截v-model
tags:
  - vue3
  - computed
  - v-model
categories:
  - 解决方案
mathjax: true
description: 如何避免写出屎山，优雅的封装组件，在面试官面前大大加分，从这篇文章开始！
comment: true
abbrlink: 765ea8e7
date: 2024-06-25 21:32:34
---

{% note purple no-icon %}
**前言 📝**
如何避免写出屎山，优雅的封装组件，在面试官面前大大加分，从这篇文章开始！
{% endnote %}

## 1. 保持单项数据流

大家都知道vue是单项数据流的，子组件不能直接修改父组件传过来的props，但是在我们封装组件使用v-model时，不小心就会打破单行数据流的规则，例如下面这样：

```vue
<!-- 父组件 -->
<my-component v-model="msg"></my-component>

<script setup>
defineOptions({
  name: "my-component",
});
</script>
```

```vue
<!-- 子组件 -->
<template>
  <div>
    <el-input  v-model="msg"></el-input>
  </div>
</template>

<script setup>
defineOptions({
  name: "son-component",
});

const props = defineProps({
  msg: {
    type: String,
    default: "",
  },
});
</script>
```

在上面的案列中，子组件的v-model直接修改了父组件的msg值。如果这块不理解，不要着急，我们接着往下看，v-model的实现原理。

## 2. v-model实现原理

> 直接在子组件修改props的值，就打破了我们的单项数据流，导致我们很难追踪到数据源的修改。那我们具体应该怎么做呢，先来简单看一下v-model的实现原理：

```vue
<!-- 父组件 -->
<template>
  <my-component v-model="msg"></my-component>
  <!-- 等同于 -->
  <my-component :modelValue="msg" @update:modelValue="msg = $event"></my-component>
</template>
```

v-model就是相当于分解两部，首先将**modelValue**数据传递给子组件，然后在接受子组件抛出来的一个特殊的事件
**update:modelValue**,在事件中将子组件抛出来的已经改变了的值，在重新赋值给父组件的参数。

### 2.1 emit通知父组件修改prop值

所以，我们可以通过emit，子组件的值变化了，不是直接修改props,而是通知父组件去修改该值!

> 子组件值修改，触发父组件的update:modelValue事件，并将新的值传过去，父组件将msg更新为新的值，代码如下：

```vue
<!-- 父组件 -->
<template>
  <my-component v-model="msg"></my-component>
  <!-- 等同于 -->
  <my-component :modelValue="msg" @update:modelValue="msg = $event"></my-component>
</template>
<script setup>
import { ref } from 'vue'
const msg = ref('hello')
</script>
```

```vue
<!-- 子组件 -->
<template>
  <el-input :modelValue="modelValue" @update:modelValue="handleValueChange"></el-input>
</template>
<script setup>
const props = defineProps({
  modelValue: {
    type: String,
    default: '',
  }
});

const emit = defineEmits(['update:modelValue']);

const handleValueChange = (value) => {
    // 子组件值修改，触发父组件的update:modelValue事件，并将新的值传过去，父组件将msg更新为新的值
    emit('update:modelValue', value)
}
</script>
```

> 这也是大多数开发者封装组件修改值的方法，其实还有另一种方案，就是利用计算数据的`get、set`

## 3.  computed 拦截prop

大多数同学使用计算属性，都是用`get`，或许有部分同学甚至不知道计算属性还有`set`，下面我们看下实现方式吧：

```vue
<!-- 父组件 -->
<script setup>
import myComponent from "./components/MyComponent.vue";
import { ref } from "vue";

const msg = ref('hello')
</script>

<template>
  <div>
    <my-component v-model="msg"></my-component>
  </div>
</template>
```

```vue
<!-- 子组件 -->
<template>
  <el-input v-model="msg"></el-input>
</template>
<script setup>
import { computed } from "vue";

const props = defineProps({
  modelValue: {
    type: String,
    default: "",
  },
});

const emit = defineEmits(["update:modelValue"]);

const msg = computed({
  // getter
  get() {
    return props.modelValue
  },
  // setter
  set(newValue) {
    emit('update:modelValue',newValue)
  },
});
</script>
```


## 4.  v-model绑定对象

那么当v-model绑定的是对象呢？

```vue
<!-- 父组件 -->
<script setup>
import myComponent from "./components/MyComponent.vue";
import { ref } from "vue";

const form = ref({
  name:'张三',
  age:18,
  sex:'man'
})
</script>

<template>
  <div>
    <my-component v-model="form"></my-component>
  </div>
</template>
```

```vue
<!-- 子组件 -->
<template>
  <div>
    <el-input v-model="name"></el-input>
    <el-input v-model="age"></el-input>
    <el-input v-model="sex"></el-input>
  </div>
</template>
<script setup>
import { computed } from "vue";

const props = defineProps({
  modelValue: {
    type: Object,
    default: () => {},
  },
});

const emit = defineEmits(["update:modelValue"]);

const name = computed({
  // getter
  get() {
    return props.modelValue.name;
  },
  // setter
  set(newValue) {
    emit("update:modelValue", {
      ...props.modelValue,
      name: newValue,
    });
  },
});

const age = computed({
  get() {
    return props.modelValue.age;
  },
  set(newValue) {
    emit("update:modelValue", {
      ...props.modelValue,
      age: newValue,
    });
  },
});

const sex = computed({
  get() {
    return props.modelValue.sex;
  },
  set(newValue) {
    emit("update:modelValue", {
      ...props.modelValue,
      sex: newValue,
    });
  },
});
</script>
```

这样虽然可以实现需求，但是有没有发现一个事情。就是每多一个属性，我就要手动的添加一个计算属性。太过于麻烦，所以我们要将拦截整合起来。


```vue
<!-- 父组件 -->
<script setup>
import myComponent from "./components/MyComponent.vue";
import { ref } from "vue";

const form = ref({
  name:'张三',
  age:18,
  sex:'man'
})
</script>

<template>
  <div>
    <my-component v-model="form"></my-component>
  </div>
</template>
```

```vue
<!-- 子组件 -->
<template>
  <div>
    <el-input v-model="form.name"></el-input>
    <el-input v-model="form.age"></el-input>
    <el-input v-model="form.sex"></el-input>
  </div>
</template>
<script setup>
import { computed } from "vue";

const props = defineProps({
  modelValue: {
    type: Object,
    default: () => {},
  },
});

const emit = defineEmits(["update:modelValue"]);

const form = computed({
  get() {
    return props.modelValue;
  },
  set(newValue) {
    console.log('这里会执行吗？？？')
    emit("update:modelValue", newValue);
  },
});
</script>
```

这样子看来非常的完美啊，但是我们在set的时候代码会执行吗？？答案肯定是不会的。你对`form.name`进行赋值，并不是直接对`form`赋值，所以`set`中的代码肯定不会执行。

> form.xxx = xxx时，并不会触发computed的set，只有form.value = xxx时，才会触发set


## 5.  Proxy代理对象

那么，我们需要想一个办法，在form的属性修改时，也能`emit("update:modelValue", newValue);`，要监听对象的属性做一些事情，这要怎么办呢？？想一想vue3。答案是可以通过Proxy代理来实现：

```vue
<!-- 父组件 -->
<script setup>
import myComponent from "./components/MyComponent.vue";
import { ref, watch } from "vue";

const form = ref({
  name: "张三",
  age: 18,
  sex: "man",
});

watch(form, (newValue) => {
  console.log(newValue);
});
</script>

<template>
  <div>
    <my-component v-model="form"></my-component>
  </div>
</template>
```

```vue
<!-- 子组件 -->
<template>
  <div>
    <el-input v-model="form.name"></el-input>
    <el-input v-model="form.age"></el-input>
    <el-input v-model="form.sex"></el-input>
  </div>
</template>
<script setup>
import { computed } from "vue";

const props = defineProps({
  modelValue: {
    type: Object,
    default: () => {},
  },
});

const emit = defineEmits(["update:modelValue"]);

const form = computed({
  get() {
    return new Proxy(props.modelValue, {
      get(target, key) {
        return Reflect.get(target, key);
      },
      set(target, key, value,receiver) {
        emit("update:modelValue", {
          ...target,
          [key]: value,
        });
        return true;
      },
    });
  },
  set(newValue) {
    emit("update:modelValue", newValue);
  },
});
</script>
```

然后，为了后面使用方便，我们直接将其封装成hook

```js
// useVModel.js
import { computed } from "vue";

export default function useVModle(props, propName, emit) {
    return computed({
        get() {
            return new Proxy(props[propName], {
                get(target, key) {
                    return Reflect.get(target, key)
                },
                set(target, key, newValue) {
                    emit('update:' + propName, {
                        ...target,
                        [key]: newValue
                    })
                    return true
                }
            })
        },
        set(value) {
            emit('update:' + propName, value)
        }
    })
}
```

```vue
<!-- 子组件使用 -->
<template>
  <div>
    <el-input v-model="form.name"></el-input>
    <el-input v-model="form.age"></el-input>
    <el-input v-model="form.sex"></el-input>
  </div>
</template>
<script setup>
import useVModel from "../hooks/useVModel";

const props = defineProps({
  modelValue: {
    type: Object,
    default: () => {},
  },
});

const emit = defineEmits(["update:modelValue"]);

const form = useVModel(props, "modelValue", emit);

</script>
```

非常完美的解决喽哈哈哈



{% note purple no-icon %}

**关于Vue3的响应式原理，大家可以去看一下小编之前的文章。 🚥🚥🚥**

1. {% post_link 建立一个响应式系统  🥬 建立一个响应式系统%} 
2. {% post_link 自动收集依赖以及触发effect 🍒 自动收集依赖以及触发 effect %}
3. {% post_link Ref响应式 🎋 Ref响应式 %}

{% endnote %}


