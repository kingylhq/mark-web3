// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

// Solidity 提供了以下主要函数来进行错误处理：
// assert(bool condition)：检查内部错误或逻辑错误。如果断言失败，状态将回滚，并消耗所有剩余的 Gas。
// require(bool condition)：用于检查外部输入或调用条件。如果条件不满足，状态回滚，并返还剩余的 Gas。
// revert()：立即终止交易并回滚状态
// revert(string memory reason)：终止交易并回滚状态，同时返回错误信息。

// Gas 消耗：
// assert 失败时会消耗掉所有的剩余 Gas，而 require 则会返还剩余的 Gas 给调用者。
// 适用场景：
// assert：用于检查合约内部逻辑的错误或不应该发生的情况，通常在函数末尾或状态更改之后使用。
// require：用于检查输入参数、外部调用返回值等，通常在函数开头使用。
// 操作符不同：
// assert 失败时执行无效操作（操作码 0xfe），require 失败时则执行回退操作（操作码 0xfd）。

// 异常错误处理
contract ErrorHandler {

    uint public balance;
    function sendHalf(address addr) public payable {
        require(msg.value % 2 == 0, "Even value required."); // 输入检查
        uint balanceBeforeTransfer = address(this).balance;
        addr.transfer(msg.value / 2);
        assert(address(this).balance == balanceBeforeTransfer - msg.value / 2); // 内部错误检查
    }
}

//  assert 与 require 的用法
contract AssertRequireExample {
    address public owner;
    constructor() public {
        owner = msg.sender;
    }
    function transferOwnership(address newOwner) public {
        require(msg.sender == owner, "Only the owner can transfer ownership."); // 检查调用者是否为合约所有者
        owner = newOwner;
    }
    function checkBalance(uint a, uint b) public pure returns (uint) {
        uint result = a + b;
        assert(result >= a); // 检查溢出错误
        return result;
    }
}

// revert revert() 和 **revert(string memory reason)**函数可以用于立即停止执行并回滚状态。这通常用于在遇到某些无法满足的条件时终止函数。
contract RevertExample {
    function checkValue(uint value) public pure {
        if (value > 10) {
            revert("Value cannot exceed 10"); // 返回自定义错误信息
        }
    }
}

//自定义错误机制（custom errors），提供了一种更加 Gas 高效的错误处理方式。
// 自定义错误比 require 或 revert 的字符串消息消耗更少的 Gas，因为自定义错误只传递函数选择器和参数。
contract CustomErrorExample {
    error Unauthorized(address caller);  // 自定义错误
    address public owner;
    constructor() {
        owner = msg.sender;
    }
    function restrictedFunction() public {
        if (msg.sender != owner) {
            revert Unauthorized(msg.sender);  // 使用自定义错误
        }
    }
}

// try catch
// 用于捕获外部合约调用中的异常。此功能允许开发者捕获和处理外部调用中的错误，增强了智能合约编写的灵活性。
// try/catch 的使用场景：
// 捕获外部合约调用失败时的错误，而不让整个交易失败。
// 在同一个交易中可以对失败的调用进行处理或重试。
contract ExternalContract {
    function getValue() public pure returns (uint) {
        return 42;
    }
    function willRevert() public pure {
        revert("This function always fails");
    }
}
contract TryCatchExample {
    ExternalContract externalContract;
    constructor() {
        externalContract = new ExternalContract();
    }
    function tryCatchTest() public returns (uint, string memory) {
        try externalContract.getValue() returns (uint value) {
            return (value, "Success");
        } catch {
            return (0, "Failed");
        }
    }
    function tryCatchWithRevert() public returns (string memory) {
        try externalContract.willRevert() {
            return "This will not execute";
        } catch Error(string memory reason) {
            return reason;  // 捕获错误信息
        } catch {
            return "Unknown error";
        }
    }
}