



## Ch11

new : 分配空间+构造

delete:先析构 再收回空间

delete [] :说明不止一个对象，要调用所有对象的析构，但是二者都收回所有空间





## Ch12

private:只有类的成员函数才能访问，仅仅在编译时检查，运行时不用。 

protected:只允许子类及本类的成员函数访问

同一个类的对象之间可以互相访问私有变量

friend声明之后可以访问private