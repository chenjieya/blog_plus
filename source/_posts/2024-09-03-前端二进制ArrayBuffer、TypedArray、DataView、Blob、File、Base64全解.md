---
title: 🔓  前端二进制ArrayBuffer、TypedArray、DataView、Blob、File、Base64全解
tags:
  - 二进制
  - ArrayBuffer
  - TypedArray
  - DataView
  - Blob
  - File
  - Base64
  - FileReader
categories:
  - 解决方案
mathjax: true
date: 2024-09-03 13:25:09
description: "前端二进制相关API: ArrayBuffer、TypedArray、DataView、Blob、File、Base64、FileReader"
---
{% note purple no-icon %}

**前言 📝**

无论是在图像处理、音频视频流、文件上传还是网络通信中，二进制数据都以其高效性和灵活性被广泛应用。JavaScript 作为 Web 开发的基石，提供了一套丰富的 API 来处理二进制数据，包括 ArrayBuffer、DataView、TypedArray、Blob、File 和 Base64 等。

由于这些 API 如果仅仅做页面开发，一般用不上，所以很多人在真正需要用到二进制处理的时候，不知道应该用哪个，也不知道怎么用，本文旨在讲清楚这些 API 的差别和使用场景。帮助大家同时也帮助我自己更近一步的了解该用何种API去处理二进制的场景。

{% endnote %}


## 1. ArrayBuffer

`ArrayBuffer`它是一个字节数组，通常在其他语言中称为“byte array”。你不能直接操作 `ArrayBuffer` 中的内容。而是要通过[类型化数组对象](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/TypedArray)或 [`DataView`](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/DataView) 对象来操作。

```js
// 创建一个长度为 16 的 buffer 它会分配一个 16 字节（byte）的连续内存空间，并用 0 进行预填充。
const buffer = new ArrayBuffer(16);
```



## 2.  TypedArray

TypedArray 是一个通用的术语，没有这个构造函数，是下面这些构造函数的统称：

|类型|值范围|字节大小|描述|Web IDL 类型|等价的 C 类型|
|---|---|---|---|---|---|
|[`Int8Array`](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Int8Array)|-128 到 127|1|8 位有符号整型（补码）|`byte`|`int8_t`|
|[`Uint8Array`](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Uint8Array)|0 到 255|1|8 位无符号整型|`octet`|`uint8_t`|
|[`Uint8ClampedArray`](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Uint8ClampedArray)|0 到 255|1|8 位无符号整型（一定在 0 到 255 之间）|`octet`|`uint8_t`|
|[`Int16Array`](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Int16Array)|-32768 到 32767|2|16 位有符号整型（补码）|`short`|`int16_t`|
|[`Uint16Array`](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Uint16Array)|0 到 65535|2|16 位无符号整型|`unsigned short`|`uint16_t`|
|[`Int32Array`](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Int32Array)|-2147483648 到 2147483647|4|32 位有符号整型（补码）|`long`|`int32_t`|
|[`Uint32Array`](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Uint32Array)|0 到 4294967295|4|32 位无符号整型|`unsigned long`|`uint32_t`|
|[`Float32Array`](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Float32Array)|`-3.4E38` 到 `3.4E38` 并且 `1.2E-38` 是最小的正数|4|32 位 IEEE 浮点数（7 位有效数字，例如 `1.234567`）|`unrestricted float`|`float`|
|[`Float64Array`](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Float64Array)|`-1.8E308` 到 `1.8E308` 并且 `5E-324` 是最小的正数|8|64 位 IEEE 浮点数（16 位有效数字，例如 `1.23456789012345`）|`unrestricted double`|`double`|
|[`BigInt64Array`](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/BigInt64Array)|-263 到 263 - 1|8|64 位有符号整型（补码）|`bigint`|`int64_t (signed long long)`|
|[`BigUint64Array`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/BigUint64Array "此页面目前仅提供英文版本")|0 到 264 - 1|8|64 位无符号整型|`bigint`|`uint64_t (unsigned long long)`|
所有的类型化数组都是基于 `ArrayBuffer` 进行操作的，`TypedArray`​ 具有常规的 `Array`​ 方法，比如 `map`​，`slice`​，`find`​ 和 `reduce`​ 等。


## 3. DataView

**`DataView`** 视图是一个可以从二进制 `ArrayBuffer` 对象中读写多种数值类型的底层接口，与 `TypedArray`​ 不同，`DataView`​ 不会为存储的数据指定特定的数据类型，因此它允许你以多种不同的数值类型读取和写入 `ArrayBuffer`​ 中的字节。

```js
// 可以转成各种格式
const dataView = new DataView(buffer);
// 接受三个参数，1.字节序号，2.写入的数据，3.写入方式（true：小端/false|undeifined:大端）
dataView.setFloat64(0, 25, false); // 在第一个字节以大端字节序写入一个值为25的32位整数
console.log(dataView);
console.log(dataView.getUint8(0)); // 64
console.log(dataView.getUint16(0)); // 16441
console.log(dataView.getUint32(0)); // 1077477376
console.log(dataView.getFloat64(0)); // 25
```

如果我想得到ArrayBuffer怎么办呢？答案很简单： `dataView.buffer`

## 4. Blob

`Blob` 对象表示一个不可变、原始数据的类文件对象。它主要用于处理二进制数据，比如图片、视频、音频文件等。**一旦创建，Blob的内容不能被修改。**

```js
const blob = new Blob(array, options)
```

- array 是一个由`ArrayBuffer, ArrayBufferView, Blob, DOMString` 等对象构成的数组，`DOMStrings`会被编码为UTF-8。
- options 是一个可选，它可能会指定如下两个属性：
    - type，默认值为 `""`，内容的MIME类型。
    - endings，默认值为`"transparent"`，用于指定包含行结束符`\n`的字符串如何被写入。 它是以下两个值中的一个： `"native"`，代表行结束符会被更改为适合宿主操作系统文件系统的换行符，或者 `"transparent"`，代表会保持blob中保存的结束符不变

```js
// 注意： 第一个参数必须是一个数组
const blob = new Blob(["<html>…</html>"], {type: 'text/html'});
```

```js
const hello = new Uint8Array([72, 101, 108, 108, 111]);  // 二进制格式的 Hello
const blob = new Blob([hello, ' ', 'world'], { type: 'text/plain' });
```

### 4.1 Blob方法

- `slice()` 从 `Blob` 中截取一部分并返回一个新的 `Blob`(用法同数组的 `slice`)
- `arrayBuffer()` 返回一个以二进制形式展现的 `promise`
- `stream()` 返回一个`ReadableStream`对象
- `text()` 返回一个文本形式的 `promise`

```js
// 转成stream
console.log(blob.stream());

// 转成Arraybuffer
blob.arrayBuffer().then((res) => {
  console.log(res);
});

// 转成文本
blob.text().then((res) => {
  console.log(res);
});
```

### 4.2 Blob Url

Blob 可以很容易用作 `<a>`、`<img>` 或其他标签的 URL，来显示它们的内容。多亏了 `type`，让我们也可以下载/上传 `Blob` 对象，而在网络请求中，`type` 自然地变成了 `Content-Type`。让我们从一个简单的例子开始。通过点击链接，你可以下载一个具有动态生成的内容为 `hello world` 的 `Blob` 的文件：

```js
export const downloadFile = async (params, fileName) => {
  const result = new Blob(['Hello World!'], { type: 'text/plain' })
  
  const a = document.createElement("a");
  a.download = "hello.txt";
  
  // 生成blob url。这里可以使用Blob对象或者File对象
  a.href = window.URL.createObjectURL(results);
  a.style.display = "none";
  document.body.appendChild(a);
  a.click();
  // 释放内存
  window.URL.revokeObjectURL(a.href);
  document.body.removeChild(a);
};
```


生成的链接类似于：
```js
blob:https://javascript.info/1e67e00e-860d-40a5-89ae-6ab0cbee6273
```


## 5. File

​`File`​ 是 `Blob`​ 的一个子类，专门用于表示文件。它继承了 `Blob`​ 的所有属性和方法，并且添加了一些与文件相关的额外属性和功能。例如：文件类型、文件大小、最后修改时间。

```js
const file = new File(array, name[, options])
```

- array 是一个由`ArrayBuffer, ArrayBufferView, Blob, DOMString` 等对象构成，`DOMStrings`会被编码为UTF-8。
- name 表示文件名称，或者文件路径。
- options 是一个可选，它可能会指定如下两个属性：
    - type，默认值为 `""`，内容的MIME类型。
    - lastModified: 数值，表示文件最后修改时间的 Unix 时间戳（毫秒）。默认值为 Date.now()。

### 5.1 File属性

- `type` 类型 [常见的MIME 类型](https://link.juejin.cn/?target=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FHTTP%2FBasics_of_HTTP%2FMIME_types%2FCommon_types "https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types")
- `size` 大小、单位为字节
- `name` 文件名称
- `lastModified` 最后修改时间（时间戳）
- `lastModifiedDate` 最后修改时间

```js
const file = new File(["文件对象"], "test", { type: "text/plain" });
// 输出的对象有如下属性
// lastModified: 1640589621358
// lastModifiedDate: Mon Dec 27 2021 15:20:21 GMT+0800 (中国标准时间) {}
// name: "test"
// size: 12
// type: "text/plain"
// webkitRelativePath: ""
console.log(file);
```

### 5.2 方法

- `slice()` 从 `Blob` 中截取一部分并返回一个新的 `Blob`(用法同数组的 `slice`)
- `arrayBuffer()` 返回一个以二进制形式展现的 `promise`
- `stream()` 返回一个`ReadableStream`对象
- `text()` 返回一个文本形式的 `promise`
  
```js
// 转成stream
console.log(file.stream());

// 转成Arraybuffer
file.arrayBuffer().then((res) => {
  console.log(res);
});

// 转成文本
file.text().then((res) => {
  console.log(res);
});
```


## 6. Base64

Base64是一种编码格式，在前端经常会碰到，格式是 `data:[<mediatype>][;base64],<data>` 。js内置了两个方法能进行字符串的Base64的编码和解码。

```js
const str = "hello alvis";

// 编码
const b = window.btoa(str);
console.log(b); // aGVsbG8gYWx2aXM=

// 解码
const str2 = window.atob(b);
console.log(str2); // hello alvis
```

**Base64 编码的主要用途包括：**
- 在文本格式中传输二进制数据，如在电子邮件中发送图像。
- 在网页中内嵌图像或其他二进制文件。
- 在配置文件中存储二进制数据。
- 作为数据传输的一种方式，尤其是在不支持二进制传输的环境中。

## 7.  Base64 和 ArrayBuffer、Blob 之间的关系

`ArrayBuffer`​ 和 `Blob`​ 都用于表示原始二进制数据，但 `Blob`​ 更多地用于处理文件和图像等大型二进制对象，而 `ArrayBuffer`​ 更多地用于在需要高效数据访问和传输的场景中。

Base64 编码可以将 `ArrayBuffer`​ 或 `Blob`​ 中的二进制数据转换为可打印的文本格式，这使得二进制数据可以以文本形式存储和传输。这对于在不支持二进制传输的环境中传输数据非常有用。


## 8. 相互转换

### 8.1 Blob转File

```js
const blob = new Blob(["blob文件"], { type: "text/plain" });
// blob转file
const file = new File([blob], "test", { type: blob.type });
console.log("file: ", file);
```

### 8.2 File转Blob

```js
const file = new File(["文件对象"], "test", { type: "text/plain" });
// file转blob
const blob = new Blob([file], { type: file1.type });
console.log("blob: ", blob);
```


### 题外补充

FileReader 对象允许 Web 应用程序异步读取存储在用户计算机上的文件（或原始数据缓冲区）的内容。

| 属性                    | 描述                                                      |
| --------------------- | ------------------------------------------------------- |
| FileReader.error      | 一个DOMException，表示在读取文件时发生的错误 。                          |
| FileReader.result     | 返回文件的内容。只有在读取操作完成后，此属性才有效，返回的数据的格式取决于是使用哪种读取方法来执行读取操作的。 |
| FileReader.readyState | 表示FileReader状态的数字。0 还没有加载任何数据。1 数据正在被加载。2 已完成全部的读取请求。   |

需要注意的是 ，无论读取成功或失败，方法并不会返回读取结果，这一结果存储在 result属性中。

| 方法名                             | 描述                                                                         |
| ------------------------------- | -------------------------------------------------------------------------- |
| FileReader.abort()              | 中止读取操作。在返回时，readyState 属性为 DONE。                                           |
| FileReader.readAsArrayBuffer()  | 将读取的内容转成ArrayBuffer。                                                       |
| FileReader.readAsBinaryString() | 将读取的内容转成二进制数据。                                                             |
| FileReader.readAsDataURL()      | 将读取的内容转成并将其编码为 base64 的 data url。 格式是 `data:[<mediatype>][;base64],<data>` |
| FileReader.readAsText()         | 将数据读取为给定编码（默认为 utf-8 编码）的文本字符串。                                            |

| 事件                     | 描述                                      |
| ---------------------- | --------------------------------------- |
| FileReader.onabort     | 处理 abort 事件。该事件在读取操作被中断时触发。             |
| FileReader.onerror     | 处理 error 事件。该事件在读取操作发生错误时触发。            |
| FileReader.onload      | 处理 load 事件。该事件在读取操作完成时触发。               |
| FileReader.onloadstart | 处理 loadstart 事件。该事件在读取操作开始时触发。          |
| FileReader.onloadend   | 处理 loadend 事件。该事件在读取操作结束时（要么成功，要么失败）触发。 |
| FileReader.onprogress  | 处理 progress 事件。该事件在读取Blob时触发。           |

举个例子：

```js
const blob = new Blob(["hello", "alvis"], { type: "text/plain" });
const fileReader = new FileReader();
fileReader.readAsDataURL(blob);
fileReader.onload = () => {
  console.log(fileReader);
  // 通过fileReader获取结果
  // fileReader.result 是结果（如果成功）
  // fileReader.error 是 error（如果失败）。
};
```

### 8.3 Blob转Base64(转换成ArrayBuffer同理readAsArrayBuffer)

```js
const blob = new Blob(["hello", "alvis"], { type: "text/plain" });

const fileReader = new FileReader();

fileReader.readAsDataURL(blob)

fileReader.onload = () => {
	console.log(fileReader.result);   // data:text/plain;base64,aGVsbG9hbHZpcw==
}
```


### 8.4 File转Base64(转换成ArrayBuffer同理readAsArrayBuffer)

```js
const file = new File(["文件对象"], "test", { type: "text/plain" });

const fileReader =new FileReader();

fileReader.readAsDataURL(file);

fileReader.onload = () => {
	console.log(fileReader.result);   // data:text/plain;base64,aGVsbG9hbHZpcw==
}
```


### 8.5 img转Base64

```js
// 本地图片转base64，注意链接是本地链接不能是网络地址。
const img2base64 = (imgUrl) => {
  let image = new Image();
  image.src = imgUrl;
  return new Promise((resolve) => {
    image.onload = () => {
      let canvas = document.createElement("canvas");
      canvas.width = image.width;
      canvas.height = image.height;
      var context = canvas.getContext("2d");
      context.drawImage(image, 0, 0, image.width, image.height);
      let dataUrl = canvas.toDataURL("image/png");
      resolve(dataUrl);
    };
  });
};

img2base64("../vue2/src/assets/logo.png").then((res) => {
  console.log(res);
});
```

### 8.7 Base64转Blob

```js
function dataURLtoBlob(dataurl) {
  // `data:[<mediatype>][;base64],<data>`
  var arr = dataurl.split(","),
    mime = arr[0].match(/:(.*?);/)[1],
    bstr = atob(arr[1]),
    n = bstr.length,
    u8arr = new Uint8Array(n);
  while (n--) {
    u8arr[n] = bstr.charCodeAt(n);
  }
  return new Blob([u8arr], { type: mime });
}
```


### 8.8 Base64转File

```js
function dataURLtoFile(dataurl, filename) {
  //将base64转换为文件
  var arr = dataurl.split(","),
    mime = arr[0].match(/:(.*?);/)[1],
    bstr = atob(arr[1]),
    n = bstr.length,
    u8arr = new Uint8Array(n);
  while (n--) {
    u8arr[n] = bstr.charCodeAt(n);
  }
  return new File([u8arr], filename, { type: mime });
}
```


### 8.9 Base64 转 ArrayBuffer

```js
function dataURLtoArrayBuffer(dataurl) {
  // `data:[<mediatype>][;base64],<data>`
  var arr = dataurl.split(","),
    mime = arr[0].match(/:(.*?);/)[1],
    bstr = atob(arr[1]),
    n = bstr.length,
    u8arr = new Uint8Array(n);
  while (n--) {
    u8arr[n] = bstr.charCodeAt(n);
  }
  return u8arr.buffer;
}
```


### 8.10 ArrayBuffer 转 Base64

```js
let buffer = new ArrayBuffer(16);
let arrayBufferView = new Uint8Array(buffer);

let base64String = arrayBufferView.reduce((data, byte) => data + String.fromCharCode(byte), '');
let encodedString = btoa(base64String);
console.log(encodedString);
```


## 9. 总结

在 JavaScript 里关于二进制相关的应该基本都包含了，最重要的是了解他们的使用场景：

- **ArrayBuffer** 适用于需要高效数据访问和传输的场景，如 Web Workers 或网络通信。
- **Blob** 和 **File** 更多地用于处理文件和图像等大型二进制对象，适合在文件上传或图像处理中使用。
- **Base64** 编码特别适用于在文本环境中传输二进制数据，如在电子邮件中发送图像或在网页中内嵌图像。

相互转换，Blob和File需要通过`FileReader`读取,读取之后可以转换成`ArrayBuffer`和`Base64`；ArrayBuffer可以直接转换成`Blob`，转换成`Base64`需要先转换成`TypedArray`, 这样在通过`botoa`; Base64需要先`atob`解码，然后转换成`TypedArray`, 这样可以转换成任意的内容`ArrayBuffer`、`Blob`、`File`。


