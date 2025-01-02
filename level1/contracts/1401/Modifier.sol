// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Modifier {

    // 在 Solidity 中，修饰器（modifier）是一种特殊的声明，它用于修改智能合约函数的行为。
    // 通过在函数执行前添加预处理和验证逻辑，修饰器可以确保函数在特定条件下运行，例如验证函数的输入参数是否符合预设标准，
    // 或确认调用者是否具备特定权限。使用修饰器不仅能增强代码的复用性，还能提升其可读性。

    // 举个例子，考虑以下情况：在一个合约中，几个函数（如 mint、changeOwner、pause）需要确保只有合约的所有者（owner）才能调用它们。
    // 通常，我们需要在每个这样的函数前用 require(msg.sender == owner, "Caller is not the owner"); 来检查调用者的身份。
    // 这种逻辑在多个函数中重复出现，不仅冗余，而且每次更改时都需要手动更新每个函数。
    // 用 require 来进行权限检查

    address private owner;
    constructor() {
        owner = msg.sender;
    }

    // 将权限检查抽取出来成为一个修饰器
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    // 添加 onlyOwner 修饰器来对调用者进行限制, 添加多个修饰器(修饰器名称用逗号分割)它们的执行顺序是从左到右的
    // 只有 owner 才有权限调用这个函数
    function mint() external onlyOwner { 
        // Function code goes here
    }

    // 添加 onlyOwner 修饰器来对调用者进行限制
    // 只有 owner 才有权限调用这个函数
    function changeOwner() external onlyOwner {
        // Function code goes here
    }

    // 添加 onlyOwner 修饰器来对调用者进行限制
    // 只有 owner 才有权限调用这个函数
    function pause() external onlyOwner {

    }

}