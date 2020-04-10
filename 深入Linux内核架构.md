

## ch2 进程管理

### 命名空间

参考：

https://www.cnblogs.com/beixiaobei/p/9317976.html

https://blog.csdn.net/zhangyifei216/article/details/49926459

https://www.cnblogs.com/hazir/p/linux_kernel_pid.html

pid框架的设计需要考虑如下问题：

1.如何通过task_struct快速找到pid

2.如何通过pid快速找到task_struct

3.如何快速分配唯一的pid



2.4版本的设计是一个进程对应一个pid

```c
struct task_struct
{
    .....
    pid_t pid;
    .....
}
```

但是只满足1，不能通过pid找task_struct。



改进之后引入了pid位图和hlist

```c
struct task_struct *pidhash[PIDHASH_SZ];
struct pidmap {
        atomic_t nr_free;  //表示当前可用的pid个数
        void *page;        //用来存放位图
};
```

改进后的基本框架如下

![这里写图片描述](https://img-blog.csdn.net/20151119161245926)

之后又引入了下面的机制

- **PID**：这是 Linux 中在其命名空间中唯一标识进程而分配给它的一个号码，称做进程ID号，简称PID。在使用 fork 或 clone 系统调用时产生的进程均会由内核分配一个新的唯一的PID值。
- **TGID**：在一个进程中，如果以CLONE_THREAD标志来调用clone建立的进程就是该进程的一个线程，它们处于一个线程组，该线程组的ID叫做TGID。处于相同的线程组中的所有进程都有相同的TGID；线程组组长的TGID与其PID相同；一个进程没有使用线程，则其TGID与PID也相同。
- **PGID**：另外，独立的进程可以组成进程组（使用setpgrp系统调用），进程组可以简化向所有组内进程发送信号的操作，例如用管道连接的进程处在同一进程组内。进程组ID叫做PGID，进程组内的所有进程都有相同的PGID，等于该组组长的PID。
- **SID**：几个进程组可以合并成一个会话组（使用setsid系统调用），可以用于终端程序设计。会话组中所有进程都有相同的SID。

```c
struct task_struct
{
    ....
    pid_t pid;
    pid_t session;  //会话
    struct task_struct *group_leader;//进程组leader
    ....
}

struct signal
{
    ....
    pid_t __pgrp;
    ....
}
```



之后引入了命名空间![这里写图片描述](https://img-blog.csdn.net/20151119161331708)

父命名空间可用看见子命名空间，但是反过来不可用。无论是父还是子命名空间，里面都有对应的局部位图。

pid现在开始变得复杂，包括该pid所在的命名空间，父命名空间，命名空间对应的pid，pidmap。

```c
enum pid_type
{
    PIDTYPE_PID,
    PIDTYPE_PGID,
    PIDTYPE_SID,
    PIDTYPE_MAX
};

struct pid
{
    unsigned int level; //这个pid所在的层级
    /* lists of tasks that use this pid */
    struct hlist_head tasks[PIDTYPE_MAX]; //一个hash表,又三个表头,分别是pid表头,进程组id表头,会话id表头,后面再具体介绍
    struct upid numbers[1]; //这个pid对应的命名空间,一个pid不仅要包含当前的pid,还有包含父命名空间,默认大小为1,所以就处于根命名空间中
};

struct upid {               //包装命名空间所抽象出来的一个结构体
    int nr;                 //pid在该命名空间中的pid数值
    struct pid_namespace *ns;       //对应的命名空间
    struct hlist_node pid_chain;    //通过pidhash将一个pid对应的所有的命名空间连接起来.
};

struct pid_namespace {
    struct kref kref;
    struct pidmap pidmap[PIDMAP_ENTRIES];   //上文说到的,一个pid命名空间应该有其独立的pidmap
    int last_pid;               //上次分配的pid
    unsigned int nr_hashed; 
    struct task_struct *child_reaper;   //这个pid命名空间对应的init进程,因为如果父进程挂了需要找养父啊,这里指明了该去找谁
    struct kmem_cache *pid_cachep;
    unsigned int level;         //所在的命名空间层次
    struct pid_namespace *parent;    //父命名空间,构建命名空间的层次关系
    struct user_namespace *user_ns;
    struct work_struct proc_work;
    kgid_t pid_gid;
    int hide_pid;
    int reboot; /* group exit code if this pidns was rebooted */
    unsigned int proc_inum;
};
//上面还有一些复杂的成员,这里的讨论占且用不到
```

为了统一管理，将pid,进程组id,会话id进行整合，引入了中间结构pid_link

```c
struct pid_link
{
    struct hlist_node node;
    struct pid *pid;
};


struct task_struct
{
    .............
    pid_t pid;
    struct pid_link pids[PIDTYPE_MAX];
    .............
}
struct pid
{
    unsigned int level; //这个pid所在的层级
    /* lists of tasks that use this pid */
    struct hlist_head tasks[PIDTYPE_MAX]; //一个hash表,又三个表头,分别是pid表头,进程组id表头,会话id表头,用于和task_struct进行关联
    struct upid numbers[1]; //这个pid对应的命名空间,一个pid不仅要包含当前的pid,还有包含父命名空间,默认大小为1,所以就处于根命名空间中
};
//使用pid的tasks hash表和task_struct中pids结构中的hlist_node关联起来了.
```

![这里写图片描述](https://img-blog.csdn.net/20151119162640491)

A B C都是一个进程组的，A组长进程。tasks[1]代笔进程组id表头，所以B C的task_struct中的pid_link中的node链接到A的tasks[1]

![img](https://images2018.cnblogs.com/blog/1168917/201807/1168917-20180716191827677-540475998.jpg)



深入架构的书笔记

传统上，内核管理一个全局的pid列表，调用者通过uname系统调用返回系统相关信息。uid=0为root用户，其余uid不同的不能互相影响但是可看到彼此。

![image-20200325224636472](C:\Users\10184\Desktop\Linux-Path\深入Linux内核架构.assets\image-20200325224636472.png)

这里命名空间组织为层次，每个命名空间都有自己的init进程，pid=0,相同的pid在系统中多次出现所以pid不是全局唯一。这里系统中有9个进程，但是有15个PID，说明一个进程可关联多个PID,但是哪个是正确的要取决于上下文。

如何创建新的命名空间？

fork或clone时有特定选项可用控制是否与父进程共享命名空间

创建之后如何从父进程分离？

unshare系统调用

如何实现？

1.子系统的命名空间结构，需要将此前的全局组件包含进去

2.将给定进程关联到所属各个命名空间的机制

![image-20200326115340571](C:\Users\10184\Desktop\Linux-Path\深入Linux内核架构.assets\image-20200326115340571.png)

UTS包含了运行内核的配置信息

mnt_namespace是装载 的文件系统的视图。