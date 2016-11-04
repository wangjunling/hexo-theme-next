---
title: java8新特性
date: 2016-11-04 14:00:08
tags: java8
categories: java
---
### 接口的默认方法和静态方法
在接口中定义默认方法和静态方法：
```
public interface DefaultInterface{

    default void defaultFun(){
        System.out.println("default function!");
    }
    static void staticFun(){
        System.out.println("static function!");
    }
}
```
特点：
**
1.这两种方法的定义必须要有具体实现。
2.默认方法可以被实现类直接使用，也可以被实现类重写。
3.静态方法只能通过接口名调用。
**
代码如下：
```
public class DefaultImpl implements DefaultInterface{
    @Override
    public void defaultFun(){
        System.out.println("override implementation");
    }
}
public class Index {
    public static void main(String[] args){
        DefaultInterface.staticFun();

        DefaultInterface defaultInterface = new DefaultInterface() {};
        defaultInterface.defaultFun();

        DefaultInterface defaultInterface2 = new DefaultImpl();
        defaultInterface2.defaultFun();
        //DefaultImpl.staticFun();//无法调用
    }
}
```
打印结果：
```
static function!
default function!
override implementation
```
### Lambda表达式

Lambda允许把函数作为一个方法的参数（函数作为参数传递进方法中），也就是我们所说的函数式编程。
其原理就是利用一个只有一个方法的接口（也就是函数式接口），new一个匿名类调用其中的唯一方法。
如下代码，callMethod方法定义是直接调用FunctionInterface.method();所以在调用callMethod方法的时候，参数可以直接new一个FunctionInterface，写好method的实现。此时也就是相当于我们将method方法直接传递给callMethod方法了。
```
public interface FunctionInterface {
	void method();
}
public class Index {
  public static void callMethod(FunctionInterface functionInterface){
    functionInterface.method();
  }
  public static void main(String[] args) {

    callMethod(new FunctionInterface() {
        @Override
        public void method() {
          System.out.println("function interface");
        }
      });
    }

}
```
但是上边调用callMethod方法的代码看起来比较乱，比较难看，所以我们可以用Lambda表达式：
```
public class Index {
	public static void main(String[] args) {

		callMethod(() -> System.out.println("function interface"));
	}
}
```
现在我们来看一个例子,这是一个循环打印一个list的代码，利用forEach方法。
```
Arrays.asList( "p", "k", "u","f", "o", "r","k").forEach(new Consumer<String>() {
  @Override
  public void accept(String s) {
    System.out.println(s);
  }
});
```
如果用Lambda表达式
```
Arrays.asList( "p", "k", "u","f", "o", "r","k").forEach((String s) -> System.out.println(s) );
```
还可以更简洁
```
Arrays.asList( "p", "k", "u","f", "o", "r","k").forEach( s -> System.out.println(s) );
```
Java编译器能够自动识别参数的类型，所以你就可以省略掉类型不写。

### 函数式接口
函数式接口就是一个有且只有一个抽象方法的接口。也就是函数式接口也可以有默认方法和静态方法，如：
```
public interface FunctionInterface {
	void method();
}
```
任何只有一个抽象方法的接口都可以做成Lambda表达式，所以为了保证你的接口可以用Lambda表达式，你应该给接口添加一个@FunctionalInterface注解，这个注解加上去之后，如果接口中定义了第二个抽象方法的话，编译器就会抛异常。
```
@FunctionalInterface
public interface FunctionInterface {
	void method();
}
```
### 方法和构造函数引用
Java 8 允许你通过::关键字获取方法或者构造函数的的引用
静态方法：
如下，DefaultInterface::staticFun返回一个函数引用，相当于js中的闭包，由于staticFun是无参数也无返回值，所以可以用Runnable来接收。当调用staticFun.run();的时候，才真正调用了staticFun方法。
```
public interface DefaultInterface{
    static void staticFun() {
        System.out.println("static function!");
    }
}
public class Index {
    public static void main(String[] args){
		Runnable staticFun = DefaultInterface::staticFun;
		staticFun.run();
    }
}
```
构造方法：
定义一个student类
```
public class Student {
	private String name;
	private String sex;

	public Student(String name, String sex) {
		this.name = name;
		this.sex = sex;
	}
}
```
Student:new会返回Student构造方法的引用，此方法需要有两个String参数，返回Student对象，所以我新建一个StudentConstructor函数式接口：
```
@FunctionalInterface
public interface StudentConstructor<P extends Student> {
	P create(String name,String sex);
}
```
现在可以这样调用
```
StudentConstructor<Student> constructor = Student::new;
constructor.create("a","男");
```
### 内置函数式接口
1.Runnable
无参数，无返回值
例如
```
public interface DefaultInterface{
    static void staticFun() {
        System.out.println("static function!");
    }
}
public class Index {
    public static void main(String[] args){
		Runnable staticFun = DefaultInterface::staticFun;
		staticFun.run();
    }
}
```
结果：
`static function!`
2.Consumer
有一个参数，无返回值
```
Consumer<String> greeter = (p) -> System.out.println("Hello, " + p);
greeter.accept("DoubleKill");
```
3.Predicate
有一个参数，返回布尔类型
```
Predicate<String> predicate = (s) -> s.length() > 0;
predicate.test("foo");              // true
```
像一些判断的方法都属于这种类型如
```
Predicate<Boolean> nonNull = Objects::nonNull;
Predicate<Boolean> isNull = Objects::isNull;

Predicate<String> isEmpty = String::isEmpty;
Predicate<String> isNotEmpty = isEmpty.negate();
```
4.Supplier
无参数，有返回值
5.Function
有一个参数，有返回值
6.UnaryOperator
无参数，有返回值，返回值还是一个UnaryOperator



### 时间日期API
### 重复注解
