---
title: unplugin-vue-setup-extend-plus库TS报错问题
tags:
  - 开源
  - 贡献
  - unplugin-vue-setup-extend-plus
  - vue3
categories:
  - 解决方案
mathjax: true
date: 2024-06-07 15:34:02
description: 在vue3项目中使用unplugin-vue-setup-extend-plus工具库的时候，导入相关的包的时候，发现ts并没有一起导入。在本篇文章中讲解一些如何解决的相关问题，并提一下如何给开源代码做贡献
comment: true
---

{% note purple no-icon %}

**前言 📝**

大家需要先有一个自己的github账号，并且要简单熟悉一下vue的语法。

github账号申请：[https://github.com/signup?ref_cta=Sign+up&ref_loc=header+logged+out&ref_page=%2F&source=header-home](https://github.com/signup?ref_cta=Sign+up&ref_loc=header+logged+out&ref_page=%2F&source=header-home)

vue3官网：[https://cn.vuejs.org/guide/introduction.html](https://cn.vuejs.org/guide/introduction.html)

{% endnote %}

过年那段时间，博主闲来无事想写一个vue3的项目玩一玩。在写vue3项目的时候，找到了一个给组件命名的工具库==unplugin-vue-setup-extend-plus==。简单介绍一下如何使用：


1. 找到`vite.config.ts`文件

```js
// name->setup
import vueSetupExtend from 'unplugin-vue-setup-extend-plus/vite'
export default defineConfig({
  plugins: [
    vueSetupExtend({
      enableAutoExpose: true
    }),
  ],
})
```

2. 找到`main.ts`文件
```js
import autoExpose from 'unplugin-vue-setup-extend-plus/dist/client/index'
```

3. 使用

```vue
<script setup lang="ts" name="HomeView">

</script>
```


但是，就是第二步引入文件的时候官方奖励了我一个大大的红色波浪线。

![image.png](https://picgo-1300696809.cos.ap-beijing.myqcloud.com/202406071611164.png)

提示的很明显了，就是我们没有导入对应的ts声明类型。


小编刚开始怎么解决的问题呢？

我是在自己的本地项目中，把他node_moduls下面的类型声明导入进来了。

**找到项目中的ts配置文件**

```json
{
  "extends": "@vue/tsconfig/tsconfig.dom.json",
  "include": ["env.d.ts", "src/**/*", "src/**/*.vue", "auto-imports.d.ts"],
  "exclude": ["src/**/__tests__/*", "node_modules"],
  "compilerOptions": {
    "composite": true,
    "noEmit": true,
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"],
      // 这是找到了node_modules下面unplugin-vue-setup-extend-plus工具库打包之后生成的ts声明文件
      "unplugin-vue-setup-extend-plus/*": ["node_modules/unplugin-vue-setup-extend-plus/*"]
    }
  }
}
```


但是这样解决并不是很好啊，于是小编决定是看看源码。怀着激动的心情去打开了源码，结果看不懂哈哈哈。不过还好，小编知道这块如何去改。这块不是什么功能型的问题，我还是可以简单解决一下的。接下来就让我们一起看看如何给源码做贡献把。


### 1. 将项目fork到本地仓库

![image.png](https://picgo-1300696809.cos.ap-beijing.myqcloud.com/202406071634563.png)


### 2. 将fork到仓库的项目克隆到本地


### 3. 运行项目+代码更改

![image.png](https://picgo-1300696809.cos.ap-beijing.myqcloud.com/202406071636645.png)


### 4. 将项目推送到我们的仓库


### 5. 提交Pull Request

![image.png](https://picgo-1300696809.cos.ap-beijing.myqcloud.com/202406071638748.png)


按照模板提交填写本次提交的内容

![image.png](https://picgo-1300696809.cos.ap-beijing.myqcloud.com/202406071639312.png)


### 6. 提交之后等待作者审核，合并代码

### 7. 审核通过之后就能看到我们提交的代码了

![image.png](https://picgo-1300696809.cos.ap-beijing.myqcloud.com/202406071641082.png)


![image.png](https://picgo-1300696809.cos.ap-beijing.myqcloud.com/202406071640013.png)


