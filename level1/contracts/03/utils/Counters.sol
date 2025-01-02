// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

// 功能解析：
// Counter 结构体

// 包含一个私有变量 _value，用于存储计数值。
// 默认值是 0。
// current 函数

// 返回当前计数器的值。
// 定义为 view，不会改变状态，只能读取。
// increment 函数

// 将计数器的值增加 1。
// 使用 unchecked 块，减少 gas 开销，但不检查溢出（在 Solidity 0.8 版本中默认检查溢出）。
// decrement 函数

// 将计数器的值减少 1。
// 包含溢出检查，确保计数器不会变成负数（Solidity 的 uint256 不能存储负数）。
// reset 函数

// 将计数器的值重置为 0。
library Counters {

    struct Counter {
        uint256 _value; // 默认值为 0
    }

    function current(Counter storage counter) internal view returns (uint256) {
        return counter._value;
    }

    function increment(Counter storage counter) internal {
        unchecked {
            counter._value += 1;
        }
    }

    function decrement(Counter storage counter) internal {
        uint256 value = counter._value;
        require(value > 0, "Counter: decrement overflow");
        unchecked {
            counter._value = value - 1;
        }
    }

    function reset(Counter storage counter) internal {
        counter._value = 0;
    }
}