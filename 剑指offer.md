

## 基础



### cpp

题型1

sizeof求空类型的大小 结果是 1.

原本应该是0，但是声明时需要占据一定空间，否则无法使用这些实例，占用大小由编译器决定。

在上面的基础上添加构造和析构，sizeof仍然是1

因为调用构造析构只需知道函数地址，地址只与类型有关，与实例无关。

如果是虚析构函数，sizeof根据情况变化

c++编译器会为含虚函数类型的生成虚函数表，并在该类型的每个实例中添加指向虚函数表的指针，32位占4字节，64位占8字节



题型2

运行结果

<img src="C:\Users\10184\Desktop\Linux-Path\剑指offer.assets\image-20200328090916092.png" alt="image-20200328090916092" style="zoom:50%;" />

这里复制构造函数传的参数是A的实例，传值而不是传引用。将形参复制到实参会调用赋值构造函数，从而形成递归调用导致栈溢出。A(const A& other)才行。



### 面试题1

![image-20200328091412689](C:\Users\10184\Desktop\Linux-Path\剑指offer.assets\image-20200328091412689.png)

考虑如下细节：

1.返回值类型是否为该类型的引用

2.传入的参数类型是否为常量引用

3.是否释放自身已有内存

4.是否是同一个实例



经典解法

```c++
CMyString& CMyString::operator=(const CMystring& str) {
    if (str == &this)
        return *this;
    delete[]m_pData;
    m_pData = nullptr;

    m_pData = new char[strlen(str.m_pData) + 1];
    strcpy(m_pData, str.m_pData);

    return *this;
}
//delete之后还置空是因为，delete只是释放了指针所指的内存空间，
//指针所占内存没释放。delete之后指针所指向的区域不变，没有清零。
```

进阶（考虑安全性）

如果内存不足 new char抛出异常，m_pData就是空指针，导致崩溃。

可先用new分配新内容再用delete释放已有内容。或者更好的办法是先创建临时实例再交换。

![image-20200329093318752](C:\Users\10184\Desktop\Linux-Path\剑指offer.assets\image-20200329093318752.png)

这里的优点是strTemp是临时量，出了if就会被自动释放。



## 数据结构



### 数组

当数组作为函数参数进行传递时，数组就会自动退化为同类型指针。

数组 和 指针没有联系



### 面试题3

![image-20200329094107670](C:\Users\10184\Desktop\Linux-Path\剑指offer.assets\image-20200329094107670.png)

思路1 ： 排序 o(nlogn)

思路2： 哈希表 o(n) 但是空间复杂度高

思路3： 数字范围在0 - n-1， 如果没有重复数字，那么数字i将会出现在下标i的位置。

```c++
#define SWAP(a,b) do{a^=b;b^=a;a^=b;}while(0)

bool duplicate(int numbers[], int length, int* duplication) {
    if (numbers == nullptr || length <= 0)
        return false;
    for (int i = 0; i < length; ++i)
        if (numbers[i]<0 || numbers[i]>length - 1)
            return false;  //数字范围 0- n-1
    for (int i = 0; i < length; ++i) {
        while (numbers[i] != i) {
            if (numbers[i] == numbers[numbers[i]]) {
                *duplication = numbers[i];
                return true;
            }
            SWAP(numbers[i], numbers[numbers[i]]);
        }
    }
    return false;
}
```



![image-20200329101058397](C:\Users\10184\Desktop\Linux-Path\剑指offer.assets\image-20200329101058397.png)