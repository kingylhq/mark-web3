// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;


contract Bytes {


    bytes1 public byte1 = 0x1a; // 定义 bytes1 类型
    bytes1 public byte2 = 0x1f; // 定义 bytes1 类型

    function compare() public view returns (string memory) {
        if (byte1 > byte2) {
            return "byte1 is greater than byte2";
        } else if (byte1 < byte2) {
            return "byte1 is less than byte2";
        } else {
            return "byte1 is equal to byte2";
        }
    }
}