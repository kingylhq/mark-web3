// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;


// 如果持有者希望在转账时收到代币转移通知，需要实现 ERC777TokensSender 接口，ERC777TokensSender 接口
interface ERC777TokensSender { 

    // 通知（或请求）从持有人地址发送或销毁 amount 数量的代币。
    // 注意: 请勿在发送（或 ERC20 transfer）或 销毁 之外调用。
    // 接口ID: 75ab9782
    // 参数：
    // operator: 操作员（触发者）
    // from: 从哪个地址扣除
    // to: 接收着(销毁时为0x0)
    // amount: 数量
    // data: 持有者信息
    // operatorData: 操作员信息

    // 调用tokensToSend钩子函数的规则复杂: https://learnblockchain.cn/docs/eips/eip-777.html#
    function tokensToSend( 
        address operator, 
        address from, 
        address to, 
        uint256 amount, 
        bytes calldata userData, 
        bytes calldata operatorData 
    ) external; 
    
}