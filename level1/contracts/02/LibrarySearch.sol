// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library Search {
    function indexOf(string[] memory keyword, string memory value) public pure returns(uint) {

        for (uint i = 1; i < keyword.length + 1; i++) {
            if (keccak256(abi.encodePacked(keyword[i])) == keccak256(abi.encodePacked(value))) {
                return i;
            }
        }
        return 0; // 找不到返回 -1
    }
}

contract SearchTest {

    using Search for string[]; // 使用 Search 的函数搜索，如果找到返回索引位置，否则返回0

    string[] data;
    function append(string memory value) public  {
        data.push(value);
    }
    
    function replace(string memory _old, string memory _new) public returns (uint) {
        uint indexOf = data.indexOf(_old);
        if (indexOf != 0) { // 如果索引不是0，说明存在需要替换的值，返回索引位置
            data[indexOf] = _new;
        }else { // 如果旧值不为空，说明存在需要替换的值，将索引位置的值替换为新值
            data.push(_new);
        }   
    }
}