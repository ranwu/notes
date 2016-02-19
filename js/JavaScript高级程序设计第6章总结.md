ECMA-262 把对象定义为：“无序属性的集合，其属性可以包含基本值、对象或或者函数”。严格来讲，这就相当于说对象是一组没有特定顺序的值。

创建对象最简单的方式是创建一个Object实例，然后再为它添加属性和方法：

```javascript
var person = new Object();
person.name = "Nicholas";
person.age = 29;
person.job = "Software Engineer";

person.sayName = function() {
    alert(this.name);
};
```

对象字面量创建对象
```javascript
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

```javascript
var person = {
    name: "Nicholas"
};
```
看到这个例子，这里创建了一个名为name的属性为它指定的值是“Nicholas”。也就是说，`[[Value]]` 特性将被设置为 “Nicholas”，而对这个值的任何修改都将反映在这个位置上。

要修改属性的默认特性，必须使用 ECMAScript5 的 `Object.defineProperty()` 方法。这个方法接受两个参数：**属性所在的对象**、**属性的名字**和一个**描述对象**。其中描述符（descriptor）对象的属性必须是：`configurable`、`enumerable`、`writeable`和`value`。设置其中的一个或多个值，可以修改对应的特性值。例如：

```javascript
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

```javascript
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

### 访问器属性

访问器属性不包含数据值，它们包含一对 `getter` 和 `setter` 函数，在读取访问器属性时，会调用 `getter` 函数，这个函数负责返回有效的值。在写入访问器属性时，会调用 `setter` 函数并传入新值，这个函数负责决定如何处理数据。访问起的4种特性：

- `[[Configurable]]` 和上文一样的意思。
- `[[Enumerable]]` 和上文一样的意思。
- `[[Get]]` 在读取属性时调用的函数。默认值为 `undefined`。
- `[[Set]]` 在写入时调用的函数。默认值为 `undefined`。

访问起也必须使用 `Object.defineProperty()` 函数来定义。例子：

```javascript
var book = {
    _year: 2004,
    edition: 1
};

Object.defineProperty(book, "year", {
    get: function() {
        return this._year;
    },
    set: function(newValue) {
        
        if (newValue > 2004) {
            this._year = newValue;
            this.edition += newValue - 2004
        }
    }
    });

book.year = 2005;
alert(book.edtion); // 2
```

访问器属性也是针对对象的属性的特性的。比如，有个 `book` 对象，属性分别为：`_year: 2004`，`edition: 1`。在这个 `get` 和 `set` 方法中，我们可以为它指定任何方法。这样一来，当我们想访问某个对象属性的时候，系统会自动调用访问器属性 `get` ，然后，也就是执行 `get`对应的函数来返回预定的值。当我们想给对象的属性设置值的时候，就使用访问器属性 `set` 对应的函数来返回预定的值。

给对象设置访问器属性的好处就是以更原生的方式定义对象属性的 `get` 和 `set` 函数。这样以来，如果我想给某个对象的属性赋予一个新的值，我不会去通过调用自己定义的 `get` 和 `set`方法，而是去使用 `=` 号来设置属性的值，以 `对象.属性` 的方式来访问属性的值，当然底层的实现方式就是我们所讲的*访问器属性*。

`_year` ，像这种情况，这个变量的前面有一个下划线，用于表示只能通过对象方法访问的属性。即是 `get` 和 `set`。

使用访问器属性的常见方式：即设置一个值会导致其他属性发生变化（不仅仅是被设置的那个属性）。

还要说明的是，如果你只指定 `getter` 属性，而不指定 `setter` 属性，那么意味着你不能设置属性的值。相反，如果只指定 `setter` 而不指定 `getter` 那么你就不能读取属性的内容。这两种情况在非严格模式下都会返回 `undefined` 。

支持ECMAScript5的这个方法的浏览器有IE9+、FireFox4+、Safari5+、Opera12+、和Chrome。在这些浏览器版本号之前如果要创建访问器属性，一般都使用两个非标准方法，`__defineGetter__()` 和 `__defineSetter__()`。如果需要设置那些旧版本的访问器属性，可以这么做：

```javascript
var book = {
    _year: 2004,
    edition: 1
};

// 定义访问器的旧有方法
book.__defineGetter_("year", function() {
    return this._year;
    });

book.__defineSetter__("year", function(newValue) {
    if (newValue > 2004) {
        this._year = newValue;
        this.edition += newValue - 2004;
    }
    });
```

看起来这个两个不同实现方式的访问器属性的`setter` 和`getter` 特性的本质都是一样的。只不过实现的方式不一样。原生的方法给人的感觉更精炼，非官方的实现版本给人的感觉有点分散。

### 定义多个属性

ECMAScript5提供了给对象定义多个属性的方法，这个方法接受两个对象，一个是你要操作的对象，比如我要对 `book` 对象添加属性，另一个对象是属性值列表，这个属性值列表本身就是一系列健值对的集合。实现方式：

```javascript
// 定义一个book对象
var book = {};

Object.defineProperties(book, {

    // 添加属性
    _year: {
        value: 2004;
    },

    edition: {
        value: 1
    },

    year: {
        get: function() {
            return this._year;
        },

        set: function(newValue) {
            if (newValue > 2004) {
                this._year = newValue;
                this.edition += newValue - 2004;
            }
        }
    }
    });

```

看到上面这个程序，我们发现：对象的属性的本质实际上就是键值对，而其中的值，可以是对象，可以是数据，也可以是函数。并且非常灵活，你看 `year` 属性下面就是一个对象，这个对象又包含了两个方法，一个是 `set`，另一个是 `get` 。回到原题，如果我们将对象经过上文的这一列的设置，可以达到给对象添加任意个属性、方法的效果。这就是给对象设置属性的方法之一。

我还发现，`Object.defineProperty()` 方法可以用来修改某属性，而 `Object.defineProperties()` 则是用来在初始化一个对象的属性的时候使用。

### 读取属性的特性

用ECMAScript5的 `Object.getOwnPropertyDescriptor` 可以取得属性的描述符。其实，一个属性分为数据属性和访问器属性，数据属性就是说这个属性的描述符（也就是对象属性的属性）为`configurable`、`enumerable`、`writable` 和 `value`。访问器属性（也是对象属性的属性）为`configurable`、`enumerable`、`set`、`get`

```javascript
var book = {};

Object.defineProperties(book, {
    _year: {
        value: 2004
    },

    edition: {
        value: 1
    },

    year: {
        get: function() {
            return this._year;
        },

        set: function(newValue) {
            if (newValue > 2004) {
                this._year = newValue;
                this.edition += newValue - 2004;
            }
        }
    }
    });

var descriptor1 = Object.getOwnPropertyDescriptor(book, "_year");
alert(descriptor.value); // 2004
alert(descriptor.configurable); // false
alert(typeof descriptor.get); // "undefined"

var descriptor2 = Object.getOwnPropertyDescriptor(book, "year");
alert(descriptor2.value); // undefined
alert(descriptor2.unumerable); // false
alert(typeof descriptor.get); // function
```

看到上面的代码，如果属性的描述符为数据属性，那么默认情况下，这个属性的 `configurable` 为 `false` , 也就是说，当我们给对象的属性赋予一个值的时候，除了它的 `writable` 描述符可用外，其余的`Configurable`、`Enumerable` 属性都为 `false`。由于`_year`属性为数据属性，当然也就没有设置 get 方法了。所以，当打印它的`get` 数据类型的时候，显示为 `undefined`。

当自己定义给属性定义 `get` 方法的时候，这个 `get` 只是一个变量，存储着指向 `getter` 的指针; `set` 方法同样如此。

在 `JavaScript` 中可以针对任何对象（包括DOM和BOM对象）使用 `Object.getOwnPropertyDescriptor()` 方法。就像上文所讲的那样。

### 创建对象

**工厂模式：**
这种模式抽象了创建具体对象的过程。也就是说，我们创建对象，只需要用它的API来创建即可。这也是一种常见的设计模式。比如我想构建一个对象，一般用 `var obj = new Object()` 就可以了。但是，我需要的是自定义对象，并且对象名也不一样。这时候就需要手动封装一个对象：

```javascript
function createPerson(name, age, job) {
    var o = new Object();
    o.name = name;
    o.age = age;
    o.job = job;
    o.sayName = function() {
        alert(this.name);
    };
    return o;
}

var person1 = createPerson("Nicholas", 29, "Softwar Engineer");
var person2 = createPerson("Greg", 27, "Doctor");
```

看到上面的例子，这种基于工厂模式的对象创建方式和函数的构造方式是差不多的。首先用 `function` 来构造一个函数，并取名为 `createPerson`。我们给这个函数传入了三个参数，分别为代表人的属性的 `name`，`age`， `job` 。在函数内部，我们用基本函数 `Object()` 来创建创建对象，我觉得这个函数的目的就是创建一个“空”对象，然后，你再往这个对象里添加各种方法。然后就可以用`对象.属性` 的格式来添加属性了。当然，可以添加JavaScript中任意类型的数据。最后直接用 `return` 语句返回这个对象。

其实，用工厂模式来描述这个过程非常形象，工厂就是一个黑盒子，就是一个函数，我们不在乎这个黑盒子的运作方式，我们只管最后需要的结果就行了。

**工厂模式解决了这样一个需求：我想创建很多个相似的对象**。

---

### 构造函数模式

又有一个新需求，我想知道对象的类型怎么办？

我们可以使用原生构造函数，比如像 `Object`，`Array` 这样的。上文的工厂模式就是在一个函数下面使用了 `Object` 构造函数。好，我们使用自定义构造函数：

```javascript
function Person(name, age, job) { // 注意，构造函数名称第一个字母大写
    this.name = name;
    this.age = age;
    this.job = job;
    this.sayName = function() {
        alert(this.name);
    };
}

var person1 = new Person("Nicholas", 29, "Software Engineer");
var person2 = new Person("Greg", 27, "Doctor");
```

构造函数要经历的4个创建步骤：

1. 创建一个新对象;
2. 将构造函数的作用域赋给新对象（因此this就指向了这个新对象）
3. 执行构造函数中的代码（为这个新对象添加属性）
4. 返回新对象

每个通过构造函数创建的对象都有一个 `construcotor` （构造函数）属性。该属性指向构造函数名。

就拿上文的例子来说，其中创建的两个 person 对象都有一个`constructor`属性，这个属性就指向 `Person` 这个构造函数，这样是不是就可以辨别对象类型呢？只要查看每个对象的 `constructor` 属性即可。其实更常用的检测对象类型的方式是 `instanceof`。

以这种方式定义的构造函数是定义在`Global`对象中（浏览器是window）。

对于任何函数，只要通过 `new` 操作符来调用，那它就可以作为构造函数。

不同实例上的同名函数是不相等的。

证明：

```javascript
alert(person1.sayName == person2.sayName); // false
```

然而，创建两个完成同样任务的Fucntion实例的确没有必要。况且有 `this` 对象的存在，根本不用在执行代码前就把函数绑定到特定对象上面。因此，可以把函数转移到外部来解决问题。

```javascript
function Person(name, age, job) {
    this.name = name;
    this.age = age;
    this.job = job;
    this.sayName = sayName;
}

function sayName() {
    alert(this.name);
}

var person1 = new Person("Nicholas", 29, "Software Engineer");
var person2 = new Person("Greg", 27, "Doctor");
```

由于`sayName`保存的只是指向其函数的指针，所以，不管有多少对象，都可以调用这个函数，而不是每个对象都要创建一个函数对象。

---

### 原型模式


