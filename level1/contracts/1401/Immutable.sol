// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Immutable {

    // 在 Solidity 中，immutable 和 constant 关键字都用于定义变量的值只能设置一次，不过 immutable 相比 constant 
    // 提供了更灵活的初始化选项。在前面讨论的“constant”部分我们提到，constant 变量必须在声明时就完成初始化，
    // 并且之后不能再进行修改。而 immutable 变量则提供了更宽松的约束，允许变量在声明时初始化，或者在合约的构造函数中进行初始化。

    // 具体来说，使用 immutable 关键字的变量有以下初始化选项：

    // 在变量声明时进行初始化。
    // 在合约的构造函数中进行初始化。
    // 这意味着，如果你选择在声明时不初始化一个 immutable 变量，你还可以在合约的构造函数中为其赋值一次。这种灵活性使得 immutable 
    // 变量非常适合用于那些值在部署时才能确定，但之后不再改变的场景。

    // 因此，immutable 和 constant 的主要区别在于初始化的时机和灵活性。constant 适用于那些在编写智能合约代码时就已知且永不改变的值，
    // 而 immutable 更适合那些需要在部署合约时根据具体情况确定一次的值。这使得 immutable 在实际应用中提供了更多的便利和效率
    // immutable 变量声明
    // 正如上面所述，我们可以在声明的时候对 immutable 变量初始化，或者在构建函数初始化。

    // 声明时初始化
    uint immutable n = 5;

    // 在构建函数初始化
    uint immutable n1;
    constructor () {
        n1 = 5;
    }

    // 注意不能初始化两次：
    // 不能初始化两次
    // uint immutable n1 = 0;

}