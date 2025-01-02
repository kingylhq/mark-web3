// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract ForWhile {

    // for 循环，从 1 加到 N
    function sumToNFor(uint16 n) public pure returns(uint16) {
        uint16 sum = 0;
        uint16 i = 1;   // 这里的变量声明在最前面, 也可以声明在for括号里面，多种方式
        for(; i <= n; ) { // 循环控制语句只剩下test-statement: i <= n_
            sum += i;
            i++; // 修改循环变量的值_
        }
        return sum;
    }

    // 其实这种形式就类似于 while 循环，我们可以稍作修改就变成 while 循环：
    // while 循环，从 1 加到 N
    function sumToNWhile(uint16 n) public pure returns(uint16) {
        uint16 sum = 0;
        uint16 i = 1; 
        while(i <= n) { //只改了这一行_
            sum += i;
            i++; // 修改循环变量的值_
        }
    }
        
        
    // do while 循环区别于 while 循环的地方是，它的循环体至少会执行一遍。然后才会执行 test-statement 判断是否为 true 。
    // 如果是则把循环体再执行一遍。如果 test-statement 为 false ，那么退出循环并继续执行余下的代码。
    // do while 循环, 从 1 加到 N
    function sumToNDoWhile(uint16 n) public pure returns(uint16) {
        uint16 sum = 0;
        uint16 i = 1; 
        do {
            sum += i;
            i++; // 修改循环变量的值_
        } while(i <= n); // 检查是否还满足循环条件_
        
        return sum;
    }

    // do-while 循环与 for 和 while 循环存在一个明显的区别：do-while 循环保证了循环体至少被执行一次，即使循环条件一开始就不满足。
    // 相反，for 和 while 循环在条件不满足时可能一次都不执行。因此，当你需要确保循环体至少执行一次时，使用 do-while 循环是更自然、更清晰的选择。
    // 使用它并非必须，但它可以让控制逻辑看起来更直观，代码更简洁。

    // 总的来说，for、while 和 do-while 三种循环在功能上相似，都能完成重复执行代码的任务。for 和 while 循环在使用上比较相似，
    // 可以根据个人偏好或代码的清晰度来选择。而 do-while 循环通常用在至少需要执行一次循环体的场景中。
    // 选择合适的循环类型可以根据具体的应用场景和代码可读性的需求来决定。

}