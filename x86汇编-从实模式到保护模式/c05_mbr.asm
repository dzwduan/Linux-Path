         ;�����嵥5-1 
         ;�ļ�����c05_mbr.asm
         ;�ļ�˵����Ӳ����������������
         ;�������ڣ�2011-3-31 21:15 
 
;�ȴ����Կ�        
         mov ax,0xb800                ;es�Ĵ���ָ���ı�ģʽ����ʾ������,b8xxx-bffff�����Կ���������ʾ�ı�,�������ַ
         mov es,ax                    ;������������ֱ�Ӵ���������������ax��ת

         ;������ʾ�ַ���"Label offset:"
         ;�ַ�����ʾ���Է�Ϊ�����ֽ�
         ;��һ���ֽ����ַ���ASCII�룬�ڶ����ֽ����ַ�����ʾ����
         ;�����0x07��ʾ�ַ��Ժڵװ��֣�����˸�޼����ķ�ʽ��ʾ
         ;�����ű�ʾ��һ����ַ���޸ĵ��ǵ�ַ������ݣ���Ϊ�����ַ
         ;�����ű������ǵ�ַ
         ;byte��ȷָʾԴ���������
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


;���洦���ڴ�

         mov ax,number                 ;ȡ�ñ��number��ƫ�Ƶ�ַ,����AX�����
         mov bx,10                     ;bx�������,divָ��ʹ��bx�Ĵ�����ֵ��Ϊ����

         ;�������ݶεĻ���ַ ����������ݶ�ָ��ͬһ���ط�
         mov cx,cs  
         mov ds,cx

         ;32λ�����У��������ĵ�16λ��ax�Ĵ����У���16λ��dx�Ĵ�����
         ;ǰ���Ѿ���number�ĵ�ַ��ֵ��ax�����潫dx����
         ;���λ�ϵ����֣�dx:ax��ʽ��10��Ϊ������bx
         ;esΪ�γ�Խǰ׺����ȷ���������ַʹ��ES,����Ĭ�ϵ�DS
         mov dx,0
         div bx
         mov [0x7c00+number+0x00],dl   ;�����λ�ϵ����֣���Ϊ�����϶�С��10������ֻ��Ҫ��4λ����dl���Բ���byte

         ;��ʮλ�ϵ�����, ������㣬���ô���ָ������������������ǼĴ����ٶȸ���
         ;��Ϊ���������������0x0000:0x7c00��ʼ������0000��0000
         xor dx,dx
         div bx
         mov [0x7c00+number+0x01],dl   ;����ʮλ�ϵ�����

         ;���λ�ϵ�����
         xor dx,dx
         div bx
         mov [0x7c00+number+0x02],dl   ;�����λ�ϵ�����

         ;��ǧλ�ϵ�����
         xor dx,dx
         div bx
         mov [0x7c00+number+0x03],dl   ;����ǧλ�ϵ�����

         ;����λ�ϵ����� 
         xor dx,dx
         div bx
         mov [0x7c00+number+0x04],dl   ;������λ�ϵ�����

;�Ӻ���ǰ���
         ;������ʮ������ʾ��ŵ�ƫ�Ƶ�ַ
         mov al,[0x7c00+number+0x04]    ;���������͵�al�Ĵ�����
         add al,0x30                    ;����0x30�õ�������ֵ�ASCII��
         mov [es:0x1a],al               ;�õ���ASCII���͵�ָ����λ��
         mov byte [es:0x1b],0x04        ;��ʾ����Ϊ�ڵ׺��֣�����˸�޼���
         
         mov al,[0x7c00+number+0x03]
         add al,0x30                     ;�õ�ascii��
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
          
   infi: jmp near infi                 ;����ѭ����near��ʾĿ��λ�����ڵ�ǰ����Σ��ظ�ִ���Լ���ת�Ƶ����infi����λ��ִ��
                                       ;Ϊʲô��+0x7c00? near+��Ż�������ת��
       
  number : db 0,0,0,0,0                 ;db�ֽ� ����ʼ�����ݣ�number����Щ���ݵ���ʼ����ַ��ռλ
  
  times 203 db 0                      ;����203��0ʹ�������λΪ55 aa
            db 0x55,0xaa



;