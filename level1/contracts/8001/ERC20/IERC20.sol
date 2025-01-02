// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

interface IERC20 {

    // 标准 ERC20 接口
    // 3 个查询

    // balanceOf: 查询指定地址的 Token 数量
    // totalSupply: 查询当前合约的 Token 总量
    // allowance: 查询指定地址对另外一个地址的剩余授权额度
    // 2 个交易

    // transfer: 从当前调用者地址发送指定数量的 Token 到指定地址。
    // 这是一个写入方法，所以还会抛出一个 Transfer 事件。
    // transferFrom: 当向另外一个合约地址存款时，对方合约必须调用 transferFrom 才可以把 Token 拿到它自己的合约中。
    // 2 个事件

    // Transfer
    // Approval
    // 1 个授权

    // approve: 授权指定地址可以操作调用者的最大 Token 数量。

    // 1个授权
    function approve(address spender, uint256 amount) external returns (bool);

    // 2个事件
    event Transfer(address indexed from, address indexed to, uint256 amount);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 amount
    );

    // 2个交易
    function transfer(address recipient, uint256 amount)external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    // 3个查询
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function allowance(address owner, address spender)external view returns (uint256);
        
}
