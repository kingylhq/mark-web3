// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

interface ERC777TokensRecipient { 

    // 用于通知接受代币。
    // 注意: 请勿在发送（或 ERC20 transfer）或 铸币 之外调用。
    // 接口ID: 0023de29
    // 参数：
    // operator: 操作员（触发者）
    // from: 从哪个地址扣除(铸币为0x0)
    // to: 接收者
    // amount: 数量
    // data: 持有者信息
    // operatorData: 操作员信息

    // 调用tokensReceived钩子函数的规则复杂: https://learnblockchain.cn/docs/eips/eip-777.html#
    function tokensReceived( 
        address operator, 
        address from, 
        address to, 
        uint256 amount, 
        bytes calldata data, 
        bytes calldata operatorData ) external; 
        
}