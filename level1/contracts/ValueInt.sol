
// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract  ValueIntOverFlow {

    // 整型溢出问题 在使用整型时，要特别注意整型的大小及所能容纳的最大值和最小值，如 uint8 的最大值为 0xff（即：255），最小值是 0，
    // 可以通过 Type(T).min 和 Type(T).max 获得整型的最小值与最大值。
    function add1() public pure returns (uint8) { 
        uint8 x = 128; 
        uint8 y = x * 2; 
        return y; 
    } 
    function add2() public pure returns (uint8) { 
        uint8 i = 240; 
        uint8 j = 16; 
        uint8 k = i + j; 
        return k;
    } 
    function sub1() public pure returns (uint8) { 
        uint8 m = 1; 
        uint8 n = m - 2; 
        return n; 
    }

    // 揭晓一下上述代码的运行结果：add1()的结果是 0，而不是 256，add2() 的结果同样是 0，sub1 是 255，而不是-1。

    // 溢出就像时钟一样，当秒针走到 59 之后，下一秒又从 0 开始。

    // 业界名气颇大的 BEC，就曾经因发生溢出问题被交易所暂停交易，损失惨重。

    // 防止整型溢出问题，一个方法是对加法运算的结果进行判断，防止出现异常值，例如：

    function add(uint256 a, uint256 b) internal pure returns (uint256){ 
        uint256 c = a + b; 
        require(c >= a); // 做溢出判断，加法的结果肯定比任何一个元素大。
        return c; 
    }
    // 以上函数使用 require 进行条件检查，当条件为 false 的时候，就是抛出异常，并还原交易的状态，关于 require 的使用在后面作进一步介绍。
    


}