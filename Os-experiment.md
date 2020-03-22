# Os-experiment

## 通用数据结构

### 链表（rcu略）

定义

```c
struct list_head {
	struct list_head *next, *prev;
};

```

初始化

```c
//list.h

#define LIST_HEAD_INIT(name) { &(name), &(name) }

/**
 * 创建一个新的链表。是新链表头的占位符，并且是一个哑元素。
 * 同时初始化prev和next字段，让它们指向list_name变量本身。
 */
#define LIST_HEAD(name) \
	struct list_head name = LIST_HEAD_INIT(name)

#define INIT_LIST_HEAD(ptr) do { \
	(ptr)->next = (ptr); (ptr)->prev = (ptr); \
} while (0)
```

插入

```c
static inline void __list_add(struct list_head *new,
			      struct list_head *prev,
			      struct list_head *next)
{
	next->prev = new;
	new->next = next;
	new->prev = prev;
	prev->next = new;
}


/**
 * 把元素插入特定元素之后
 */
static inline void list_add(struct list_head *new, struct list_head *head)
{
	__list_add(new, head, head->next);
}

/**
 * 把元素插到特定元素之前。
 */
static inline void list_add_tail(struct list_head *new, struct list_head *head)
{
	__list_add(new, head->prev, head);
}
```

删除

```
static inline void __list_del(struct list_head * prev, struct list_head * next)
{
	next->prev = prev;
	prev->next = next;
}

/**
 * 删除特定元素
 */
static inline void list_del(struct list_head *entry)
{
	__list_del(entry->prev, entry->next);
	entry->next = LIST_POISON1;
	entry->prev = LIST_POISON2;
}

//删除一个节点并重新初始化
static inline void list_del_init(struct list_head *entry)
{
	__list_del(entry->prev, entry->next);
	INIT_LIST_HEAD(entry);
}

//delete from one list and add as another's head
static inline void list_move(struct list_head *list, struct list_head *head)
{
        __list_del(list->prev, list->next);
        list_add(list, head);
}


static inline void list_move_tail(struct list_head *list,
				  struct list_head *head)
{
        __list_del(list->prev, list->next);
        list_add_tail(list, head);
}
```

判空

```c
static inline int list_empty(const struct list_head *head)
{
	return head->next == head;
}


static inline int list_empty_careful(const struct list_head *head)
{
	struct list_head *next = head->next;
	return (next == head) && (next == head->prev);
}

```

拼接

```c
static inline void __list_splice(struct list_head *list,
				 struct list_head *head)
{
	struct list_head *first = list->next;
	struct list_head *last = list->prev;
	struct list_head *at = head->next;

	first->prev = head;
	head->next = first;

	last->next = at;
	at->prev = last;
}


static inline void list_splice(struct list_head *list, struct list_head *head)
{
	if (!list_empty(list))
		__list_splice(list, head);
}


static inline void list_splice_init(struct list_head *list,
				    struct list_head *head)
{
	if (!list_empty(list)) {
		__list_splice(list, head);
		INIT_LIST_HEAD(list);
	}
}

```

常用结构

```c
/** 
 * 返回链表所在结构
 */
#define list_entry(ptr, type, member) \
	container_of(ptr, type, member)

/**
 * 扫描指定的链表
 */
#define list_for_each(pos, head) \
	for (pos = (head)->next; prefetch(pos->next), pos != (head); \
        	pos = pos->next)

#define __list_for_each(pos, head) \
	for (pos = (head)->next; pos != (head); pos = pos->next)

#define list_for_each_prev(pos, head) \
	for (pos = (head)->prev; prefetch(pos->prev), pos != (head); \
        	pos = pos->prev)

#define list_for_each_safe(pos, n, head) \
	for (pos = (head)->next, n = pos->next; pos != (head); \
		pos = n, n = pos->next)


/**
 * 与list_for_each相似，但是返回每个链表结点所在结构
 */
#define list_for_each_entry(pos, head, member)				\
	for (pos = list_entry((head)->next, typeof(*pos), member);	\
	     prefetch(pos->member.next), &pos->member != (head); 	\
	     pos = list_entry(pos->member.next, typeof(*pos), member))

#define list_for_each_entry_reverse(pos, head, member)			\
	for (pos = list_entry((head)->prev, typeof(*pos), member);	\
	     prefetch(pos->member.prev), &pos->member != (head); 	\
	     pos = list_entry(pos->member.prev, typeof(*pos), member))

```

其中container_of如下

```
/**
 * container_of - cast a member of a structure out to the containing structure
 *
 * @ptr:	the pointer to the member.
 * @type:	the type of the container struct this is embedded in.
 * @member:	the name of the member within the struct.
 * 找到type的起始地址
 */
#define container_of(ptr, type, member) ({			\
        const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
        (type *)( (char *)__mptr - offsetof(type,member) );})

//获取member在type里面的相对偏移量
#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
```



## 进程

结构

```c
typedef struct Task {
    uint8_t *kstack;                // 内核栈
    pid_t pid;                      // 自己的进程id
    pid_t parentPid;                // 父进程id
    pid_t groupPid;                 // 组id
    enum TaskStatus status;
    pde_t *pgdir;                   // 页目录表指针
    uint32_t priority;              /* 任务所在的优先级队列 */
    uint32_t ticks;                 /*  */
    uint32_t timeslice;             /* 时间片，可以动态调整 */

    uint32_t elapsedTicks;
    int exitStatus;                 // 退出时的状态
    char name[MAX_TASK_NAMELEN];
    
    char cwd[MAX_PATH_LEN];		//当前工作路径,指针
	
    int fdTable[MAX_OPEN_FILES_IN_PROC];    // 文件描述符表

    struct MemoryManager *mm;       // 内存管理
    struct List list;               // 处于所在队列的链表
    struct List globalList;         // 全局任务队列，用来查找所有存在的任务

    /* 信号相关 */
    uint8_t signalLeft;     /* 有信号未处理 */
    uint8_t signalCatched;     /* 有一个信号被捕捉，并处理了 */
    
    Signal_t signals;        /* 进程对应的信号 */
    sigset_t signalBlocked;  /* 信号阻塞 */
    sigset_t signalPending;     /* 信号未决 */
    Spinlock_t signalMaskLock;  /* 信号屏蔽锁 */

    /* alarm闹钟 */
    char alarm;                     /* 闹钟是否有效 */
    uint32_t alarmTicks;            /* 闹钟剩余的ticks计数 */
    uint32_t alarmSeconds;          /* 闹钟剩余的秒数 */

    struct Timer *sleepTimer;       /* 休眠的时候的定时器 */

    KGC_Window_t *window;           /* 任务对应的窗口 */
    
    unsigned int stackMagic;         /* 任务的魔数 */
} Task_t;
```

状态

```c
enum TaskStatus {
    TASK_READY = 0,         /* 进程处于就绪状态 */
    TASK_RUNNING,           /* 进程正在运行中 */
    TASK_BLOCKED,           /* 进程由于某种原因被阻塞 */
    TASK_WAITING,           /* 进程处于等待子进程状态 */
    TASK_STOPPED,           /* 进程处于停止运行状态 */
    TASK_ZOMBIE,            /* 进程处于僵尸状态，退出运行 */
    TASK_DIED,              /* 进程处于死亡状态，资源已经被回收 */
};
```

实现资源限制功能

```c
//include/book/resource.h
/**
 * 进程资源限制。current->signal->rlim是一个数组，每个元素对应一个rlimit描述符。
 */
struct rlimit {
	/**
	 * 资源的当前限制值。
	 */
	unsigned long	rlim_cur;
	/**
	 * 资源限制所允许的最大值。
	 * 用户能够利用getrlimit和setrlimit系统调用，将一些资源的rlim_cur限制值增加到rlim_max。
	 * 但是，只有超级用户或者具有CAP_SYS_RESOURCE权限的用户才能改变rlim_max字段、或者将rlim_cur
	 * 设置成大于rlim_max字段的值。
	 */
	unsigned long	rlim_max;
};
```

