
// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract  ValueType {

    // 值类型

    bool public isActive = true;

    int8 a = 32;  // -128-127
    uint8 b = 32; //0-127

    int256 c = 1e18;

    bytes1 by = 0x12;
    // 有理数和整形常量
    //  uint256 d = 1234
    uint256 e = 1.5 * 1e18;

    // 字符串
    string s = "mark"; // 不可变的文本数据

    // 枚举
    enum Status {success, fail, ing}
    Status public currentStatus;

    function setStatus(Status _status) public {
        currentStatus = _status;
    }

    // 地址类型,存储以太坊地址，特殊的字符串类型，20个字符串
    address owner = msg.sender;

    // 地址常量
    // address constant fixexAddress = "";

    function getA() public view returns(uint256) {
        return 1e18;
    }

    // 引用类型
    
}

