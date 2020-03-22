org 0x7c00              ;起始地址

BaseofStack equ 0x7c00  ;等价语句 左边==右边，不会分配空间，这里用于为栈寄存器sp提供栈基址

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


StartMessage: db "Start BootLoader..." ;db 一个字节数据占1个字节单元，读完一个，偏移量加1

times 510-($-$$) db 0  ;$-$$代表将当前被编译后的地址减去本节程序的起始地址，实际上是求填充长度 times是重复操作
dw 0xaa55