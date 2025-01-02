// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract ActionChoices {


    enum ActionChoices { 
        GoLeft,     // 底层表示为 0
        GoRight,    // 底层表示为 1
        GoUp,       // 底层表示为 2
        GoDown      // 底层表示为 3
    }

    function compare() public view returns (ActionChoices, ActionChoices) {
        ActionChoices max = type(ActionChoices).max; // ActionChoices.GoDown ，也就是3
        ActionChoices min = type(ActionChoices).min; // ActionChoices.GoLeft ， 也就是0
        return (max, min);
    }

    // 枚举类型与整型的互相转换
    function enumToUint(ActionChoices c) public pure returns(uint) {
        return uint(c);
    }

    function uintToEnum(uint i) public pure returns(ActionChoices) {
        return ActionChoices(i);
    }

    // 枚举类型作为函数参数或返回值
    // 如果枚举类型仅在当前合约中定义，那么外部合约在调用当前合约时得到的枚举类型返回值会被编译器自动转换成 uint8 类型。
    // 因此，外部合约看到的枚举类型实际上是 uint8 类型。这是因为 ABI（应用二进制接口）中不存在枚举类型，只有整型，所以编译器会自动进行这种转换。
    // 例如，在下面的示例中，函数 getChoice 的返回值是 ActionChoices 类型。编译器会自动将其更改为 uint8 类型，因此外部合约看到的返回值类型是 uint8 类型。
    ActionChoices choice;

    // 因为ABI中没有枚举类型，所以这里的"getChoice() returns(ActionChoices)"函数签名_
    // 会被自动转换成"getChoice() returns(uint8)"_
    function getChoice() public view returns (ActionChoices) {
        return choice;
    }
}