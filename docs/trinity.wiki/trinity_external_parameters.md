API:Trinity External Parameters
=================================
这是通过 [Flashvars](http://kb2.adobe.com/cps/164/tn_16417.html) 进行参数传递给Flash。也可以通过类似 GET 的方式给Flash传递参数。如：
```html
YOURFLASHNAME.swf?jsEntry="YOURJAVASCRIPTENTRYNAME"
```

!!! _**注意** 以下所有参数实际中大小写不敏感_ !!!

<a name="jsentry" >jsentry</a>
------------------------------------
Trinity 向 javascript 发送数据的统一的 **全局函数调用入口**。即 Trinity 向 javascript 输入数据的入口，可以根据具体情况配置。如何使用可以[参考这里](https://github.com/kingfo/trinity/wiki/trinity_getting_started#wiki-get-js-ready)。

值得注意的是，jsentry的路径是基于 javascript window 下进行索引的，因此名称需要保持一致。因此相对配置成为'Lib.trinity.jsEntry' 则相当于会进行 window['Lib.trinity.jsEntry']匹配，所以需要您确保 javascript 在 Trinity 呼叫之前 jsEntry 已存在。

<a name="swfid" >swfid</a>
----------------------------
Trinity 用于向 javascript 发送数据的识别id。该属性在单页面多 Trinity实例管理时十分有用。

!!!_**注意**该 ID 需要和嵌入 flash 的 HTML 元素 id 一致_!!!

<a name="group" >group</a>
---------------------------
Trinity 网络组名。用于识别同一应用，一般情况下只有 [主节点](https://github.com/kingfo/trinity/wiki/trinity_getting_started#wiki-master)才使用该名字，其他从属[节点](https://github.com/kingfo/trinity/wiki/trinity_getting_started#wiki-node)都使用由该体系决定的随机不重复名称。

<a name="debug" >debug</a>
---------------------------
Trinity 调试开启标识，一般用于开启不压缩的本地存储用于查看结构。这里您可能需要使用到 [minerva](http://blog.coursevector.com/minerva) 用以查看 Flash 本地缓存内容。