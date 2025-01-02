// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Bytes {

    // 在 Solidity 中，bytes 和 string 类型可以通过显式转换实现相互转换。这一功能特别适用于那些需要在两种格式之间灵活切换的场景。具体的转换方法如下：
    // 使用 bytes(str) 可以将 string 类型转换为 bytes 类型。这一转换方法可以让您将字符串直接转化为字节序列。
    // 使用 string(myBytes) 可以将 bytes 类型转换成 string 类型。这允许您把字节序列转换回人类可读的文本格式。
    // 这种转换是显式的，意味着您需要在代码中明确指定转换的发生，以确保数据类型的正确处理和程序的可读性。

    // bytes 转 string
    bytes  bstr = new bytes(10);
    string message = string(bstr); // 使用string()函数转换_
    
    // string 转 bytes
    string  message1 = "hello world";
    bytes  bstr2 = bytes(message1); //使用bytes()函数转换_


    // string 不能进行下标访问，也不能获取长度 在 Solidity 中，虽然 string 类型在本质上是一个字符数组，但它目前不支持下标访问和获取长度的操作。
    // 这意味着与其他数组类型不同，您不能通过索引来访问 string 中的单个字符，也无法直接查询 string 的长度。这些限制要求开发者在处理字符串数据时采用不同的方法或转换为更灵活的数据类型如 bytes，以进行更复杂的操作。
    // string str = "hello world";
    // uint len = str.length; _// 不合法，不能获取长度_
    // bytes1 b = str[0]; _// 不合法，不能进行下标访问_

    // 你可以将 string 转换成 bytes 后再进行下标访问和获取长度
    // 将 string 转换成 bytes 后再进行下标访问和获取长度
    string str = "hello world";
    uint len = bytes(str).length; // 合法_
    bytes1 b = bytes(str)[0];     // 合法_


}