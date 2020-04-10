## 1160[拼写单词](https://leetcode-cn.com/problems/find-words-that-can-be-formed-by-characters)  

> 给你一份『词汇表』（字符串数组） words 和一张『字母表』（字符串） chars。
>
> 假如你可以用 chars 中的『字母』（字符）拼写出 words 中的某个『单词』（字符串），那么我们就认为你掌握了这个单词。
>
> 注意：每次拼写时，chars 中的每个字母都只能用一次。
>
> 返回词汇表 words 中你掌握的所有单词的 长度之和。
>
>  
>
> 示例 1：
>
> 输入：words = ["cat","bt","hat","tree"], chars = "atach"
> 输出：6
> 解释： 
> 可以形成字符串 "cat" 和 "hat"，所以答案是 3 + 3 = 6。
> 示例 2：
>
> 输入：words = ["hello","world","leetcode"], chars = "welldonehoneyr"
> 输出：10
> 解释：
> 可以形成字符串 "hello" 和 "world"，所以答案是 5 + 5 = 10。

解题思路：根据word中每个字符出现的次数是否小于词汇表中出现的次数，使用hash方法

```c++
class Solution {
public:
    int countCharacters(vector<string>& words, string chars) {
        unordered_map<char,int> hash;
        for(auto c : chars)
            hash[c]++;
        int ans=0;
        for(auto word : words){
            unordered_map<char,int> hash_word;
            bool is_ans=true;
            for(auto c : word)
                hash_word[c]++;
            for(auto c : word){
                if(hash_word[c]>hash[c]){
                    is_ans = false;
                    break;
                }
            }
            if(is_ans)
                ans+=word.size();
        }
        return ans;
    }
}; 

```



## 面试题58 - II [左旋转字符串](https://leetcode-cn.com/problems/zuo-xuan-zhuan-zi-fu-chuan-lcof)  



> 字符串的左旋转操作是把字符串前面的若干个字符转移到字符串的尾部。请定义一个函数实现字符串左旋转操作的功能。比如，输入字符串"abcdefg"和数字2，该函数将返回左旋转两位得到的结果"cdefgab"。
>
>  
>
> 示例 1：
>
> 输入: s = "abcdefg", k = 2
> 输出: "cdefgab"
> 示例 2：
>
> 输入: s = "lrloseumgh", k = 6
> 输出: "umghlrlose"

直接使用substr拼接，一开始想的是3次swap不过效果不好

```c++
class Solution {
public:

    string reverseLeftWords(string s, int n) {
        return s.substr(n, s.length() - n) + s.substr(0,n);
    }
};
```



## 1365 [ 有多少小于当前数字的数字](https://leetcode-cn.com/problems/how-many-numbers-are-smaller-than-the-current-number)  

> 给你一个数组 nums，对于其中每个元素 nums[i]，请你统计数组中比它小的所有数字的数目。
>
> 换而言之，对于每个 nums[i] 你必须计算出有效的 j 的数量，其中 j 满足 j != i 且 nums[j] < nums[i] 。
>
> 以数组形式返回答案。
>
>  
>
> 示例 1：
>
> 输入：nums = [8,1,2,2,3]
> 输出：[4,0,1,1,3]
> 解释： 
> 对于 nums[0]=8 存在四个比它小的数字：（1，2，2 和 3）。 
> 对于 nums[1]=1 不存在比它小的数字。
> 对于 nums[2]=2 存在一个比它小的数字：（1）。 
> 对于 nums[3]=2 存在一个比它小的数字：（1）。 
> 对于 nums[4]=3 存在三个比它小的数字：（1，2 和 2）。
> 示例 2：
>
> 输入：nums = [6,5,4,8]
> 输出：[2,1,0,3]
> 示例 3：
>
> 输入：nums = [7,7,7,7]
> 输出：[0,0,0,0]
>
>
> 提示：
>
> 2 <= nums.length <= 500
> 0 <= nums[i] <= 100
>

```c++
class Solution {
public:
    vector<int> smallerNumbersThanCurrent(vector<int>& nums) {
        vector<int> sum(101,0); //存前缀和
        vector<int> vec((int)nums.size(),0);//保存结果

        for(int i=0;i<(int)nums.size();++i){
            sum[nums[i]]++; //先保存每个数字出现的次数
        }

        for(int i=1;i<=100;++i)
            sum[i]+=sum[i-1]; //求每个数的前缀和
        for(int i=0;i<(int)nums.size();++i){
            if(nums[i])
                vec[i] = sum[nums[i]-1];
         }
        return vec;
    }
};
```







## 1342 [ 将数字变成 0 的操作次数](https://leetcode-cn.com/problems/number-of-steps-to-reduce-a-number-to-zero) 

![image-20200318102706714](C:\Users\10184\AppData\Roaming\Typora\typora-user-images\image-20200318102706714.png)

```c++
class Solution {
public:
    int numberOfSteps (int num) {
        int steps = 0;
        while(num){
            if(num%2==0)
                num/=2;
            else 
                num-=1;
            steps++;
        }
        return steps;
    }
};
```





## 1281 [整数的各位积和之差](https://leetcode-cn.com/problems/subtract-the-product-and-sum-of-digits-of-an-integer) 

![image-20200318102927807](C:\Users\10184\AppData\Roaming\Typora\typora-user-images\image-20200318102927807.png)

```c++
class Solution {
public:
    int subtractProductAndSum(int n) {
        int add = 0;
        int mul = 1;
        int num=0;
        while(n>0){
            int num = n%10;
            add+=num;
            mul*=num;
            n/=10;
        }
        return mul-add;
    }
};
```



## [     LCP 1  猜数字](https://leetcode-cn.com/problems/guess-numbers) 

![image-20200318112519133](C:\Users\10184\AppData\Roaming\Typora\typora-user-images\image-20200318112519133.png)

```c++
class Solution {
public:
    int game(vector<int>& guess, vector<int>& answer) {
        int cnt = 0;
        for(int i=0;i<3;++i)
            if(guess[i]==answer[i])
                ++cnt;
        return cnt;
    }
};
```



## 1295 [统计位数为偶数的数字](https://leetcode-cn.com/problems/find-numbers-with-even-number-of-digits) 

![image-20200318112851351](C:\Users\10184\AppData\Roaming\Typora\typora-user-images\image-20200318112851351.png)

```c++
class Solution {
public:
    int findNumbers(vector<int>& nums) {
        int cnt=0;
        for(auto n:nums){
           if(to_string(n).size()%2==0){
               cnt++;
           }
        }
        return cnt;
    }
};
```



## 836 [ 矩形重叠](https://leetcode-cn.com/problems/rectangle-overlap)

![image-20200318113214129](C:\Users\10184\AppData\Roaming\Typora\typora-user-images\image-20200318113214129.png)

直接比较坐标位置就行

```c++
class Solution {
public:
    bool isRectangleOverlap(vector<int>& rec1, vector<int>& rec2) {
         return !(rec1[2] <= rec2[0] ||   // left
                 rec1[3] <= rec2[1] ||   // bottom
                 rec1[0] >= rec2[2] ||   // right
                 rec1[1] >= rec2[3]);    // top

    }
};
```



## 1313 [ 解压缩编码列表](https://leetcode-cn.com/problems/decompress-run-length-encoded-list)  

![image-20200318114019001](C:\Users\10184\AppData\Roaming\Typora\typora-user-images\image-20200318114019001.png)

```c++
class Solution {
public:
    vector<int> decompressRLElist(vector<int>& nums) {
        vector<int> ans;
        int a=0,b=0;
        for(int i=0;i<(int)nums.size();i+=2){
            a=nums[i];
            b=nums[i+1];
            for(int j=0;j<a;++j){
                ans.push_back(b);
            }
        }
        return ans;
    }
};
```





## 771 [宝石与石头](https://leetcode-cn.com/problems/jewels-and-stones)

![image-20200320002144425](C:\Users\10184\AppData\Roaming\Typora\typora-user-images\image-20200320002144425.png)

```c++
class Solution {
public:
    int numJewelsInStones(string J, string S) {
        unordered_map<char,int> hash;
        int sum=0;
        for(char c : J){
            hash[c]=1;
        }
        for(char c : S){
           if(hash[c])
            sum++;
        }
        return sum;
    }
};
```



##   面试题40[ 最小的k个数](https://leetcode-cn.com/problems/zui-xiao-de-kge-shu-lcof) 

![image-20200320002825863](C:\Users\10184\AppData\Roaming\Typora\typora-user-images\image-20200320002825863.png)

```c++
class Solution {
public:
    vector<int> getLeastNumbers(vector<int>& arr, int k) {
        vector<int> vec(k, 0);
        sort(arr.begin(), arr.end());
        for (int i = 0; i < k; ++i) vec[i] = arr[i];
        return vec;
    }
};
```

为什么直接排序比堆排序还快。。



## 1108[IP 地址无效化](https://leetcode-cn.com/problems/defanging-an-ip-address) 

![image-20200320003140390](C:\Users\10184\AppData\Roaming\Typora\typora-user-images\image-20200320003140390.png)

```c
class Solution {
public:
    string defangIPaddr(string address) {
        string str;
        for(char c :address){
            if(c=='.')
                str+="[.]";
            else
                str+=c;
        }
        return str;
    }
};
```

重造个新的替换就完事了





1290[ 二进制链表转整数](https://leetcode-cn.com/problems/convert-binary-number-in-a-linked-list-to-integer)

![image-20200320151607661](C:\Users\10184\AppData\Roaming\Typora\typora-user-images\image-20200320151607661.png)

```c++
class Solution {
public:
    int getDecimalValue(ListNode* head) {
        int sum = 0;
        while(head){
            sum = sum*2 + head->val;
            head = head->next;
        }
        return sum;
    }
};
```



## 1266 [访问所有点的最小时间](https://leetcode-cn.com/problems/minimum-time-visiting-all-points) 

![image-20200320153144212](C:\Users\10184\AppData\Roaming\Typora\typora-user-images\image-20200320153144212.png)

本质是每次都走x，y方向中最长的那个方向

```c++
class Solution {
public:
    int minTimeToVisitAllPoints(vector<vector<int>>& points) {
        int size = points.size();
        int sum = 0;
        for(int i=1;i<size;++i){
            int xpath = abs(points[i][0]-points[i-1][0]);
            int ypath = abs(points[i][1]-points[i-1][1]);
            sum += (xpath>ypath)?xpath:ypath;
        }
        return sum;
    }
};
```



## 237 [ 删除链表中的节点](https://leetcode-cn.com/problems/delete-node-in-a-linked-list)

![image-20200320154816689](C:\Users\10184\AppData\Roaming\Typora\typora-user-images\image-20200320154816689.png)

```c++
class Solution {
public:
    void deleteNode(ListNode* node) {
        node->val = node->next->val;
        node->next = node->next->next;
    }
};

//原地删除法
```



## 面试题02.02 [返回倒数第 k 个节点](https://leetcode-cn.com/problems/kth-node-from-end-of-list-lcci) 

![image-20200320155238640](C:\Users\10184\AppData\Roaming\Typora\typora-user-images\image-20200320155238640.png)

双指针法

```c++
class Solution {
public:
    int kthToLast(ListNode* head, int k) {
            ListNode *  p,*q;

            p=head;
            q=head;
            for(int i=0;i<k && p;p=p->next,++i);
            while(p){
                p=p->next;
                q=q->next;
            }
            return q->val;
    }
};
```



## 1351 [统计有序矩阵中的负数](https://leetcode-cn.com/problems/count-negative-numbers-in-a-sorted-matrix) 

![image-20200320160206170](C:\Users\10184\AppData\Roaming\Typora\typora-user-images\image-20200320160206170.png)

这是有序序列，需要充分利用非递增的特性，从右上到左下下梯子

```c++
class Solution {
public:
    int countNegatives(vector<vector<int>>& grid) {
        int row = grid.size();
        int col = grid[0].size();
        int sum=0;
        int y = col-1;
        for(auto &p : grid){
            
            while(y>=0 && p[y]<0) 
                y--;
            sum += (col-y-1);
        }
        return sum;
    }
};
```





## 365 [水壶问题](https://leetcode-cn.com/problems/water-and-jug-problem) 

![image-20200321185125824](C:\Users\10184\Desktop\Linux-Path\Leetcode.assets\image-20200321185125824.png)

数学方法：[贝祖定理](https://baike.baidu.com/item/裴蜀定理/5186593?fromtitle=贝祖定理&fromid=5185441)

任意时刻的操作变化的都是x,y，目标就变化为找到a b 使得 ax + by = z有整数解

而上式有解当且仅当z是x y的最大公约数的倍数即贝祖定理。

并且隐含条件是z <=x+y ,如果不满足，那么两个加起来都无法装满

```c++
class Solution {
public:
    bool canMeasureWater(int x, int y, int z) {
        if(x+y<z || z<0)
            return false;
        if(!z)
            return true;
        int g;
        if(x==0 || y==0)
            g = x+y;
        else 
            g = gcd<int>(x,y);
        return !(z%g);
    }

    template<typename T>
    T gcd(T x,T y){
        if(x%y==0 )
            return y;
        else
            return gcd<T>(y,x%y);
    }
};
```



## 面试题04.02 [最小高度树](https://leetcode-cn.com/problems/minimum-height-tree-lcci) 

![image-20200321192204502](C:\Users\10184\Desktop\Linux-Path\Leetcode.assets\image-20200321192204502.png)

构造平衡二叉树

```c++
class Solution {
public:
    TreeNode* sortedArrayToBST(vector<int>& nums) {
        return buildTree(nums, 0, nums.size()-1);
    }

    TreeNode* buildTree(const vector<int> &nums,int L,int R){
        if(L>R || !nums.size())
            return nullptr;
        int mid = (L+R)>>1;
        auto ptr = new TreeNode(nums[mid]);//填充根节点
        ptr->left = buildTree(nums,L,mid-1);
        ptr->right = buildTree(nums,mid+1, R);
        return ptr;
    }
};
```



## 面试题22 [链表中倒数第k个节点](https://leetcode-cn.com/problems/lian-biao-zhong-dao-shu-di-kge-jie-dian-lcof) 

![image-20200321195900986](C:\Users\10184\Desktop\Linux-Path\Leetcode.assets\image-20200321195900986.png)

```c++
class Solution {
public:
    ListNode* getKthFromEnd(ListNode* head, int k) {
        ListNode *p=head,*q=head;
        while(k--) p = p->next;
        while(p){
            p=p->next;
            q=q->next;
        }
        return q;
    }
};
//双指针法之前用过
```



##  945 [使数组唯一的最小增量](https://leetcode-cn.com/problems/minimum-increment-to-make-array-unique) 

![image-20200322200305403](C:\Users\10184\Desktop\Linux-Path\Leetcode.assets\image-20200322200305403.png)

只要确保排序后每个数都比之前的大一

```c++
class Solution {
public:
    int minIncrementForUnique(vector<int>& A) {
        sort(A.begin(),A.end());
        int ans=0;
        for(int i=1;i<A.size();++i){
            if(A[i-1]>=A[i]){
                ans +=A[i-1]-A[i]+1;
                A[i]=A[i-1]+1;
            }
        }
        return ans;
    }
};
```



## 347[前 K 个高频元素](https://leetcode-cn.com/problems/top-k-frequent-elements/)

![image-20200322190214259](C:\Users\10184\Desktop\Linux-Path\Leetcode.assets\image-20200322190214259.png)

思路：使用优先级队列。先用hash保存出现频次，再用优先队列处理。

```c++
class Solution {
public:
        struct cmp
        {
            bool operator()(pair<int, int>& a, pair<int, int>& b)
            	{ return a.second > b.second; }
        };

        vector<int> topKFrequent(vector<int>& nums, int k) {
        vector<int> ret;
        map<int, int> hash;
        for (auto a : nums)
        {
            hash[a]++;
        }
        priority_queue<pair<int, int>, vector<pair<int, int>>, cmp> freq;//核心
        for (auto a : hash)
        {
            freq.push(a);
            if (freq.size() > k)
                freq.pop();
        }
        while (!freq.empty())
        {
            ret.push_back(freq.top().first);
            freq.pop();
        }
        return ret;
    }
};


```



## 面试题17 [打印从1到最大的n位数](https://leetcode-cn.com/problems/da-yin-cong-1dao-zui-da-de-nwei-shu-lcof) 

![image-20200322201516427](C:\Users\10184\Desktop\Linux-Path\Leetcode.assets\image-20200322201516427.png)

陷阱是大数问题，转为字符数组来做

拓展

大数打印：可以设定一个阈值，例如long的最大值，当超过了这个最大值，将阈值转为字符数组toCharArray()，然后继续+1打印，这样可以提高时间效率，因为一部分的数仍是O(1)打印
全排列：求从1~pow(10,n)-1实际上可以转化为0-9在n个位置上的全排列

```c++
class Solution {
public:
    vector<int> printNumbers(int n) {
        int max = pow(10,n)-1;
        vector<int> ans;
        for(int i=1;i<=max;++i)
          ans.push_back(i);
        return ans;
    }
};
```



## 876[链表的中间结点](https://leetcode-cn.com/problems/middle-of-the-linked-list) 

![image-20200323090141550](C:\Users\10184\Desktop\Linux-Path\Leetcode.assets\image-20200323090141550.png)

```c++
public:
    ListNode* middleNode(ListNode* head) {
        ListNode *p,*q;
        p=head;
        q=head;
        while(q && q->next){
            p=p->next;
            q=q->next->next;
        }
        return p;
    }
};
//注意 while的双限制条件
```





## 79 [单词搜索](https://leetcode-cn.com/problems/word-search) 

![image-20200323090517928](C:\Users\10184\Desktop\Linux-Path\Leetcode.assets\image-20200323090517928.png)

DFS ，每次将搜索过的置为0

```c++
class Solution {
public:
    bool exist(vector<vector<char>>& board, string word) {
        if(board.size()==0)
            return false;
        for(int i=0;i<board.size();++i)
            for(int j=0;j<board[0].size();++j)
                if(dfs(board,word,i,j,0))
                    return true;
        return false;
    }

    bool dfs(vector<vector<char>>& board,string &word, int i,int j, int length){
        if(i>=board.size()||
           j>=board[0].size()||
           i<0||
           j<0||
           length>=word.size()||
           word[length]!=board[i][j]
        )
        return false;

        if(length==word.size()-1 &&
           word[length]==board[i][j])
          return true;
        
        char tmp = board[i][j];
        board[i][j] = '0';

        bool flag= \
            dfs(board,word,i,j+1,length+1) ||
            dfs(board,word,i,j-1,length+1) ||
            dfs(board,word,i+1,j,length+1) ||
            dfs(board,word,i-1,j,length+1) ;
        board[i][j] =tmp;
        return flag;

    }
};
```



## 面试题29 [顺时针打印矩阵](https://leetcode-cn.com/problems/shun-shi-zhen-da-yin-ju-zhen-lcof) 

![image-20200323110307226](C:\Users\10184\Desktop\Linux-Path\Leetcode.assets\image-20200323110307226.png)

```c++
class Solution {
public:
    vector<int> spiralOrder(vector<vector<int>>& matrix) {
        if(matrix.size()==0 || matrix[0].size()==0)
            return {};
        vector<int> ans;
        
        int left=0;
        int right=matrix[0].size()-1;
        int top = 0;
        int bottom = matrix.size()-1;

        while(true){
            for(int i=left;i<=right;++i)
                ans.push_back(matrix[top][i]);
            top++;
            if(top>bottom)
                break;
            
            for(int i=top;i<=bottom;++i)
                ans.push_back(matrix[i][right]);
            right--;
            if(right<left)
            break;

            for(int i=right;i>=left;--i)
                ans.push_back(matrix[bottom][i]);
            bottom--;
            if(bottom<top)
                break;
            
            for(int i=bottom;i>=top;--i)
                ans.push_back(matrix[i][left]);
            left++;
            if(left>right)
                break;
        }

        return ans;
        
    }
};
```





## 面试题17.16[ 按摩师](https://leetcode-cn.com/problems/the-masseuse-lcci)

![image-20200324185104297](C:\Users\10184\Desktop\Linux-Path\Leetcode.assets\image-20200324185104297.png)

动态规划

```c++
class Solution {
public:
    int massage(vector<int>& nums) {
        int n=nums.size();
        if(!n) return 0;
        int dp0=0,dp1=nums[0];

        for(int i=1;i<n;++i){
            int dpi0 = max(dp0,dp1);
            int dpi1 = dp0+nums[i];

            dp0=dpi0;
            dp1=dpi1;
        }

        return max(dp0,dp1);
    }
};
```



## 面试题10- II [青蛙跳台阶问题](https://leetcode-cn.com/problems/qing-wa-tiao-tai-jie-wen-ti-lcof) 

![image-20200324193530204](C:\Users\10184\Desktop\Linux-Path\Leetcode.assets\image-20200324193530204.png)

```c++
class Solution {
public:
    int numWays(int n) {
        vector<int> nums(n+1,1);
        for(int i=2;i<=n;++i){
            nums[i] = (nums[i-1]+nums[i-2])%1000000007;
        }
        return nums[n];
    }
};

//要考虑大数，不能在最后取余
```





## 892 [三维形体的表面积](https://leetcode-cn.com/problems/surface-area-of-3d-shapes)

![image-20200325230204058](C:\Users\10184\Desktop\Linux-Path\Leetcode.assets\image-20200325230204058.png)

放弃







## 914 [ 卡牌分组](https://leetcode-cn.com/problems/x-of-a-kind-in-a-deck-of-cards) 

![image-20200327115838938](C:\Users\10184\Desktop\Linux-Path\Leetcode.assets\image-20200327115838938.png)

本质是求最大公约数

```c++
class Solution {
public:

    bool hasGroupsSizeX(vector<int>& deck) {
            int N = deck.size();
            unordered_map<int,int> hash;
            for(auto num : deck)
                hash[num]++;
            
            vector<int> values;
            for(auto &num:hash)
                if(num.second>0)
                    values.push_back(num.second);

            for(int i=2;i<=N;++i){
                if(N % i==0){
                    bool flag = true;

                    for(int j : values)
                        if(j %i){
                            flag = false;
                            break;
                        }
                    
                    if(flag)
                        return true;

                }
            }

        return false;
    }
};
```





## 面试题32-2 [ 从上到下打印二叉树 II](https://leetcode-cn.com/problems/cong-shang-dao-xia-da-yin-er-cha-shu-ii-lcof) 

![image-20200327123144050](C:\Users\10184\Desktop\Linux-Path\Leetcode.assets\image-20200327123144050.png)

```c++
class Solution {
public:
    vector<vector<int>> levelOrder(TreeNode* root) {
        vector<vector<int>> res;
        if(!root)
            return res;
        queue<TreeNode*> que;
        que.push(root);

        while(!que.empty()){
            vector<int> tmp;
            int qsize = que.size();
            for(int i=0;i<qsize;++i){
                TreeNode* t = que.front();
                tmp.push_back(t->val);
                que.pop();
                if(t->left) que.push(t->left);
                if(t->right) que.push(t->right);
            }
            res.push_back(tmp);
        }
        return res;
    }
};

```





## 820 [单词的压缩编码](https://leetcode-cn.com/problems/short-encoding-of-words) 

![image-20200328003018224](C:\Users\10184\Desktop\Linux-Path\Leetcode.assets\image-20200328003018224.png)



https://leetcode-cn.com/problems/short-encoding-of-words/solution/wu-xu-zi-dian-shu-qing-qing-yi-fan-zhuan-jie-guo-j/

单词反转+排序，避免了字典树的复杂，反转后当前单词只能是下一个单词的前缀

```c++
class Solution {
public:
    int minimumLengthEncoding(vector<string>& words) {
        int n = words.size();
        int sum = 0;
        vector<string> rev;
        for(auto word:words){
            reverse(word.begin(),word.end());
            rev.push_back(word);
        }

        sort(rev.begin(),rev.end());

        for(int i=0;i<n;++i){
            if(i+1 < n && !rev[i+1].find(rev[i]))
                continue;
            else
                sum +=rev[i].size()+1;
        }

        return sum;
    }
};
```



## 1162 [地图分析](https://leetcode-cn.com/problems/as-far-from-land-as-possible) 

![image-20200329083513309](C:\Users\10184\Desktop\Linux-Path\Leetcode.assets\image-20200329083513309.png)

bfs

```c++
class Solution {
public:

    const int direction[5]={0,1,0,-1,0};

    int maxDistance(vector<vector<int>>& grid) {
            int ret = 0;
            int n=grid.size();

            queue<pair<int,int>> que;
            
            for(int i =0;i<n;++i)
                for(int j=0;j<n;++j)
                    if(grid[i][j]==1)
                        que.push({i,j});
            

            if(que.size()==0 || que.size()==n*n)
                return -1;

            while(!que.empty()){
                int s = que.size();
                int r=0;
                while(s!=0){
                    pair<int,int> front = que.front();
                    que.pop();
                    for(int i=0;i<4;++i){
                        int nx = front.first+direction[i];
                        int ny = front.second+direction[i+1];
                        if(nx>=n || ny>=n || nx<0 || ny<0 || grid[nx][ny]==1)
                            continue;
                        r++;
                        //填海造陆
                        grid[nx][ny] = 1;
                        que.push({nx,ny});
                    }
                    s--;

                }
                if(r>0)
                    ret++;
           }
        return ret;
    }
};
```



## 面试题62 [圆圈中最后剩下的数字](https://leetcode-cn.com/problems/yuan-quan-zhong-zui-hou-sheng-xia-de-shu-zi-lcof) 

![image-20200330111010065](C:\Users\10184\Desktop\Linux-Path\Leetcode.assets\image-20200330111010065.png)

约瑟夫环

https://leetcode-cn.com/problems/yuan-quan-zhong-zui-hou-sheng-xia-de-shu-zi-lcof/solution/chi-jing-stsu-degd-degtsu-tu-jie-yue-se-fu-huan-hu/

```c++
class Solution {
public:
    int f(int n, int m) {
        if (n == 1) {
            return 0;
        }
        return (m + f(n-1, m)) % n; //在不考虑溢出的情况下，(a%d + c)%d == (a+c)%d
        //return (m%n + f(n-1, m)) % n;
    }
    int lastRemaining(int n, int m) {
        return f(n,m);
    }
};

```



## 912 [排序数组](https://leetcode-cn.com/problems/sort-an-array) 

![image-20200331100745933](C:\Users\10184\Desktop\Linux-Path\Leetcode.assets\image-20200331100745933.png)

桶排序

```c++
class Solution {
public:
    vector<int> sortArray(vector<int>& nums) {
        int N = nums.size();
        vector<int> counter(100001,0);
        for( int i:nums)
            counter[i+50000]++;
        
        vector<int> ans;
        for(int i=0;i<100001;++i)
            if(counter[i])
                ans.insert(ans.end(),counter[i],i-50000);
        return ans;
    }
};
```



## 1111 [ 有效括号的嵌套深度](https://leetcode-cn.com/problems/maximum-nesting-depth-of-two-valid-parentheses-strings) 

![image-20200401101555159](C:\Users\10184\Desktop\Linux-Path\Leetcode.assets\image-20200401101555159.png)

```c++
class Solution {
public:
    vector<int> maxDepthAfterSplit(string seq) {
        int d = 0;
        vector<int> ans;
        for (char& c : seq)
            if (c == '(') {
                ++d;
                ans.push_back(d % 2);
            }
            else {
                ans.push_back(d % 2);
                --d;
            }
        return ans;
    }
};

//题目难理解。。。

```



## 面试题01.07 [旋转矩阵](https://leetcode-cn.com/problems/rotate-matrix-lcci) 



![image-20200407015402727](C:\Users\10184\Desktop\Linux-Path\Leetcode.assets\image-20200407015402727.png)

先水平旋转再对角线转

```c++
class Solution {
public:
    void rotate(vector<vector<int>>& matrix) {
        int n = matrix.size();
        for(int i=0;i<n/2;++i)
            for(int j=0;j<n;++j)
                swap(matrix[i][j],matrix[n-1-i][j]);
        
        for(int i=0;i<n;++i)
            for(int j=0;j<i;++j)
                swap(matrix[i][j],matrix[j][i]);
    }
};
```

