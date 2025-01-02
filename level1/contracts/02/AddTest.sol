// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "./Library.sol";

// 第二节：内嵌库与链接库
// 内嵌库
// 如果库函数都是内部函数（internal），编译器会将库函数的代码直接嵌入到调用合约中。库不会被单独部署，这种方式称为“内嵌库”。
// 示例：使用内嵌库的 AddMark 合约
contract AddMark {

    function addNum(uint _num1, uint _num2) public view returns (uint) {
        uint res = SafeMath.add(_num1, _num2);
        return res;
    }
    
}