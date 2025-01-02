// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

// 这一个实战主要是加深大家对 3 个取钱方法的使用。

// 任何人都可以发送金额到合约
// 只有 owner 可以取款
// 3 种取钱方式
contract EtherWallet {
    address payable public immutable owner;
    event Log(string funName, address from, uint256 amount, bytes data);

    constructor() {
        owner = payable(msg.sender);
    }

    receive() external payable {
        emit Log("receive", msg.sender, msg.value, ""); // 此处不可以加 payable 关键字，因为不知道发送方是谁，因此无法获取到钱的来源。
    }

    // 函数修饰器，减少代码重复
    modifier onlyOwner() {
        require(msg.sender == owner, "Not Owner");
        _;
    }

// 特性	    transfer	      send                     call
// Gas限制	固定2300 gas       固定 2300 gas	        无限制（可指定 gas）
// 错误处理	自动回滚	        返回布尔值（需手动处理）	 返回布尔值（需手动处理）
// 灵活性	仅用于转账	        仅用于转账	               转账 + 调用其他功能（万能调用）
// 推荐场景	简单转账	        需要手动控制失败处理的场景	  高度灵活（复杂调用、合约间交互）
// 安全性	安全，防止回调攻击	 安全，需处理失败情况	      更高的安全风险：由于没有 gas 限制, 易受重入攻击影响, 错误处理复杂，不会自动回滚

    function withdraw_1() external onlyOwner {
        payable(msg.sender).transfer(100);
    }

    function withdraw_2() external onlyOwner {
        bool success = payable(msg.sender).send(100);
        require(success, "Send Failed");
    }

    function withdraw_3() external onlyOwner {
        (bool ok, bytes memory data) = msg.sender.call{
            value: address(this).balance
        }(""); // value参数不要去掉
        require(ok, "Call Failed"); 
    }

}
