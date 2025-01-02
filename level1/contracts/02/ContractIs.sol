// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

// 合约继承
// 第一节：Solidity 中的继承
// 继承的基本概念
// Solidity 支持继承，使用关键字 is 来表示继承关系，类似于 Java 中的 extends。
// 当一个合约继承另一个合约时，子合约可以访问父合约的所有非私有成员。
contract Owned {
    address payable  public owner;
    constructor() public {
        owner = msg.sender;
    }
    function setOwner(address _owner) public virtual {
        owner = payable(_owner);
    }
}
contract Mortal is Owned {
    event SetOwner(address indexed owner);

    function kill() public {
        if (msg.sender == owner) selfdestruct(owner);
    }

    function setOwner(address _owner) public override {
        super.setOwner(_owner); // 调用父合约的 setOwner
        emit SetOwner(_owner);
    }
}
// 继承的特点
// 子合约可以访问父合约中的非私有成员。
// 子合约不能再次声明已经在父合约中存在的状态变量。
// 子合约可以通过重写函数改变父合约的行为。

// 第二节：多重继承
// 多重继承的概念
// Solidity 支持从多个父合约继承。使用 is 关键字后面可以接多个父合约。
contract Named is Mortal {
    // Named 合约继承了 Owned 和 Mortal
}
// 多重继承的顺序
// 如果多个父合约有继承关系，合约的继承顺序需要从父合约到子合约书写。
// 示例代码（编译出错）：
contract X {}
contract A is X {}
// contract C is A, X {}  // 编译出错，X 出现在继承关系中两次
contract C is A {} 


// 第三节：父合约构造函数
// 构造函数的继承
// 子合约继承父合约时，父合约的构造函数会被编译器拷贝到子合约的构造函数中执行。
// 父合约构造函数无参数的情况
// contract A {
//     uint public a;
//     constructor() {
//         a = 1;
//     }
// }
// contract B is A {
//     uint public b;
//     constructor() {
//         b = 2;
//     }
// }

// 父合约构造函数有参数的情况
// 方式1：在继承列表中指定参数
// abstract contract A {
//     uint public a;
//     constructor(uint _a) {
//         a = _a;
//     }
// }
// contract B is A(1) {
//     uint public b;
//     constructor() {
//         b = 2;
//     }
// }

// 方式2：在子合约构造函数中通过修饰符调用父合约
// contract B is A {
//     uint public b;
//     constructor() A(1) {
//         b = 2;
//     }
// }

// 第四节：抽象合约
// 抽象合约的概念
// 如果一个合约中有未实现的函数，该合约必须标记为 abstract，这种合约不能部署。
// 抽象合约通常用作父合约。
// 纯虚函数
// 纯虚函数没有实现，用 virtual 关键字修饰，并且声明以分号 ; 结尾。
// abstract contract A {
//     function get() virtual public;
// }

// 第五节：函数重写（Overriding）
// 函数重写的概念
// 父合约中的虚函数（使用 virtual 关键字修饰）可以在子合约中被重写。重写的函数必须使用 override 关键字。

// contract Base {
//     function foo() virtual public {}
// }
// contract Middle is Base {}
// contract Inherited is Middle {
//     function foo() public override {}
// }

// 多重继承中的重写
// 如果多个父合约有相同的函数定义，子合约重写时必须指定所有的父合约名。
// contract Base1 {
//     function foo() virtual public {}
// }
// contract Base2 {
//     function foo() virtual public {}
// }
// contract Inherited is Base1, Base2 {
//     function foo() public override(Base1, Base2) {}
// }