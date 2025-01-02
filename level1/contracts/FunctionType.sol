
// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

// Solidity中的函数可见性修饰符有四种，决定了函数在何处可以被访问：
// private （私有）：
// 只能在定义该函数的合约内部调用。
// internal （内部）：
// 可在定义该函数的合约内部调用，也可从继承该合约的子合约中调用。
// external （外部）：
// 只能从合约外部调用。如果需要从合约内部调用，必须使用this关键字。
// public （公开）：
// 可以从任何地方调用，包括合约内部、继承合约和合约外部
contract  VisibilityExample {

    function privateFunction() private pure returns (string memory) {
        return "Private";
    }
    function internalFunction() internal pure returns (string memory) {
        return "Internal";
    }
    function externalFunction() external pure returns (string memory) {
        return "External";
    }
    function publicFunction() public pure returns (string memory) {
        return "Public";
    }
    
}

// 状态可变性修饰符：
// Solidity 中有三种状态可变性修饰符，用于描述函数是否会修改区块链上的状态：
// view：
// 声明函数只能读取状态变量，不能修改状态,读取链上状态。
// pure：
// 声明函数既不能读取也不能修改状态变量，通常用于执行纯计算。
// payable：
// 声明函数可以接受以太币，如果没有该修饰符，函数将拒绝任何发送到它的以太币。
contract SimpleStorage {

    uint256 private data;

    function setData(uint256 _data) external {
        data = _data;  // 修改状态变量
    }
    function getData() external view returns (uint256) {
        return data;  // 读取状态变量
    }
    function add(uint256 a, uint256 b) external pure returns (uint256) {
        return a + b;  // 纯计算函数
    }
    function deposit() external payable {
        // 接收以太币
    }
}

// 作业
// 编写一个合约，定义不同可见性和状态可变性的函数，并进行测试。
// 实现一个函数，接受两个参数并返回它们的和与积。
// 创建一个 payable 函数，允许用户向合约发送以太币，并记录发送金额。

contract Homework {

    address owner;

    // 用于记录每个地址发送的以太币总金额
    mapping (address => uint256) public balances;

    // 两数相加和相乘
    // function cal(uint x, uint y) external pure returns (uint, uint) { 
    //     return (x + y, x * y);
    // }

    // sendEther():
    // 使用了 payable 修饰符，允许函数接收以太币。
    // msg.value 表示用户发送的以太币数量。
    // 将发送的以太币金额累加到 balances 映射中，以记录每个地址的发送总额。
    // getContractBalance():
    // 返回合约的当前余额，使用 address(this).balance 获取合约地址的余额。

    // withdraw():
    // 合约所有者可以提取合约中的所有余额。
    // 使用 payable(owner).transfer(...) 将余额发送到所有者地址。
    // 构造函数:

    // 在合约部署时记录合约的所有者，只有所有者可以调用 withdraw。

    // 允许用户发送Ethe 以太币的paytable函数
    function sendEther() public payable {
        require(msg.value > 0, "Your must send more Ether");
        // 记录发送金额
        balances[msg.sender] += msg.value;
    }
    // 获取当前合约的余额
    function getContractBalance() public view returns(uint256) {
        return address(this).balance;
    }

    constructor() {
        owner = msg.sender;
    }
    // 合约所有者可以提取合约中的所有余额
    function withdraw() public {
        require(msg.sender == owner, "Only the owner can withdraw");
        payable(owner).transfer(address(this).balance);
    }
}