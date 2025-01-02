// SPDX-License-Identifier: MIT
pragma solidity  0.8.26;

contract SolidityTest {

    // Solidity 支持三种类型的变量：
    // 状态变量（变量值永久保存在合约存储空间中的变量）、
    // 局部变量（变量值仅在函数执行过程中有效的变量，函数退出后，变量无效）、
    // 全局变量（保存在全局命名空间，用于获取区块链相关信息的特殊变量）。
    // Solidity 是一种静态类型语言，这意味着需要在声明期间指定变量类型。每个变量声明时，都有一个基于其类型的默认值。没有 undefined 或 null 的概念。

    uint storeData; // 状态变量

    int8 public minInt = type(int8).min;
    int8 public maxInt = type(int8).max;

    constructor() public {

        storeData = 10; // 状态变量
    }

    function getInt8Limit() public view returns(int8, int8) {
        return (minInt, maxInt);
    }

    function getInt16Limit() public view returns(int16, int16) {
        return (type(int16).min, type(int16).max);
    }

    function getResult() public view returns(uint){
        uint a = 1; // 局部变量
        uint b = 2;
        uint result = a + b;
        return result;
    }

    // 全局变量
    // blockhash(12121);
    // block.coinbase  // 当前区块旷工地址
    // block.difficulty// 当前区块难度
    // block.gaslimit  // 当前区块gaslimit
    // block.number    // 当前区块number
    // block.timestamp // 当前区块的时间戳，为 unix 纪元以来的秒

    // gasleft();      // 剩余的gas

    // msg.data        // 完成的calldata
    // msg.sender      // 消息发送者 (当前 caller)
    // msg.sig         // calldata 的前四个字节 (function identifier)
    // msg.value       // 当前消息的 wei 值
    // now             // 当前块的时间戳
    // tx.gasprice (uint) 交易的 gas 价格
    // tx.origin       // 交易的发送方


}