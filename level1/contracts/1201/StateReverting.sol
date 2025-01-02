// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract StateReverting {

    // 合约执行过程中往往会出现一些异常状况，比如输入参数不合法，算术运算时除以 0，整型溢出等等。如果出现这些情况，我们就需要进行异常处理。
    // Solidity 异常处理的统一原则是状态回滚（state reverting），也就是恢复执行前的状态，就好像什么都没有发生一样。目前 Solidity 
    // 提供了三个异常处理的函数：
    // require
    // assert
    // revert

    // require 语法
    // require(condition, "My error string");
    // 在智能合约中，require 函数是用于处理异常情况的关键工具。它接受一个布尔表达式作为条件，如果该条件评估为 false，则会立即抛出异常并终止执行，
    // 同时撤销所有改变，使所有状态变量恢复到事务开始前的状态。
    // 例如，考虑下面的用例，其中一个智能合约需要将传入的以太币（Ether）平均分配到两个不同的地址 addr1 和 addr2。在进行转账之前，
    // 我们使用 require 来确保传入的以太币数量是偶数，以便能够平均分配：
    //ETHER 对半分账
    function Require(address payable addr1, address payable addr2) public payable {
        // 第一个条件返回为truec，程序继续往下执行
        require(msg.value % 2 == 0, "Even value required."); // 检查传入的ether是不是偶数
        addr1.transfer(msg.value / 2);
        addr2.transfer(msg.value / 2);
    }

    // assert 语法
    // assert(condition);
    // 其中 condition 是布尔表达式，如果其结果是 false 那么就会抛出异常。然后所有状态变量都会恢复原状。
    // 例如下面的示例中，把传入的 Ether 分为两半，一半转入地址 addr1 ，另一边转到地址 addr2 。在实际分账之前，使用 require 先检查传入的 Ether 是不是偶数。在分账完成后，使用 assert 检查分账前后，合约的 balance 不受影响。
    // ETHER 对半分账
    function Assert(address payable addr1, address payable addr2) public payable {
        require(msg.value % 2 == 0, "Even value required."); // 检查传入的ether是不是偶数_
        uint balanceBeforeTransfer = address(this).balance;
        addr1.transfer(msg.value / 2);
        addr2.transfer(msg.value / 2);
        assert(address(this).balance == balanceBeforeTransfer); // 检查分账前后，本合约的balance不受影响_
    }
    // assert 与 require 的区别
    // 在 Solidity 中，assert 和 require 都用于检查异常情况并在条件不满足时抛出异常。虽然它们在行为上相似，主要区别在于它们的使用场景和语义意义。

    // require: 通常用于验证外部输入、处理条件和确认合约的交互符合预期。它主要用于可恢复的错误或者在正常的业务逻辑中检查条件，比如验证用户输入、
    // 合约状态条件或执行前的检查。如果 require 检查失败，会撤销所有修改并退还剩余的 gas。
    // assert: 用于检查代码逻辑中不应发生的情况，主要是内部错误，如不变量的检查或某些后置条件，这些通常指示合约存在 Bug。assert 
    // 应仅在确定有逻辑错误时使用，因为如果 assert 失败，它表示一个严重的错误，通常是编码或逻辑错误，需要马上修复。与 require 不同，
    // assert 失败将消耗所有提供的 gas，并回滚所有修改。
    // 使用 require 和 assert 的这种区分是一种编程惯例，有助于提高代码的清晰度和维护性。正确地使用这两者，不仅可以确保合约逻辑的正确性，
    // 还能帮助开发者更快地定位问题所在。尽管可以交替使用这两个关键字而不影响合约的功能，这样做通常会使得合约的可读性和可维护性降低。
    // 正确的使用习惯是根据错误的类型和来源来选择使用 require 还是 assert。


    // revert 与 require 功能上有些相似，它们都用于异常处理并撤销所有状态变化。然而，revert 的使用更为直接：它不像 require 那样进行条件检查
    // 而是立即抛出异常。这使得 revert 非常适用于那些需要立即中止执行并恢复合约到执行前状态的场景。
    // revert 的灵活性表现在它可以与 if-else 语句结合使用，提供比 require 更精细的控制逻辑。例如，在一些复杂的逻辑判断中，使用 revert 
    // 加上 if-else 结构可以根据多个条件决定是否应该终止执行。这种方法虽然在表达能力上非常强，但可能牺牲一些代码的直观性和易读性，
    // 这是在使用时需要考虑的一个权衡点。

    // revert 语法
    // 使用方式一
    // revert CustomError(arg1, arg2);

    // 使用方式二
    // revert("My Error string");
    // 其中 CustomError 是自定义的 Error
    // 例如下面的示例中，把传入的 Ether 分为两半，一半转入地址 addr1 ，另一边转到地址 addr2 。在实际分账之前，使用 revert 先检查传入的 Ether 是不是偶数。
    // ETHER 对半分账
    function Revert(uint num) public  {
        if (num % 2 != 0) { // 检查传入的 num 不是偶数
            revert("Even value revertd.");
        } 

    }
    // revert 与 require 的区别
    // 在前面的讨论中，我们提到了 revert 可以在某些复杂的情况下替代 require 来停止执行并抛出异常。这里，我们将展示两种表达方式在功能上是等价的，
    // 但各自适用于不同的编程风格和场景。

    // require 与 revert 的等价表达式
    // 判断是否是偶数
    // require(msg.value % 2 == 0, "Even value revertd.");
    // 等价于：

    // if (msg.value % 2 == 0) {
    //     revert("Even value revertd.");
    // }

    // 在一些复杂的逻辑嵌套中，使用 revert 会更加方便，清晰：
    // if(condition1) {
    //     // 可能有更多的 if-else 嵌套_
    //     if(condition2) {
    //         // do something_
    //     } 
    //     revert("condition2 not fulfilled");
    // }


    
}