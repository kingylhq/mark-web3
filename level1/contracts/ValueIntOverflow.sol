
// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract  ValueInt {

    // 整型
    int8 a2 = -1;
    int16 b2 = 2; 
    uint32 c2 = 10; 
    uint8 d2 = 16;

    // 整型支持以下几种运算符：

    // 比较运算符： <=（小于等于）、<（小于） 、==（等于）、!=（不等于）、>=（大于等于）、>（大于）
    // 位操作符： &（和）、|（或）、^（异或）、~（位取反）
    // 算术操作符：+（加号）、-（减）、-（负号）、* （乘法）、/ （除法）, %（取余数）, **（幂）
    // 移位： <<（左移位）、 >>（右移位）
    // 这里略作说明：

    // ① 整数除法总是截断的，但如果运算符是字面量（字面量稍后讲)，则不会截断。

    // ② 整数除 0 会抛出异常。

    // ③ 移位运算结果的正负取决于操作符左边的数。x << y 和 x * (2**y) 是相等的，x >> y 和 x / (2*y) 是相等的。

    // ④ 不能进行负移位，即操作符右边的数不可以为负数，否则会在运行时抛出异常。

    // 这里提供一段代码来让大家熟练一不同操作符的使用，运行之前，先自己预测一下结果，看是否和运行结果不一样。

    /*加减乘除，位移**/
    function add(uint x, uint y) public pure returns (uint z) {
        z = x + y;
    }

    function divide(uint x, uint y ) public pure returns (uint z){
        z = x / y; 
    } 
    function leftshift(int x, uint y) public pure returns (int z){
        z = x << y; 
    } 
    function rightshift(int x, uint y) public pure returns (int z){
        z = x >> y; 
    } 
    function testPlusPlus() public pure returns (uint ) { 
        uint x = 1; uint y = ++x; // c = ++a; 
        return y; 
    } 

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
    } 
    function sub1() public pure returns (uint8) { 
        uint8 m = 1; 
        uint8 n = m - 2; 
        return n; 
    }

}