 API:Trinity External Interface
===================================
<a name="fire" >fire(data[,to])  <void>;</a>  
--------------------------------------------
向本地同一个应用网络广播。无返回值。
 
*  `data  <any>`
  * 除 `typeof` 为 `function` 外，任何数据都可以通过此接口进行组内广播。
* _option_ : `to  <String>`
   * 指定仅将消息传递给本地网络中任意一个节点。

<a name="getItem" >getItem(key) <any>;</a>
--------------------------------------------
获取本地存储的数据。返回值除 `typeof` 为 `function` 外的任何值。

* `key <String>`
  * 指定的键值，如果不存在则返回 `null`。

<a name="setItem" >setItem(key,value) <void>;</a>
--------------------------------------------------
存储本地存储数据。

* `key <String>`
 * 指定的键值。
* _option_ : `value <any>`
  * 当 `value` 为 `null` 时，则会删除该 `key` 和 `value`，类似通常会用到的 `remove(key)`;
  * 可以是除 `typeof` 为 `function` 外任何值。

<a name="connect" >connect() <void>;</a>
----------------------------------------
重新连接
无返回值


 