// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Constructor {

    // 使用构建函数初始化
    // 在 Solidity 中使用硬编码的初始值来初始化状态变量可能有效，但这种方法在需要部署具有不同初始值的多个合约版本时，
    // 会显示出其局限性。如上所述，如果需要改变变量 a 的初始值从 1 变为 2，直接修改合约代码中的 uint a = 1; 为 uint a = 2; 
    // 不仅容易出错，而且在合约中如果存在多个相互依赖的状态变量时，这种方法的复杂性会迅速增加。
    // 为了解决这个问题，构造函数提供了一种优雅的解决方案，它允许在部署合约时动态地初始化状态变量。
    // 构造函数可以将初始化的复杂性封装起来，使得部署新合约变得更加简单和可控。下面是如何使用构造函数来初始化状态变量的示例：
    // 构建函数初始化合约状态

    uint a; // 状态变量声明，但是还没初始化_
    constructor(uint aVal) {
        a = aVal; // 将 a 的值初始化为 aVal_
    }

    // 定义了上面的合约后，我们就可以使用 new 关键字来新建一个 a 的初始值为 2 合约：
    // ExampleContract c = new ExampleContract(2);
    // 从上面的例子中，我们可以观察到定义构建函数的语法是相对简单明了的：
    // constructor(parameter-list) {
    //     _// constructor body_
    // }
    // 其中 parameter-list 是以逗号为分割的参数列表，// construcotr body 就是构建函数的函数主体。
    }