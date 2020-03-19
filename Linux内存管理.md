# Linux内存管理



参考 

> 深入理解linux内核
>
> linux内核设计与实现
>
> 奔跑吧linux内核
>
> https://ilinuxkernel.com
>
> mooc linux分析与应用



## 整体观

### 硬件结构

![image-20200130152244645](C:\Users\10184\AppData\Roaming\Typora\typora-user-images\image-20200130152244645.png)

MMU实现 虚拟->物理地址的转换，页表存在于主存。

TLB快表缓存了页表的表项，如果命中的话，就可以直接将虚拟地址转换为物理地址，如果不命中，则必须在页表中继续查找，并将找到的PTE存放到TLB中，覆盖已经存在的一个条目。 

缓存是为了解决cpu和慢速DRAM出现的。

访存缺页会使用swap。

### 软件架构

![image-20200130154207861](C:\Users\10184\AppData\Roaming\Typora\typora-user-images\image-20200130154207861.png)

task_struct里面有个mm_struct指针， 它代表进程的内存资源。pgd，代表 页表的地址； mmap 指向vm_area_struct 链表。 vm_area_struct 的每一段代表进程的一个虚拟地址空间。vma的每一段，都可能是可执行程序的某个数据段、某个代码段，堆、或栈。一个进程的虚拟地址，是在0～3G之间任意分布的。

![](C:\Users\10184\Desktop\abd59bdc58a3648bc30aede1f9feb737_1300x754.jpeg)

没有文件背景的页面，即**匿名页（anonymous page）**，如堆，栈，数据段等，不是以文件形式存在，因此无法和磁盘文件交换，但可以通过硬盘上划分额外的swap交换分区或使用交换文件进行交换。

Page Cache以Page为单位，缓存文件内容。缓存在Page Cache中的文件数据，能够更快的被用户读取。同时对于带buffer的写入操作，数据在写入到Page Cache中即可立即返回，而不需等待数据被实际持久化到磁盘，进而提高了上层应用读写文件的整体性能。

slab就相当于对象池，它将页面“格式化”成“对象”，存放在池中供人使用。当slab中的对象不足时，slab机制会自动从伙伴系统中分配页面，并“格式化”成新的对象。



## 内存寻址

### 三种地址

> 逻辑地址：指定一个指令或操作数的地址，有segment和offset构成
>
> 线性地址：由逻辑地址通过segment unit电路转换得到
>
> 物理地址：由线性地址通过paging unit电路转换得到
>
> ![image-20200130162200772](C:\Users\10184\AppData\Roaming\Typora\typora-user-images\image-20200130162200772.png)

![](C:\Users\10184\Desktop\TIM图片20200130153145.png)

### 单/多处理器系统

> 多处理器中，所有cpu共享同一内存，因此产生了内存仲裁器。
>
> 但是单处理器也需要，因为它包含DMA，与cpu并发操作。

### 硬件分段

> 逻辑地址 = segment selector（16位） + offset （32位）
>
> segment selector的结构<img src="C:\Users\10184\AppData\Roaming\Typora\typora-user-images\image-20200130162059677.png" alt="image-20200130162059677" style="zoom:50%;" />
>
> RPL表示请求者特权级
>
> TI选择GDT/LDT/....
>
> 段寄存器cs,ss,es,ds,fs,gd存放 segment selector,其中cs包含一个CPL字段，0最高优先级，3最低优先级。
>
> 段描述符，存放在GDT/LDT中，即段表项。
>
> GDT/LDT在主存中的地址和大小存放在gdtr/ldtr寄存器中。

### 快速访问段描述符

> x86提供了附加的非编程寄存器，每当segment selector装入段寄存器中，对应的段描述符就转入非编程寄存器，除非段寄存器内容改变，才访问gdt/ldt。

### 逻辑地址转换

> 1. 检测segment selector的TI字段确定段描述符保存在gdt/ldt
> 2. 根据segment selector的index计算段描述符的地址, index*8+gdt/ldt
> 3. 段描述符的base+offset
> 4. 前两项只有当段寄存器内容改变才执行

### Linux的分段

> 四个段描述符的宏
>
> ```c
> __USER_CS
> __USER_DS
> __KERNEL_CS  //唯一一个在内核态执行
> __KERNEL_DS
> ```
>
> 每个CPU对应一个GDT，所有的gdt存放在cpu_gdt_table数组，所有gdt地址和大小存于cpu_gdt_descr(用于初始化)









