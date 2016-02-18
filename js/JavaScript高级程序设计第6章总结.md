ECMA-262 把对象定义为：“无序属性的集合，其属性可以包含基本值、对象或或者函数”。严格来讲，这就相当于说对象是一组没有特定顺序的值。

创建对象最简单的方式是创建一个Object实例，然后再为它添加属性和方法：

```
var person = new Object();
person.name = "Nicholas";
person.age = 29;
person.job = "Software Engineer";

person.sayName = function() {
    alert(this.name);
};
```

对象字面量创建对象
```
var person = {
    name: "Nicholas",
    age: 29,
    job: "Software Engineer",
    
    SayName: function() {
        alert(this.name);
    }
}
```

对象就是用大括号阔起的一系列键值对，JavaScritp用键值对中的值表示对象的属性。对象的属性可以是数据，也可是方法。

ECMAScript中有两种属性：数据属性和访问器属性，数据属性包含一个数据值的位置，这个位置可以读取和写入。数据属性有4种描述其行为的特性：

1. `[[Configurable]]`: 表示能否通过 delete 删除属性从而重新定义属性。能否修改属性的特性。或者能否把属性修改为访问器属性。像前面例子中那样直接在对象上定义的属性 —— `person.name = "Nicholas"` 也就是说像这个样子的，就说明它们的 `[[Configurable]]` 特性为 `true`。
2. `[[Enumerable]]`: 表示能否通过 `for-in` 循环返回属性。像直接在对象上定义的属性，他们的这个特性为 `true`。
3. `[[Writable]]`: 表示能否修改属性的值。像前面那个例子直接在对象上定义属性，说明是可以修改属性的值的。
4. `[[Value]]`: 包含这个属性的数据值。读取属性值的时候从这个位置开始读取。写入属性值的时候，把新值保存在这个位置。这个特性的默认值为 `undefined`。

一般来说，如果我们使用 `Object()` 来创建对象，比如：`var person = new Object();` 。那么这个对象的数据属性默认行为是：`[[Configurable]]`、`[[Enumerable]]`、`[[Writable]]`、这三个行为的默认值都为 `true`，也就是说，我们才可以给对象定义属性，才能使用 `for-in` 循环来返回属性，才拥有权限来修改属性的值。而 `Value`，则是用来存储属性的数据值。

例如：

```
var person = {
    name: "Nicholas"
};
```
看到这个例子，这里创建了一个名为name的属性为它指定的值是“Nicholas”。也就是说，`[[Value]]` 特性将被设置为 “Nicholas”，而对这个值的任何修改都将反映在这个位置上。

要修改属性的默认特性，必须使用 ECMAScript5 的 `Object.defineProperty()` 方法。这个方法接受两个参数：**属性所在的对象**、**属性的名字**和一个**描述对象**。其中描述符（descriptor）对象的属性必须是：`configurable`、`enumerable`、`writeable`和`value`。设置其中的一个或多个值，可以修改对应的特性值。例如：

```
var person = {};
Object.defineProperty(person, "name", {
    writeable: false,
    value: "Nicholas"
    });

alert(person.name); // "Nicholas"
person.name = "Greg";
alert(person.name); // "Nicholas"
```

由于我们给 `name` 的 `[[Writeable]]` 特性设置为 `false` ，所以，当我们试图为 `person.name` 设置为新值 `Greg` 的时候，没有生效，打印出来的结果还是 `Nicholas`。

这个功能有什么用呢？我觉得在代码安全方面应该有勇武之地。目前来说，我不知道哪些代码需要这样设置，但我知道如果想给某个对象的属性的特性时，就可以使用 `Object.defineProperty()` 函数。

如果把 `configurable` 设置为 `false`，表示不能从对象中删除属性。如果对这个属性调用 `delete` 则在非严格模式下什么也不会发生，否则则会发生错误。

而且，一旦把属性定义为不可配置的，就不能再把它变回可配置的了。想想也是，修改的目的就是为了不可配置，本来就不可配置了，你再想去配置，那显然是不行的。此时，如果再调用 `Object.defineProperty()`方法修改除 `writeable` 之外的特性，都会导致错误。

```
var person = {};
Object.defineProperty(person, "name", {
    configurable: false,
    value: "Nicholas"
    });

// 抛出错误
Object.defineProperty(person, "name", {
    configurable: true,
    value: "Nicholas"
    });

```

还要记住，在调用 `Object.defineProperty()` 这个函数时，如果什么参数也不给，那么 `Enumerable`、 `Writeable`、`Configurable` 着三个参数的值都为 `false`

