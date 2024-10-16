---
title: "\U0001F6D1 docker环境下配置cerbot获取免费ssl证书并自动续期"
tags:
  - 部署
  - Docker
  - nginx
categories:
  - 解决方案
mathjax: true
description: docker环境下配置cerbot获取免费ssl证书并自动续期
abbrlink: 65b95405
date: 2024-10-16 16:19:11
---
{% note purple no-icon %}

**前言 📝**

本人使用docker部署了一个nginx容器，通过容器卷，实现本地html，conf, conf/ssl，和nginx容器映射。之前我使用的是[阿里云免费证书](https://yundun.console.aliyun.com/?spm=a2c6h.12873639.article-detail.8.7d7463bd16yGi9&userCode=r3yteowb&p=cas#/certExtend/free/cn-hangzhou?currentPage=1&pageSize=10&keyword=&statusCode=total) 。但是现在的免费证书有效期都换成了三个月的了。经常需要手动部署免费证书。经过研究发现: 使用[cerbot](https://certbot.eff.org/instructions?ws=nginx&os=snap)可以通过脚本的形式来完成证书的颁发，通过设置定时任务在过期前重新申请和替换，就可以曲线救国的形式来完成ssl证书自动续期，解放双手。

{% endnote %}

> 要是通过其他方案部署的，想要安装证书可以去官网自行查看。
## 1. 查看nginx的映射情况

> 确认已经对外映射了容器卷（生成的证书要放在本地目录，便于映射给nginx容器）

`docker inspect 容器名/容器id`

docker命令不熟悉的可以去小编的其他文章看一下{% post_link docker准备工作  💡 docker准备工作%}

![image.png](https://picgo-1300696809.cos.ap-beijing.myqcloud.com/202410161638135.png)

我得`ssl`存放证书的目录，在`conf`配置目录下面

![image.png](https://picgo-1300696809.cos.ap-beijing.myqcloud.com/202410161639312.png)


确认开放了80和443端口

![image.png](https://picgo-1300696809.cos.ap-beijing.myqcloud.com/202410161640136.png)


## 2. 操作目标

1. 更改映射出来的nginx配置文件

![image.png](https://picgo-1300696809.cos.ap-beijing.myqcloud.com/202410161757327.png)

```nginx
# 处理特定后缀的请求
location  ~/.well-known/acme-challenge/ {
	root /usr/share/nginx/html/certbot;          
}
```

执行docker命令

`/project/DockerVolumes/nginx/conf/ssl/`这是宿主机从nginx容器映射出来的ssl证书路径。
`/project/DockerVolumes/nginx/`这是宿主机从nginx容器映射出来的nginx路径。

```shell
docker run -it --rm --name certbot \
            -v /project/DockerVolumes/nginx/conf/ssl/wiseinsightai/certbot/etc/letsencrypt:/etc/letsencrypt \
            -v /project/DockerVolumes/nginx/conf/ssl/wiseinsightai/certbot/var/lib/letsencrpt:/var/lib/letsencrypt \
            -v /project/DockerVolumes/nginx/conf/ssl/wiseinsightai/certbot/var/log/letsencrpt:/var/log/letsencrypt \
            -v /project/DockerVolumes/nginx/html/certbot:/data/letsencrypt \
            certbot/certbot certonly  \
            --webroot  \
            --webroot-path=/data/letsencrypt \
            --agree-tos -d xxxx.cn
```

正常情况下，执行成功，会生成证书，在`/etc/letsencrypt/live/域名/live`下，对应的宿主机目录下:

> /project/DockerVolumes/nginx/conf/ssl/wiseinsightai/certbot/etc/letsencrypt/live



## 3. 配置nginx配置的ssl证书

```nginx
server {
    listen 443 ssl;
    server_name xxx.cn;

    ssl_certificate /etc/nginx/ssl/wiseinsightai/certbot/etc/letsencrypt/live/xxx.cn/fullchain.pem;
    ssl_certificate_key /etc/nginx/ssl/wiseinsightai/certbot/etc/letsencrypt/live/xxx.cn/privkey.pem;  #替换为证书的域名
    ssl_session_timeout 5m;
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;
    ssl_protocols TLSv1.1 TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;

    location / {
        root   /usr/share/nginx/html/myblogplus;
        index  index.html index.htm;
    }
}

server {
    listen 80;
    server_name xxx.cn;  #替换为域名
    # http -> https
    rewrite ^(.*)$ https://$host$1;

    # 处理特定后缀的请求
    location  ~/.well-known/acme-challenge/ {
        root /usr/share/nginx/html/certbot;          
    }
}
```


配置好之后，重新启动docker就可以了。


## 4. 设置自动续签

因为证书3个月就到期，我们可以设置一个定时任务，自动生成即可，cerbot的续签命令是`renew`关键字。

```shell
docker run -it --rm --name certbot \
		-v /project/DockerVolumes/nginx/conf/ssl/wiseinsightai/certbot/etc/letsencrypt:/etc/letsencrypt \
		-v /project/DockerVolumes/nginx/conf/ssl/wiseinsightai/certbot/var/lib/letsencrpt:/var/lib/letsencrypt \
		-v /project/DockerVolumes/nginx/conf/ssl/wiseinsightai/certbot/var/log/letsencrpt:/var/log/letsencrypt \
		-v /project/DockerVolumes/nginx/html/certbot:/data/letsencrypt \
		certbot/certbot  renew
```


将此命令写成脚本放到`/root/renew_cert.sh`

![image.png](https://picgo-1300696809.cos.ap-beijing.myqcloud.com/202410161812127.png)

通过`crontab -e`设置定时执行该脚本，内容如下:  
根据自己的需求设置定时时间，我这里设置12小时一次。

```shell
# 自动续签证书
0 */12 * * * /root/renew_cert.sh
```


> 注意: 只有到期30天内才能执行成功，否则，脚本会提示没过期，不需要续签，直接跳过


![image.png](https://picgo-1300696809.cos.ap-beijing.myqcloud.com/202410161815123.png)


