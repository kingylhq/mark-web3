
// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

// 函数选择器
contract  functionSelectorExample {

    // 计算平方
    function square(uint x) public pure returns (uint) {
        return x * x;
    }

    // 计算一个数的2倍
    function double(uint x) public pure returns (uint) {
        return x * 2;
    }

    // 返回平方的函数选择器
    function getSelectorSquare(uint x) external pure returns (bytes4) {
        return this.square.selector;
    }

    // 返回倍数函数选择器
    function getSelectorDouble(uint x) external pure returns (bytes4) {
        return this.double.selector;
    }

    // 返回倍数函数选择器，方式二
    function getSelectorDouble2(uint x) external pure returns (bytes4) {
        return bytes4(keccak256("double(uint256)"));
    }
    
    // 根据传入的选择器动态调用函数 square、double
    function excute(bytes4 selector, uint x) external returns (uint z) {
        (bool success, bytes memory data) = address(this).call(abi.encodeWithSelector(selector, x));
        require(success, "Function call failed");
        return abi.decode(data, (uint));
    }

    // 作业
    bytes4 public storedSelector ;

    // 存储选择器
    function storeSelector(bytes4 selector) public {
        storedSelector = selector;
    }

    // 函数：调用存储在 storedSelector 中的函数，并返回结果
    function executeStoredFunction(uint x) public returns (uint) {
        require(storedSelector != bytes4(0), "Selector not set"); // 检查状态变量是否已经设置值，未设置报错
        (bool success, bytes memory data) = address(this).call(abi.encodeWithSelector(storedSelector, x));
        require(success, "Function call failed");
        return abi.decode(data, (uint));
    }

    
}

