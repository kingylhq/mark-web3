// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;
import "./ERC20Detailed.sol";
import "./ERC20.sol";

//  标准 ERC20 实现
// 有了 ERC20.sol 和 ERC20Detailed.sol，实现一个自己的代币就很简单了，现在尝试实现一个有 4 位小数、名称为 My Token 的代币，只需要以下几行代码：
contract MyToken is ERC20 , ERC20Detailed("My ERC Token LSY", "MT", 4){

    constructor() public { 
        // _mint()函数在 ERC20.sol 中实现的，用来初始化代币发行量。
        _mint(msg.sender, 1000000000 * 10 ** 4); 
    } 

}