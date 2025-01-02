// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

// 第一节：库的概念与作用
// 库的基本概念
// 库（Library）是 Solidity 中用于封装常用函数的代码模块。它允许在多个合约中复用相同的函数代码，减少重复代码，提高代码的维护性和安全性。
// 库通过关键字 library 定义，通常用于封装数学运算、数组操作等常见功能。
// 库的使用限制
// 库仅由函数组成，不能定义状态变量。
// 库不能直接修改 msg.sender 或 this，因为它们没有自己独立的上下文。
// 库函数可以是内部函数，也可以是公共或外部函数，使用不同的函数类型决定库的使用方式。
library SafeMath {
    function add(uint a, uint b) internal pure returns (uint) {
        uint c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    // 链接库
    // 当库函数是公共或外部函数时，库可以单独部署，称为“链接库”。
    // 链接库在以太坊上有独立的地址，合约在调用时会通过委托调用的方式使用库函数。
    // 链接库的部署可以减少重复部署的 Gas 消耗，但库函数的变量会使用主调合约的上下文。
    function add2(uint a, uint b) external pure returns (uint) {
        uint c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }
}

contract AddTest {
    function addNumbers(uint x, uint y) public pure returns(uint) { // addNumbers 函
        uint c = SafeMath.add(x, y);
        return c;
    }

    function add2(uint x, uint y) public pure returns (uint) {
        return SafeMath.add2(x, y);  // 链接库函数调用
    }
}

// 第三节：using for 语法扩展库的使用
// 1. using for 语法的作用
// using for 语法允许将库的函数绑定到特定的数据类型，使得库函数可以直接作用于该数据类型的变量，简化函数调用。
// **示例：使用 ** using for 绑定类型
// 通过 using for 语法将 SafeMath 库函数绑定到 uint 类型：}
contract TestLibraryIn {
    using SafeMath for uint;
    function add(uint x, uint y) public pure returns (uint) { // addNumbers 函
        uint z = x.add(y);
        return z;
    }
}