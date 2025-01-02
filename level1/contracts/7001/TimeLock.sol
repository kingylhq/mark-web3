// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;
import "./SafeMath.sol";

// 防止溢出漏洞的（当前）常规技术是使用或建立替代标准数学运算符的数学库；包括加法、减法和乘法
// （除法被排除在外，因为它不会导致上溢/下溢、 并且 EVM 除以 0 时会抛出错误）。
contract TimeLock {

    // block.timestamp  表示当前区块的时间戳，使用安全的数学库来保证数据操作不会上下溢出
    using SafeMath for uint256; // use the library for uint type
    mapping(address => uint256) public balances;
    mapping(address => uint256) public lockTime;

    function deposit() public payable {
        balances[msg.sender] = balances[msg.sender].add(msg.value);
        lockTime[msg.sender] = block.timestamp.add(1 weeks);
    }

    function increaseLockTime(uint256 _secondsToIncrease) public {
        lockTime[msg.sender] = lockTime[msg.sender].add(_secondsToIncrease);
    }

    function withdraw() public {
        require(balances[msg.sender] > 0);
        require(block.timestamp > lockTime[msg.sender]);
        balances[msg.sender] = 0;
        payable(msg.sender).transfer(balances[msg.sender]);
    }

}
