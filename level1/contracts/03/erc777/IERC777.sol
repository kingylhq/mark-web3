// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

// 发送代币 发送代币功能上和 ERC20 的转账类似，
// 但是 ERC777 的发送代币可以携带更多的参数，ERC777 发送代币使用以下两个方法
interface IERC777 {

    // 发送通知
    function send(address to, uint256 amount, bytes calldata data) external;

    // 操作者发送
    function operatorSend( 
        address from, 
        address to, 
        uint256 amount, 
        bytes calldata data, 
        bytes calldata operatorData) external;
}
