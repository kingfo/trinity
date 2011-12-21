Getting Started
================================================
<a name="get-js-ready" >准备好 JS</a>
-----------------------------------------
需要 js 准备的是一个被称作 [jsentry](https://github.com/kingfo/trinity/wiki/trinity_external_parameters#wiki-jsentry) 的功能函数，当然你也可以使用其他名字或者通过 javascript 类似 _命名空间_ 方式进行。
该功能函数主要是用于接收来自
值得注意的是 `jsentry` 的 javascript 函数是具有严格的形式参数的。通常需要这样一个函数
```javascript
function jsEntry(swfid,msg){
        //...
} 
```
其中 `msg` 具有一定的格式，如 [API:Trinity External Event](https://github.com/kingfo/trinity/wiki/trinity_external_events)的传出格式。
当然你可以通过 js 类似 _命名空间_ 的方式进行，如你的自定义的类库,比如也称之 `Lib`。
```javascript
Lib.trinity.entry = function (swfid,msg){
        //...
} 
```

<a name="embed-trinity" >嵌入 Trinity</a>
-------------------------------------------
这部分内容和 [API:Trinity External Parameters](https://github.com/kingfo/trinity/wiki/trinity_external_parameters) 有关。

你可以使用任何可以嵌入 Flash 的 JS 类库如 [SWFObject](http://code.google.com/p/swfobject/) 来进行管理Flash，只要在对应的
[Flashvars](http://kb2.adobe.com/cps/164/tn_16417.html) 的参数中做配置好在 [准备好 JS](#wiki-get-js-ready) 提及的 [jsentry](https://github.com/kingfo/trinity/wiki/trinity_external_parameters#wiki-jsentry) 入口。同时指定好 [swfid](https://github.com/kingfo/trinity/wiki/trinity_external_parameters#wiki-swfid)

下面以 SWFObject 为例子

**页面结构**:
```HTML
<div id="myAlternativeContent">
	<a href="http://www.adobe.com/go/getflashplayer">
	          <img src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif" alt="Get Adobe Flash player" />
	</a>
</div>
```

**随后代码**：
```javascript
function jsEntry(swfid,msg){
        alert("calling from Trinity!");
}

var flashvars = {};
flashvars.jsentry = "jsEntry";
flashvars.swfid = "myAlternativeContent";
flashvars.group = "_group";
flashvars.debug = "true";
var params = {};
params.allowscriptaccess = "always";
var attributes = {};
swfobject.embedSWF("trinity.swf", "myAlternativeContent", "1", "1", "9.0.0", false, flashvars, params, attributes);
```

当然也可能是基于你的第三方类库
```javascript
Lib.trinity.jsEntry = function (swfid,msg){
        alert("calling from Trinity!");
}

var flashvars = {};
flashvars.jsentry = "Lib.trinity.jsEntry";
flashvars.swfid = "myAlternativeContent";
flashvars.group = "_group";
flashvars.debug = "true";
var params = {};
params.allowscriptaccess = "always";
var attributes = {};
swfobject.embedSWF("trinity.swf", "myAlternativeContent", "1", "1", "9.0.0", false, flashvars, params, attributes);
```

**注意要点**

* 必需激活 [Flash播放器参数](http://docs.kissyui.com/docs/html/api/component/flash/practice/flashplayer-parameters.html) 的 [allowscriptaccess](http://docs.kissyui.com/docs/html/api/component/flash/practice/flashplayer-parameters.html#flash.allowscriptaccess) 参数为 `true` 用于打开 Flash 和 页面脚本通信。 
* Trinity 参数大小写不敏感，但必需包含在 flashvars 中。
* `jsentry` 的路径是基于 javascript `window` 下进行索引的，因此名称需要保持一致。因此相对配置成为'Lib.trinity.jsEntry' 则相当于会进行 `window['Lib.trinity.jsEntry']`匹配，所以需要您确保 javascript 在 Trinity 呼叫之前 jsEntry 已存在。
* `swfid` 必需指定，请确保最终嵌入 flash 的元素代码的 id 和此一致。
* `group` 建议以下划线`_`开头，以便用于任何情况下通信。
* `debug` 则建议是传入有意义的非 0 值，这样就能够查看到非字节流压缩的本地缓存。这里您可能需要使用到 [minerva](http://blog.coursevector.com/minerva) 用以查看 Flash 本地缓存内容。


<a name="receive-message" >接收来自 Trinity 的消息</a>
-------------------------------------------------------
本处内容需要了解[API:Trinity External Event](https://github.com/kingfo/trinity/wiki/trinity_external_events)，由于基于 AJBridge 的 as3 core 因此会有个典型的 [swfReady](https://github.com/kingfo/trinity/wiki/trinity_external_events#wiki-swfReady) 事件产生。可以通过此事件进行检查 Flash 是否正确加载并并执行。

在 Trinity 中最常用到的是以下 5 个事件：

* [master](https://github.com/kingfo/trinity/wiki/trinity_external_events#wiki-master)
* [join](https://github.com/kingfo/trinity/wiki/trinity_external_events#wiki-join)
* [message](https://github.com/kingfo/trinity/wiki/trinity_external_events#wiki-message)
* [status](https://github.com/kingfo/trinity/wiki/trinity_external_events#wiki-status)
* [error](https://github.com/kingfo/trinity/wiki/trinity_external_events#wiki-error)

通常我们会对之前 javascript 中定义的 jsentry 做为路由，然后进行事件派发。如：
```javascript
function jsEntry(swfid,msg){
       switch(msg.type){
          case 'master':
                //...
                break;
          case 'join':
                //...
                break;
       }
}
```

<a name="broadcast-message" >通过 Trinity 发送或广播消息</a>
---------------------------------------------------------
这部分需要了解 Trinity 的 fire 接口 [`fire();`](https://github.com/kingfo/trinity/wiki/trinity_external_interface#wiki-fire) 。 更多扩展接口见  [API:Trinity External Interface](https://github.com/kingfo/trinity/wiki/trinity_external_interface)。

这部分很简单，如果你能获得 嵌入 flash 的 HTML 元素只要进行类似库的调用即可:
```javascript
var Trinity = Trinity_html_element;
Trinity.fire('Hello! Guys!');
```

当然也支持发送指定节点. 当然这里可能需要用点小技巧，比如通过 Trinity 开放的本地缓存存储并获得所有节点内容
```javascript
nodes = Trinity.getItem('nodes') || [];
for(var i=0; i<nodes.length; i++)Trinity.fire('Hello! Guy!', nodes[i]);
```

<a name="get-and-set-cache" >通过 Trinity 存取缓存消息</a>
----------------------------------------------------------
这部分需要了解 Trinity 的 [`getItem();`](https://github.com/kingfo/trinity/wiki/trinity_external_interface#wiki-getItem) 和 [`setItem();`](https://github.com/kingfo/trinity/wiki/trinity_external_interface#wiki-setItem)  。 更多扩展接口见  [API:Trinity External Interface](https://github.com/kingfo/trinity/wiki/trinity_external_interface)。


这部分很简单，如果你能获得 嵌入 flash 的 HTML 元素只要进行类似库的调用即可:
```javascript
var Trinity = Trinity_html_element;
Trinity.setItem('data','json');
alert(Trinity.getItem('data','json')); // json
```

<a name="network">Trinity 节点网络</a>
------------------------------
即由 **1** 个[主节点](#wiki-master)和  **n(n>=0)**  个 [节点](#wiki-node) 组成的网络称之为 [Trinity 节点网络](#wiki-network),简称“节点网络”.

<a name="node" >节点</a>
-----------------------------------
每个 Trinity 实例对象被称之为节点。每个节点随时都可能成为[主节点](#wiki-master)。因此需要通过侦听[master](https://github.com/kingfo/trinity/wiki/trinity_external_events#wiki-master)事件以便采取行动。

而对于任何应用来说几乎可以忽略是否是[主节点](#wiki-master)还是[节点](#wiki-node),因为他们之间是可以随时被切换的，同时他们又具备了完全相同的接口。只是在应用对应的活动层不同而已，如向网络发起请求以及获得数据的必然是 master 而 node 只要坐等数据被广播然后处理就好。

节点具有以下几个事件:

* [join](https://github.com/kingfo/trinity/wiki/trinity_external_events#wiki-join)
* [message](https://github.com/kingfo/trinity/wiki/trinity_external_events#wiki-message)
* [status](https://github.com/kingfo/trinity/wiki/trinity_external_events#wiki-status)
* [error](https://github.com/kingfo/trinity/wiki/trinity_external_events#wiki-error)

可以看出除 [master](https://github.com/kingfo/trinity/wiki/trinity_external_events#wiki-master) 外都有相关事件。

而其[扩展接口](https://github.com/kingfo/trinity/wiki/trinity_external_interface)是完备的。

<a name="master" >主节点</a>
-----------------------------
主节点又称之“master节点”，是整个[Trinity 节点网络](#wiki-network)唯一的控制器，负责对活动层的控制和消息转发或广播，是关键的节点。

一般情况下第一个创建的Trinity实例就是 master 节点。

当且仅当该节点下线、关闭或者失效，则其他从属节点会发现从而在从属节点中会诞生新的主节点。

该节点拥有最大权限以及全部的[接口](https://github.com/kingfo/trinity/wiki/trinity_external_interface)和[事件](https://github.com/kingfo/trinity/wiki/trinity_external_events)

<a name="node-vs-master" >主节点 vs. 节点</a>
---------------------------------------------
<table>
<col width="200px">
<col width="80px">
<tbody>
<tr>
    <th>接口</th>
    <th>主节点</th>
    <th>节点</th>
</tr>
<tr>
    <th rowspan="1">fire(data[,to]) ;</th>
    <td>√</td>
    <td>√</td>
</tr>
<tr>
    <th rowspan="1">getItem(key) ;</th>
    <td>√</td>
    <td>√</td>
</tr>
<tr>
    <th rowspan="1">setItem(key,value) ;</th>
    <td>√</td>
    <td>√</td>
</tr>
<tr>
    <th rowspan="1">connect() ;</th>
    <td>√</td>
    <td>√</td>
</tr>
</tbody>
</table>
<table>
<col width="200px">
<col width="80px">
<col width="*">
<tbody>
<tr>
    <th>事件</th>
    <th>主节点</th>
    <th>节点</th>
</tr>
<tr>
    <th rowspan="1">swfReady</th>
    <td>√</td>
    <td>√</td>
</tr>
<tr>
    <th rowspan="1">master</th>
    <td>√</td>
    <td>x</td>
</tr>
<tr>
    <th rowspan="1">join</th>
    <td>√</td>
    <td>√</td>
</tr>
<tr>
    <th rowspan="1">message</th>
    <td>√</td>
    <td>√</td>
</tr>
<tr>
    <th rowspan="1">status</th>
    <td>√</td>
    <td>√</td>
</tr>
<tr>
    <th rowspan="1">error</th>
    <td>√</td>
    <td>√</td>
</tr>
</tbody>
</table>