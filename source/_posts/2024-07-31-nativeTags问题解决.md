---
title: "\U0001F34A 关于vscode开发uni-app中依赖@uni-helper/uni-app-types的配置"
tags:
  - tsconfig
  - uniapp
  - vscode
categories:
  - 解决方案
comment: true
description: '类型“{ class: string; }”的参数不能赋给类型"ComponentPublicInstanceConstructor"'
abbrlink: a6fd95c4
date: 2024-07-31 14:30:57
---
{% note purple no-icon %}

**前言 📝**

今天在使用vsCode开发uniapp微信小程序的时候，突然发现我的页面都报错了（报错截图放到下面）。然后我就开始找问题，最后发现是我升级了`Vue-Official`插件。当时通过搜索引擎查出来的方案是将插件改为 **`v2.0.12`** 这个版本，还有一种解决方案是在ts配置文件中添加如下代码：

```ts
"vueCompilerOptions": {
   "nativeTags": ["block", "component", "template", "slot"]
}
```

{% endnote %}

![image.png](https://picgo-1300696809.cos.ap-beijing.myqcloud.com/202407311448519.png)

**出现上面的原因是把这些标签当成了vue组件，某些属性并没有出现在Vue组件的Interface上面。**

当我在配置`vueCompilerOptions.nativeTags`的时候，出现了错误*不允许的属性*，然后`.vue`文件还是一如既往的飘红。

![image.png](https://picgo-1300696809.cos.ap-beijing.myqcloud.com/202407311459540.png)


这个时候我们就需要[官网](https://uni-helper.js.org/uni-app-types)了, `nativeTags`属性不在被支持的原因是**在node_modules文件夹中的@uni-helper/uni-app-types/volar-plugin文件依赖中已经配置好了nativeTags。**

![image.png](https://picgo-1300696809.cos.ap-beijing.myqcloud.com/202407311503616.png)


那我们需要怎么配置呢？？再次进入到我们的[传送门](https://uni-helper.js.org/uni-app-types)

![image.png](https://picgo-1300696809.cos.ap-beijing.myqcloud.com/202407311506027.png)


当然也需要注意一下`@uni-helper/uni-app-types`包的版本(在0.5.13版本才开始支持plugin写法)：

![image.png](https://picgo-1300696809.cos.ap-beijing.myqcloud.com/202407311507523.png)
