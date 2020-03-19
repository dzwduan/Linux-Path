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