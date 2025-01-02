
// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

// 引用数据类型
contract  Conver {

    // uint mmm = 2100000000;
    // int8 y = -3; 
    // uint x = uint(y); 
    // 如果转换成更小的类型，变量的值会丢失高位。 
    // uint32 public a = 0x12345678; 
    // uint16 public b = uint16(a); // b = 0x5678 

    // 转换成更大的类型，将向左侧添加填充位 
    // uint16 public a = 0x1234;
    // uint32 public b = uint32(a); // b = 0x00001234 

    //转换到更小的字节类型，会丢失后面数据。 
    // bytes2 public a = 0x1234;   // a = 0x1234
    // bytes1 public b = bytes1(a); // b = 0x12 

    //转换为更大的字节类型时，向右添加填充位。 
    bytes2 public  a = 0x1234;    // a = 0x1234
    bytes4 public  b = bytes4(a); // b = 0x12340000 

    //把整数赋值给整型时，不能超出范围，发生截断，否则会报错。 
    // uint8 a = 12; // 正确 
    // uint32 b = 1234; // 正确 
    // uint16 c = 0x123456; // 错误
   
}

