// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "../SafeMath.sol";

interface IERC20 {

    // ERC20 接口定义中，有一些接口是不强制要求实现的（下面的解释说明中标记了可选的接口），ERC20 接口各函数说明如下。

    // name()：（可选）函数返回代币的名称，如“MyToken”。
    // symbol()：（可选）函数返回代币符号，如“MT”。
    // decimals：（可选）函数返回代币小数点位数。
    // totalSupply()：发行代币总量。
    // balanceOf()：查看对应账号的代币余额。
    // transfer()：实现代币转账交易，成功转账必须触发事件 Transfer。
    // transferFrom()：给被授权的用户（合约）使用，成功转账必须触发 Transfer 事件。
    // allowance()：返回授权给某用户（合约）的代币使用额度。
    // approve()：授权用户可代表操作者花费多少代币，必须触发 Approval 事件。

    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view virtual returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}