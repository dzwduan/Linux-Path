## Ch1 Linux内核简介

## Linux vs Unix

### Unix

> 不可分割的静态可执行库，需要硬件提供MMU管理内存
>
> Linux
>
> 最新的简单嵌入式系统也需要

### 单内核 vs 微内核

> 单内核：从整体上作为一个大过程来实现，运行在一个单独地址空间，内核间通信不重要，内核可以直接调用函数，Unix大多数设计为单内核
>
> 微内核：功能被划分为多个独立过程，每个过程叫做一个服务器，服务器运行在特权模式或用户空间，所有服务器独立运行在自己的空间上。不能直接调用函数，通过消息传递处理微内核通信，采用了IPC（进程间通信）机制。
>
> Linux是单内核，但同样采用了微内核设计。



## Ch3 进程管理

> 进程：执行期程序
>
> 线程：进程中活动的对象，每个进程含 1个程序计数器+进程栈+1组进程寄存器，是内核调度的对象
>
> Linux对线程进程不特别区别

> 进程提供的虚拟机制：
>
> 虚拟处理器：使得进程感觉自己独享处理器
>
> 虚拟内存：是的进程感觉拥有所有内存资源
>
> 线程之间可共享虚拟内存，但各自拥有自己的虚拟处理器

### 进程创建过程

> 调用fork(),复制一个现有进程来创建一个全新进程，fork()返回两次，一次父进程一次子进程。
>
> （调用的是父，新产生的是子）
>
> 调用exec()创建新的地址空间
>
> exit()系统调用退出执行，终结进程并将其占用的资源释放
>
> 退出执行后进程被设定为僵死状态直到父进程调用wait()和waitpid()

> 进程描述符 <linux/sched.h>
>
> 进程存放在双向循环链表中，表中每一项都是task_struct类型
>
> ```c
> struct task_struct {
> 	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
> 	struct thread_info *thread_info;
> 	atomic_t usage;
> 	unsigned long flags;	/* per process flags, defined below */
> 	unsigned long ptrace;
> 
> 	int lock_depth;		/* BKL lock depth */
> 
> 	int prio, static_prio;
> 	struct list_head run_list;
> 	prio_array_t *array;
> 
> 	unsigned long sleep_avg;
> 	unsigned long long timestamp, last_ran;
> 	unsigned long long sched_time; /* sched_clock time spent running */
> 	int activated;
> 	//....省略
> ```

### 分配进程描述符

> 使用了Slab分配器来分配task_struct结构
>
> slab分配器中用到了对象这个概念，所谓对象就是内核中的数据结构以及对该数据结构进行创建和撤销的操作。它的基本思想是将内核中经常使用的对象 放到高速缓存中，并且由系统保持为初始的可利用状态。比如进程描述符，内核中会频繁对此数据进行申请和释放。当一个新进程创建时，内核会直接从slab分配器的高速缓存中获取一个已经初始化了的对象；当进程结束时，该结构所占的页框并不被释放，而是重新返回slab分配器中。如果没有基于对象的slab分 配器，内核将花费更多的时间去分配、初始化以及释放一个对象。
>
> slab分配器有以下三个基本目标：
>
> 1.减少伙伴算法在分配小块连续内存时所产生的内部碎片；
>
> 2.将频繁使用的对象缓存起来，减少分配、初始化和释放对象的时间开销。
>
> 3.通过着色技术调整对象以更好的使用硬件高速缓存；
>
> ```c
> struct thread_info {
> 	struct pcb_struct	pcb;		/* palcode state */
> 
> 	struct task_struct	*task;		/* main task structure */
> 	unsigned int		flags;		/* low level flags */
> 	unsigned int		ieee_state;	/* see fpu.h */
> 
> 	struct exec_domain	*exec_domain;	/* execution domain */
> 	mm_segment_t		addr_limit;	/* thread address space */
> 	unsigned		cpu;		/* current CPU */
> 	int			preempt_count; /* 0 => preemptable, <0 => BUG */
> 
> 	int bpt_nsaved;
> 	unsigned long bpt_addr[2];		/* breakpoint handling  */
> 	unsigned int bpt_insn[2];
> 
> 	struct restart_block	restart_block;
> };
> ```
>
> task_struct存放在内核栈尾端，栈指针就能计算出位置

### 进程描述符的存放

> 内核通过唯一的进程标识符或pid（max=32768,short int的最大值）标识，最大值代表了允许同时存在的进程的最大数目。
>
> 通过current宏找到当前正在运行进程的进程描述符，x86系统上，currenet屏蔽了栈指针后13位用来计算thread_info,通过current_thread_info()
>
> ```asm
> movl $-8192,%eax  ;2^13
> andl %esp,%eax
> ```
>
> 最后通过current_thread_info()->task提取并返回task_struct地址

### 进程状态

> state域描述了进程当前状态，5种状态
>
> 1.TASK_RUNNING，可执行态，正执行/等待执行
>
> 2.TASK_INTERRUPTIBLE，可中断态，阻塞
>
> 3.TASK_UNINTERRUPTIBLE，不可中断态，接收到信号也不会被唤醒或投入运行，其他同可中断
>
> 4.__TASK_TRACED，被其他进程跟踪的进程
>
> 5.__TASK_STOPPED，停止运行，没投入也不能投入运行

### 设置当前进程状态

> ```c
> set_task_state(task,state);//将task状态设为state
> set_current_state(state);//同上
> ```

### 进程上下文

> 进程只有通过系统调用和异常处理接口才能陷入内核执行

### 进程家族树

> 所有进程都是 PID为1的init进程的后代，内核在系统启动的最后阶段启动init进程 。该进程读取系统的初始化脚本，完成系统的整个启动过程。
>
> 每个进程必有一个父进程，可有0或多个子进程。进程间关系存放在进程描述符，partent指针指向父进程，children为子进程链表。
>
> 获取父进程的进程描述符
>
> ```c
> struct task_struct *my_parent = current->parent;
> ```
>
> 依次访问子进程
>
> ```c
> struct task__struct *task;
> struct list_head *list;   //children为子进程链表
> 
> list_for_each(list,&current->children)
> {
>  task=list_entry(lilst,struct task_struct,sibling); //task指向当前某子进程
> }
> ```
>
> init进程的进程描述符作为init_task静态分配
>
> ```c
> struct task_struct *task;
> for(task=current;task!=&init_task;task=task->parent)
>  //task最终指向init
> ```
>
> 任务队列是双向循环链表，因此方便获取任意指定其他进程。
>
> 对于给定进程获取链表的下一个进程
>
> ```c
> list_entry(task->tasks.next,struct task_struct,tasks)
> ```
>
> 对于给定进程获取链表的上一个进程
>
> ```c
> list_entry(task->tasks.prev,struct task_struct,tasks)
> ```
>
> 访问整个任务队列
>
> ```c
> struct task_struct *task;
> for_each_process(task){
>  printk("%s[%d]\n",task->comm,task->pid);
> }
> ```
>
> 

### 上面出现的宏

> ```c
> //list_entry
> #define list_entry(ptr, type, member) /
> ((type *)((char *)(ptr)-(unsigned long)(&((type *)0)->member)))
> 
> //理解
> //&((type*)0)->member,将0强转为指针类型，指针就指向了数据段基地址。因为指针为type*类型，所以可以取到
> //以0为基址的一个type型变量的member域地址，即为member到结构体基地址的偏移字节。
> //(char*)(ptr)使得 加减操作为一个字节
> //(unsigned long)(&(type *)0)->member)))
> //ptr是容器变量的指针，减去自己在容器中的偏移量的值即为容器指针
> ```
>
> ```c
> //list_for_each
> #define list_for_each(pos, head) \
> for (pos = (head)->next; pos != (head); pos = pos->next)
> ```

### 进程创建

> Unix的进程创建分解到两个函数fork()和exec()
>
> fork()拷贝当前进程创建一个子进程
>
> exec()负责读取可执行文件并将其载入地址空间开始运行

### 写时拷贝

> copy-on-write，不复制整个进程地址空间而是让父进程和子进程共享同一个拷贝。
>
> 需要写入才会进行，在此之前都是只读方式共享。
>
> 开销：复制父进程的页表+给子进程创建唯一的进程描述符

### fork()

> 通过clone()系统调用实现fork()。
>
> fork(),vfork(),__clone()库函数都是调用clone(),再由clone()去调用do_fork()
>
> do_fork()完成了创建中的大部分工作，他调用copy_process()然后让进程开始运行

copy_process()完成的工作

> 1.调用dup_task_struct()为新进程创建一个内核栈，thread_info和task_struct,值都与当前进程相同。父子进程描述符相同。
>
> 2.检查进程数目是否超过资源限制
>
> 3.区别父子进程。进程描述符的许多成员被清0或设为初始值
>
> 4.子进程被设置为TASK_UNINTERRUPTIBLE,确保不会投入运行
>
> 5.copy_process()调用copy_flags()更新task_struct的flags成员
>
> 6.alloc_pid()为新进程分配一个有效PID
>
> 7.处理传递给clone()的参数标志
>
> 8.copy_process()扫尾工作并返回指向子进程的指针

### vfork()

> 与fork()区别在于vfork()不拷贝父进程页表项。
>
> vfork()系统调用的实现是通过向clone()系统调用传递一个特殊标志来实现
>
> strace跟踪看一下特殊情况

### 线程在Linux中的实现

> 从内核角度来说，Linux没有线程概念。线程仅仅被视为一个与其他进程共享某些资源的进程。每个线程都拥有唯一隶属于自己的task_struct,在内核中看起来就像是普通进程。他只是一种进程间共享资源的手段，Linux进程本身已经足够轻量级。

### 创建线程  

> clone(CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND,0)
>
> 即父子进程共享地址空间|父子进程共享文件系统信息|父子进程共享打开的文件|父子进程共享信号处理函数及被阻断的信号
>
> 一个普通的fork()实现:
>
> clone(SIGCHLD,0)

### 内核线程

> 独立运行在内核空间的标准进程。
>
> 与普通进程的区别在于内核线程没有独立的地址空间。
>
> 只在内核空间运行，从不切换到用户空间去。
>
> 从kthreadd内核进程中衍生出所有的新的内核线程来实现创建。
>
> ```c
> struct task_struct *kthread_create(int (*threadfn)(void *data),
>                                    void *data,
>                                    const char namefmt[],
>                                    ...)
> //新任务由kthread通过clone()创建
> //data为传递的参数，namefmt为进程名
> ```
>
> 新进程处于不可运行状态如果不用wake_up_process()来明确唤醒它，它不会主动运行。
>
> 如果想要创建一个进程并且让他运行起来，调用kthread_run()
>
> ```c
> struct task_struct *kthread_run(int (*threadfn)(void *data),
>                                	void *data,
>                                 const char namefmt[],
>                                 ...)
> //本质等价于kthread_create()+wake_up_process()
> //通过宏实现
> #define kthread_run (threadfn,data,namefmt,...)\
> ({                                              \
>     struct task_struct *k;           \
>     k=kthread_create(thradfn,data,namefmt,##__VA_ARGS__);     \
> 	if(!IS_ERR(k))
>         wake_up_process(k);      \
> 	k;               \
> })     \
> ```
>
> 退出：调用do_exit()或内核的其他部分调用kthread_stop()

### 进程终结

> 释放资源+通知父进程
>
> 主要依靠do_exit(),它所做的工作如下：
>
> 1.task_struct中的标志成员设置为PF_EXITING
>
> 2.调del_timer_sync().确保没有定时器在排队或运行
>
> 3.若记账功能开启，输出记账信息
>
> 4.如果地址空间未共享，就释放
>
> 5.若进程排队等ipc信号，则离开队列
>
> 6.递减文件描述符，文件系统数据的引用计数，若降为0则释放
>
> 7.task_struct中的exit_code中的任务退出代码置为exit()提供的退出代码
>
> 8.给子进程重新找养父（线程组中的其他线程或者init进程），设置进程状态为EXIT_ZOMBIE
>
> 9.do_exit()调用schedule()切换到新进程。
>
> 此时进程不可运行且处于EXIT_ZOMBIE退出状态。存在的唯一目的是向它的父进程提供信息。
>
> 父进程检索到信息得知为无关信息后，进程的剩余内存被释放

### 删除进程描述符

> do_exit()之后进程不能运行了，但仍保留了进程描述符。这样可以让系统在子进程终结后仍能获得信息。
>
> 只有父进程得知该子进程已终结，子进程的task_struct才可释放
>
> wait()通过wait4()来实现。挂起调用它的进程，知道其中一个子进程退出，此时函数法返回子进程的pid。
>
> 最终释放进程描述符时，release_task()会被调用，完成：
>
> 1.从pidhash和任务列表中删除该进程
>
> 2.释放资源，进行统计
>
> 3。如果是进程组最后一个进程，通知将死的领头进程的父进程
>
> 4.释放thread_info结构所占的页，释放task_struct所占的slab高速缓存

孤儿进程

> 父进程执行完成或被终止后仍继续运行的一类进程。会浪费内存。
>
> 解决方法：找一个线程做父亲或让init做父亲
>
> ```c
> //do_exit()->exit_notify()->forget_original_parent()->find_new_reaper()
> //寻父过程
> static struct task_struct *find_new_reaper(struct tast_struct *father)
> {
>     struct pid_namespace *pid_ns =task_activeg_pid_ns(father);
>     struct task_struct *thread;
>     thread = father;
>   //...
> }
> ```



## Ch4 进程调度

### 多任务

> 多任务系统分为  非抢占式和抢占式
>
> Linux采用抢占式的多任务。

### 策略

> I/O消耗型：大部分时间用来提交或等待IO，运行时间短。GUI就是
>
> 处理器消耗型：没有太多IO需求。MATLAB就是
>
> 调度策略需要在二者间找平衡,Linux更倾向于IO消耗型

> 优先级调度：高的先运行，低的后运行，相同的按轮转方式调度。调度程序总是选择时间片未用尽且优先级最高的运行。用户和系统都能设置进程优先级。
>
> Linux采取了两种优先级范围：
>
> 1.nice值，-20~+19,默认为0，低nice值优先级更高，nice代表分配时间片的比例。
>
> 2.实时优先级，0-99，值可配置，值越大优先级越高。任何实时进程优先级都应该高于普通进程 。因此实时和nice不相交

### 时间片

> 太长交互差，太短进程切换耗时。Io消耗型不需要长时间片，处理器消耗型需要长的。
>
> 默认时间片都很短，10ms。
>
> Linux的CFS调度器没有直接分配时间片到进程，而是分配处理器的使用比例；比例会影响nice值。
>
> 如果消耗的处理器使用比小于当前进程，则新进程立刻投入运行。

### 调度策略的活动

> 



