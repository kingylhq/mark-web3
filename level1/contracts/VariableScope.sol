// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

// 变量范围
contract C {
    // Public（公共）：
    // 公共状态变量可以在合约内部访问，也可以通过消息（如外部调用）访问。定义公共状态变量时，Solidity 
    // 自动为其生成一个 getter 函数。
    // Internal（内部）：
    // 内部状态变量只能在当前合约或其继承的子合约中访问，不能从外部直接访问。
    // Private（私有）：
    // 私有状态变量只能在定义它们的合约内部访问，不能在子合约中访问。
    uint public data = 30;         // 公共状态变量
    uint internal iData = 10;      // 内部状态变量
    function x() public returns (uint) {
        data = 3;                  // 内部访问公共变量
        return data;
    }
}

contract Caller {
    C c = new C();
    function f() public view returns (uint) {
        return c.data();          // 外部访问公共变量
    }
}

contract D is C {

    uint storedData;
    function y() public returns (uint) {
        iData = 3;               // 派生合约内部访问内部变量
        return iData;
    }
    function getResult() public view returns(uint) {
        uint a = 1;               // 局部变量
        uint b = 2;
        uint result = a + b;
        return storedData;        // 访问状态变量
    }
}

// 实践练习：
// 编写合约，测试不同作用域的局部变量和状态变量的访问权限。
// 实现包含多种控制结构的函数，测试if、for、while等语句的使用。
// 编写带有try/catch结构的合约，处理外部合约函数调用中的异常。
contract Homework {
    uint num = 10;
    function test(uint data) public view returns (string memory, uint) {
        uint sum = 0;
        string memory level;
        if (data >= 90) {
            level = unicode"等级为A";
        } else if (data >= 80 && data < 90) {
            level = unicode"等级为B";
        } else if (data >= 70 && data < 80) {
            level = unicode"等级为C";
        } else if (data >= 60 && data < 70) {
            level = unicode"等级为D";
        } else {
            level = unicode"等级为E";
        }
        for (uint i = 0; i <= data; i++ ){
            sum += i;
        }
        while (data > 0) {
            data -= 10;
        }

        return (level, sum);
    }

}

// 测试 try cache异常捕获
contract TargetContract {
    function divide(uint a, uint b) public pure returns (uint) {
        require(b != 0, "Division by zero");
        return a / b;
    }
}

contract TryCatchExample {
    TargetContract public target;

    constructor(address _target) {
        target = TargetContract(_target);
    }

    function safeDivide(uint a, uint b) public view returns (string memory, uint) {
        try target.divide(a, b) returns (uint result) {
            return ("Success", result);
        } catch Error(string memory reason) {
            // 捕获 require 或 revert 的异常
            return ("Error", 0);
        } catch (bytes memory lowLevelData) {
            // 捕获低级异常或 assert 的异常
            return ("Low-level error", 0);
        }
    }
}


