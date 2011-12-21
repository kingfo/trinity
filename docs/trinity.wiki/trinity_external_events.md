API:Trinity External Events
============================
为了能统一输出，所有输出都会传给被称为 [jsentry](https://github.com/kingfo/trinity/wiki/trinity_external_parameters#wiki-jsentry)  的函数入口，如何使用[jsentry](https://github.com/kingfo/trinity/wiki/trinity_external_parameters#wiki-jsentry) 可以[参考这里](https://github.com/kingfo/trinity/wiki/trinity_getting_started#wiki-get-js-ready)。

<a name="swfReady" >swfReady</a>
---------------------------------
由于基于 AJBridge 的 as3 core 因此会有个典型的 swfReady 事件产生。可以通过此事件进行检查 Flash 是否正确加载并并执行。

**swfReady 事件具备以下消息格式**：
```javascript
{type:'swfReady'}
```

<a name="master" >master</a>
------------------------------
当前[节点](https://github.com/kingfo/trinity/wiki/trinity_getting_started#wiki-node)第一次创建时就处于[主节点(master)](https://github.com/kingfo/trinity/wiki/trinity_getting_started#wiki-master) 或者[主节点(master)](https://github.com/kingfo/trinity/wiki/trinity_getting_started#wiki-master)失效时被当前[节点](https://github.com/kingfo/trinity/wiki/trinity_getting_started#wiki-node)占有都有这个事件产生。

**master 事件具备以下消息格式** ：
```javascript
{type:'master',name:GROUP}
```
其中 `name` 就为**当前网络组**的名称，是通过 [Trinity 参数](https://github.com/kingfo/trinity/wiki/trinity_external_parameters) 中的 [group](https://github.com/kingfo/trinity/wiki/trinity_external_parameters#wiki-group)参数决定。 
 
<a name="join" >join</a>
------------------------
当前[节点](https://github.com/kingfo/trinity/wiki/trinity_getting_started#wiki-node)加入网络组，任意[节点](https://github.com/kingfo/trinity/wiki/trinity_getting_started#wiki-node)都有该事件产生。

**join 事件具备以下消息格式**：
```javascript
{type:'join',name:NODENAME}
```
其中 `name` 就为**当前[节点](https://github.com/kingfo/trinity/wiki/trinity_getting_started#wiki-node)**的名称。 他是由该[节点](https://github.com/kingfo/trinity/wiki/trinity_getting_started#wiki-node)自行生成的随机编码名称。 

<a name="message" >message</a>
------------------------------
当前[节点](https://github.com/kingfo/trinity/wiki/trinity_getting_started#wiki-node)接收到来自其他任意[节点](https://github.com/kingfo/trinity/wiki/trinity_getting_started#wiki-node)的消息时的事件。

**message事件具备以下消息格式**：
```javascript
{type:'message', data:ANYDATA}
```
一般来说, 'data' 就是 任意[节点](https://github.com/kingfo/trinity/wiki/trinity_getting_started#wiki-node)发送过来的数据，Trinity 不会对 data 中的数据做特地的更改，当然，这数据中不能包含 `typeof` 为 'function' 的数据。

<a name="status" >status</a>
-----------------------------
当前[节点](https://github.com/kingfo/trinity/wiki/trinity_getting_started#wiki-node) fire() 数据成功(不一定抵达目标，但目标是存在的情况)的状态事件。<br/>
**status事件具备以下消息格式：**
```javascript
{type:'status',msg:MESSAGE, data:EXCHANGEDATA}
```

* `msg` 是状态代码同 status 对应。
* `data` 是个 [交换数据对象](#wiki-exchange-data) 。

<a name="error" >error</a>
---------------------------
当前[节点](https://github.com/kingfo/trinity/wiki/trinity_getting_started#wiki-node) fire() 数据失败的状态事件。一般情况下只有目标[节点](https://github.com/kingfo/trinity/wiki/trinity_getting_started#wiki-node)下线才会触发此事件。

**error事件具备以下消息格式：**
```javascript
{type:'error',msg:MESSAGE, data:EXCHANGEDATA}
```

<a name="exchange-data" >Exchange data</a>
------------------------------------------
交换数据对象。用于内部交换数据的固定格式，一般只有在 发送消息( 成功 或 失败) 时获得。

!!!_**注意**请不要将此数据用于二次传递。_!!!

  * `from` 交换数据来源名称，一般是当前节点。
  * `to`  发往的[节点](https://github.com/kingfo/trinity/wiki/trinity_getting_started#wiki-node)名。
  * `gateway` 当前[节点](https://github.com/kingfo/trinity/wiki/trinity_getting_started#wiki-node)的网关,即从属于的[主节点(master)](https://github.com/kingfo/trinity/wiki/trinity_getting_started#wiki-master)，一般和配置的[group](https://github.com/kingfo/trinity/wiki/trinity_external_parameters#wiki-group)参数一致。
  * `body` 当[节点](https://github.com/kingfo/trinity/wiki/trinity_getting_started#wiki-node)发送的数据。
  * `type` 当前[节点](https://github.com/kingfo/trinity/wiki/trinity_getting_started#wiki-node)类型。一般恒为 0 。