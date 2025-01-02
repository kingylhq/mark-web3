// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "./IERC20.sol";

// ERC20Detailed 的实现比较简单，仅仅初始化代币名称、代币符号、小数位数这 3 个变量，代码如下：
abstract contract ERC20Detailed is IERC20 { 
    
    string private _name; 
    string private _symbol; 
    uint8 private _decimals; 
    constructor (string memory name, string memory symbol, uint8 decimals)  { 
        _name = name; 
        _symbol = symbol; 
        _decimals = decimals; 
    } 
    function name() public view returns (string memory) { 
        return _name; 
    } 
    function symbol() public view returns (string memory) { 
        return _symbol; 
    } 
    function decimals() public view returns (uint8) { 
        return _decimals; 
    } 
}