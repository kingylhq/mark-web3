// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

// 第一节：接口的概念与规则
// 接口的基本概念
// 接口（Interface）与抽象合约相似，但接口不实现任何函数。
// 接口主要用于标准化不同合约之间的交互，它定义了合约之间的行为协议。
// 接口的限制
// Solidity 中的接口具有以下限制：

// 无法继承其他合约或接口：接口不能扩展其他合约或接口。
// 无法定义构造函数：接口不允许定义任何构造函数，因为它不能有内部状态。
// 无法定义状态变量：接口不能有状态变量，因为它不存储数据。
// 无法定义结构体或枚举：接口不能包含结构体或枚举。
// 接口的语法
// 接口通过 interface 关键字定义，接口中的所有函数默认为 external，且不带实现。
interface IToken {
    function transfer(address recipient, uint amount) external;
}

// 第二节：接口与抽象合约的区别
// 抽象合约可以包含部分已实现的函数，但接口不实现任何函数。
// 抽象合约可以定义构造函数、状态变量、结构体和枚举，而接口不可以。
// 接口中的所有函数都隐式地标记为 virtual，这意味着它们需要在实现合约中被重写。
contract SimpleToken is IToken {

    mapping (address => uint256) public balances;
    constructor() {
        balances[msg.sender] = 10000;
    }
    function transfer(address recipient, uint amount) external override {
        require(balances[msg.sender] >= amount, "Insufficient balances");
        balances[msg.sender] -= amount;
        balances[recipient] += amount;
    }
}

// 合约之间通过接口进行通信
// 接口的一个重要用途是实现合约间的通信。一个合约可以通过接口与另一个合约交互，而无需知道具体的实现细节。
contract Award {

    IToken immutable token;

    // 构造函数中传入 SimpleToken的地址
    constructor(IToken _token) {
        token = _token;
    }

    function sendBouds(address add) public  {
        // 调用 SimpleToken 合约的 transfer 函数来发送奖励
        token.transfer(add, 100); // 发送100的代币作为奖励
    }

    // Award 合约不需要知道 SimpleToken 的具体实现，它只需通过 IToken 接口调用 transfer 函数。

}

// 第四节：接口的实际应用
// ERC20 标准的实现
// 接口在标准化代币合约（如 ERC20 代币）中起着重要作用。ERC20 标准定义了一套接口，所有符合 ERC20 标准的代币都必须实现这些接口函数。

// ERC20 接口的示例代码：
interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}
// 任何 ERC20 代币合约都必须实现上述接口，以确保与其他合约兼容。 使用接口与外部合约交互
// 通过接口，合约可以与外部的其他合约进行交互，这在构建复杂的去中心化应用程序（dApps）时非常有用。例如，钱包可以通过 ERC20 接口与任何符合 ERC20 标准的代币合约进行交互。

// 第五节：实践练习
// 接口的基本实现：
// 编写一个接口 IVault，定义存款和取款的函数，然后编写一个合约 Bank 实现该接口，管理用户的存款和取款。
// 合约间通信：

// 编写一个代币合约 MyToken，然后编写一个奖励合约 Reward，通过 MyToken 合约给用户发放代币奖励。

// 使用标准接口：
// 实现一个符合 ERC20 标准的代币合约，并通过 ERC20 接口与钱包合约进行交互。

interface  IValut {
    // 存款
    function Deposit(address add, uint amount) external returns (uint256);
    // 取款
    function withdrawal(address add, uint amount) external ;
}

contract Bank is IValut {
    // 存款
    mapping(address => uint) bankBalances;
    constructor() {

    }
    function Deposit (address add ,uint amount ) public override returns(uint){
        require(amount > 0, "amount gt zero"); 
        bankBalances[add] += amount; //存款
        return bankBalances[add];//返回账户余额
    }

    function withdrawal (address add ,uint amount ) public override {
        require(bankBalances[add] >= amount, "Insufficient balances"); //余额大于取款金额
        bankBalances[add] -= amount;//余额减去
    }
}

contract MyToken {
    IValut immutable value;
    constructor(IValut _value) {
        value = _value;
    }
    function reward(address add) public {
        value.Deposit(add, 10);
    }
}