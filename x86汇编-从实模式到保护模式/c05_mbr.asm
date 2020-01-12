         ;代码清单5-1 
         ;文件名：c05_mbr.asm
         ;文件说明：硬盘主引导扇区代码
         ;创建日期：2011-3-31 21:15 
 
;先处理显卡        
         mov ax,0xb800                ;es寄存器指向文本模式的显示缓冲区,b8xxx-bffff留给显卡，用于显示文本,是物理地址
         mov es,ax                    ;处理器不允许直接传立即数，所以用ax中转

         ;以下显示字符串"Label offset:"
         ;字符的显示属性分为两个字节
         ;第一个字节是字符的ASCII码，第二个字节是字符的显示属性
         ;下面的0x07表示字符以黑底白字，无闪烁无加亮的方式显示
         ;方括号表示是一个地址，修改的是地址里的内容，均为物理地址
         ;方括号表明这是地址
         ;byte明确指示源操作数宽度
         mov byte [es:0x00],'C'
         mov byte [es:0x01],0x02
         mov byte [es:0x02],'h'
         mov byte [es:0x03],0x02
         mov byte [es:0x04],'e'
         mov byte [es:0x05],0x02
         mov byte [es:0x06],'n'
         mov byte [es:0x07],0x02
         mov byte [es:0x08],'g'
         mov byte [es:0x09],0x02
         mov byte [es:0x0a],'J'
         mov byte [es:0x0b],0x02
         mov byte [es:0x0c],"u"
         mov byte [es:0x0d],0x02
         mov byte [es:0x0e],'n'
         mov byte [es:0x0f],0x02
         mov byte [es:0x10],'Y'
         mov byte [es:0x11],0x02
         mov byte [es:0x12],'i'
         mov byte [es:0x13],0x02
         mov byte [es:0x14],'S'
         mov byte [es:0x15],0x02
         mov byte [es:0x16],'B'
         mov byte [es:0x17],0x02
         mov byte [es:0x18],'!'
         mov byte [es:0x19],0x02


;下面处理内存

         mov ax,number                 ;取得标号number的偏移地址,后面AX存放商
         mov bx,10                     ;bx保存除数,div指令使用bx寄存器的值作为除数

         ;设置数据段的基地址 ，代码段数据段指向同一个地方
         mov cx,cs  
         mov ds,cx

         ;32位除法中，被除数的低16位在ax寄存器中，高16位在dx寄存器中
         ;前面已经将number的地址赋值给ax，下面将dx清零
         ;求个位上的数字，dx:ax格式，10作为除数在bx
         ;es为段超越前缀，明确生成物理地址使用ES,而非默认的DS
         mov dx,0
         div bx
         mov [0x7c00+number+0x00],dl   ;保存个位上的数字，因为余数肯定小于10，所以只需要低4位，有dl所以不用byte

         ;求十位上的数字, 异或清零，异或好处是指令短且两个操作数都是寄存器速度更快
         ;因为主引导扇区代码从0x0000:0x7c00开始而不是0000：0000
         xor dx,dx
         div bx
         mov [0x7c00+number+0x01],dl   ;保存十位上的数字

         ;求百位上的数字
         xor dx,dx
         div bx
         mov [0x7c00+number+0x02],dl   ;保存百位上的数字

         ;求千位上的数字
         xor dx,dx
         div bx
         mov [0x7c00+number+0x03],dl   ;保存千位上的数字

         ;求万位上的数字 
         xor dx,dx
         div bx
         mov [0x7c00+number+0x04],dl   ;保存万位上的数字

;从后向前输出
         ;以下用十进制显示标号的偏移地址
         mov al,[0x7c00+number+0x04]    ;将计算结果送到al寄存器中
         add al,0x30                    ;加上0x30得到这个数字的ASCII码
         mov [es:0x1a],al               ;得到的ASCII码送到指定的位置
         mov byte [es:0x1b],0x04        ;显示属性为黑底红字，无闪烁无加亮
         
         mov al,[0x7c00+number+0x03]
         add al,0x30                     ;得到ascii码
         mov [es:0x1c],al
         mov byte [es:0x1d],0x04
         
         mov al,[0x7c00+number+0x02]
         add al,0x30
         mov [es:0x1e],al
         mov byte [es:0x1f],0x04

         mov al,[0x7c00+number+0x01]
         add al,0x30
         mov [es:0x20],al
         mov byte [es:0x21],0x04

         mov al,[0x7c00+number+0x00]
         add al,0x30
         mov [es:0x22],al
         mov byte [es:0x23],0x04
         
         mov byte [es:0x24],'D'
         mov byte [es:0x25],0x07
          
   infi: jmp near infi                 ;无限循环，near表示目标位置仍在当前代码段，重复执行自己，转移到标号infi所在位置执行
                                       ;为什么不+0x7c00? near+标号会产生相对转移
       
  number : db 0,0,0,0,0                 ;db字节 ，初始化数据，number是这些数据的起始汇编地址，占位
  
  times 203 db 0                      ;补上203个0使得最后两位为55 aa
            db 0x55,0xaa



;