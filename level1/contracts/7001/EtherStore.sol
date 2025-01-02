// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract EtherStore {

    uint256 public withdrawalLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;

    function depositFunds() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdrawFunds(uint256 _weiToWithdraw) public {

        require(balances[msg.sender] >= _weiToWithdraw, "Insufficient balance");

        // 限制允许提现的时间
        require(block.timestamp >= lastWithdrawTime[msg.sender] + 1 weeks, "Withdrawal not allowed yet");

        // 限制提现金额
        require(_weiToWithdraw <= withdrawalLimit, "Exceeds withdrawal limit");
        
        // 使用新的 call 语法，并传递空的 calldata
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Transfer failed");


        balances[msg.sender] -= _weiToWithdraw;
        lastWithdrawTime[msg.sender] = block.timestamp;
    }
}

// 加互斥锁
// 初始化互斥锁、并且用transfer调用
// contract EtherStore {
//     bool reEntrancyMutex = false;
//     uint256 public withdrawalLimit = 1 ether;
//     mapping(address => uint256) public lastWithdrawTime;
//     mapping(address => uint256) public balances;
    
//     function depositFunds() public payable {
//         balances[msg.sender] += msg.value;
//     }
    
//     function withdrawFunds(uint256 _weiToWithdraw) public {
//         require(!reEntrancyMutex);
//         require(balances[msg.sender] >= _weiToWithdraw);
//         // 限制取款金额
//         require(_weiToWithdraw <= withdrawalLimit);
//         // 限制取款时间
//         require(block.timestamp >= lastWithdrawTime[msg.sender] + 1 weeks);
//         balances[msg.sender] -= _weiToWithdraw;
//         lastWithdrawTime[msg.sender] = block.timestamp;
//         // 在外部调用前设置互斥锁
//         reEntrancyMutex = true;
//         payable(msg.sender).transfer(_weiToWithdraw);
//         // 在外部调用后释放互斥锁
//         reEntrancyMutex = false;
//     }
// }