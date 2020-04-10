org 0x7c00              ;起始地址

BaseofStack equ 0x7c00  ;等价语句 左边==右边，不会分配空间，这里用于为栈寄存器sp提供栈基址
BaseOfLoader	equ	0x1000
OffsetOfLoader	equ	0x00   ; baseofloader<<4+offsetloader = 0x10000


RootDirSectors	equ	14  ;占用扇区
SectorNumOfRootDirStart	equ	19 ;起始扇区
SectorNumOfFAT1Start	equ	1
SectorBalance	equ	17	

;初始化
Label_Start:
    mov ax, cs
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, BaseofStack

;主体代码
;int 10h 的功能号ah=02h实现光标位置


; clear screen
mov ax, 0600h          ;ah = 06h 实现指定范围滚动窗口
mov bx, 0700h          ;属性
mov cx, 0              ;左上角行列坐标
mov dx, 0184fh         ;右下角行列坐标
int 10h

;set focus
mov ax, 0200h   ;设定光标位置
mov bx, 0000h   ;bh 页码
mov dx, 0000h   ;dh 列数 dl 行数
int 10h

;display on screen 
mov ax,1301h    ;al=01光标移动到字符串尾端
mov bx,000fh
mov dx,0000h
mov cx, 19      ;字符串长度
push ax
mov ax,ds   
mov es,ax      ;es:bp要显示的字符串的内存地址
pop ax
mov bp, StartMessage
int 10h


;reset floppy 复位软盘，相当于将软盘驱动器的磁头移动到默认位置

xor ah,ah   ; int 13h ah=00h 重置磁盘驱动器
xor dl,dl   ; 驱动器号
int 13h
jmp $



;=======	read one sector from floppy
;int 13 ah=02h软盘读取
Func_ReadOneSector:
	
	push	bp
	mov	bp,	sp
	sub	esp,	2
	mov	byte	[bp - 2],	cl
	push	bx
	mov	bl,	[BPB_SecPerTrk]
	div	bl
	inc	ah
	mov	cl,	ah  ;cl读入的扇区数
	mov	dh,	al
	shr	al,	1
	mov	ch,	al
	and	dh,	1
	pop	bx      ;es:bx目标缓冲区起始地址
	mov	dl,	[BS_DrvNum]
Label_Go_On_Reading:
	mov	ah,	2
	mov	al,	byte	[bp - 2]
	int	13h
	jc	Label_Go_On_Reading
	add	esp,	2
	pop	bp
	ret




StartMessage: db "Start BootLoader..." ;db 一个字节数据占1个字节单元，读完一个，偏移量加1

times 510-($-$$) db 0  ;$-$$代表将当前被编译后的地址减去本节程序的起始地址，实际上是求填充长度 times是重复操作
dw 0xaa55