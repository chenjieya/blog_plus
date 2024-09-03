---
title: ⛪ createWebHistory导致部署项目之后出现白屏？？？
tags:
  - vue-router
  - vue3
  - 部署
  - nginx
categories:
  - 解决方案
mathjax: true
description: 在部署项目时候踩到了createWebHistory的坑？究竟是什么原因呢？
abbrlink: 7c83404d
date: 2024-08-31 13:54:19
---
{% note purple no-icon %}

**前言 📝**

今晚自己在尝试部署Vue3项目的时候，踩到了一个坑。小编反复确认觉得自己的`nginx`配置没有问题，log日志也没有出现任何的错误，但是小编的页面就是白屏。但是奇怪的是，如果配置的路径是根路径的话`https://ip/`，这是没有任何问题的。但是配置在子路径下`https://ip/alvis/`，这种情况就会出现白屏的问题。最后小编像大佬虚心请教，学会了一招。所以这到底是怎么回事呢？

{% endnote %}


## 1. Nginx中的root和alias

Nginx指定文件路径的方式有两种`root`和`alias`

### 1.1 root的配置实例

```nginx
location /alvis {
	root /www/root/html;
}
```

> root的处理结果是 root路径 + location路径
> 也就是当访问`https://ip/alvis`的时候，他会去找`/www/root/html/alvis`下面的文件
### 1.2 alias的配置实例

```nginx
localtion /alvis {
	alias /www/root/html;
}
```

> alias的处理结果是使用alias的路径替换掉location的路径
> 也就是当访问`htpps://ip/alvis`的时候，他会去找`/www/root/html/`下面的文件


**总结：当我们要去服务器上请求一个index.html文件的时候，root的配置会是去服务器上去找 `/www/root/html/alvis/index.html` , 如果说要是通过alias配置的话，会去服务器上找 `/www/root/html/index.html` 因为alias的路径会替换掉location的路径，而root会用root的路径拼接上location的路径**


## 2. 部署之后出现的白屏问题

在简单的了解了nginx的配置之后，我们在来看一下我遇到的问题。以及为什么会出现这个问题。在这之前我先贴上我的nginx配置。

```nginx
location /cm/ {
	alias   /usr/share/nginx/html/jijianxinchou/;
	index  index.html index.htm;
	try_files $uri $uri/ /cm/index.html;
}
```

最终的访问路径是`http://23.105.202.161/cm/`, 访问之后出现了白屏，nginx并没有进行任何报错。

![image.png](https://picgo-1300696809.cos.ap-beijing.myqcloud.com/202408311428616.png)


这一步是没有任何问题的，但是问题是出现了白屏，这是为什么呢？因为我们的vue是单页面应用，当我们的客户端拿到`index.html`之后，会解析文件。走vue的路由。此时就发现了一个问题，因为我们的路由配置文件中并没有这个`/cm/`路径。所以出现白屏是正常的情况。因为没有对应的路由组件。


但是我们要怎么解决这个问题呢？

vue-router的解决方案[createWebHistory](https://router.vuejs.org/zh/api/#Functions-createWebHistory)

该函数可以传递一个参数`base`**基准路径，它被预置到每个 URL 上。这允许在一个域名子文件夹中托管 SPA，例如将 `base` 设置为 `/sub-folder` 使得其托管在 `example.com/sub-folder`**

欧克，最终就是通过该函数的参数解决的此问题，他正如官网所介绍，在每一个URL上预置了一个路径。


