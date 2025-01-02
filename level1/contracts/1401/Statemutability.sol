pragma solidity 0.8.26;

contract StateMutability {

    // 怎样才算修改合约状态
    // Solidity 有 8 种行为被认为是修改了合约状态：

    // 修改状态变量：直接改变合约中的状态变量。
    // 触发事件：发出事件来记录合约中的活动。
    // 创建其他合约：通过合约代码生成新的合约实例。
    // 使用 selfdestruct：销毁当前合约并将其余额发送到指定地址。
    // 通过函数调用发送以太币：例如使用 transfer 或 send 方法进行以太币转账。
    // 调用未标记为 view 或 pure 的任何函数：调用可能改变状态的函数。
    // 使用低级调用：如 transfer、send、call、delegatecall 等。
    // 使用包含某些操作码的内联汇编：使用可能直接影响状态的汇编代码。

    

    // 怎样才算查询合约状态
    // Solidity 有 5 种行为被认为是查询了合约状态：

    // 读取状态变量：访问和读取合约中的状态变量。
    // 访问 address(this).balance 或 <address>.balance：获取当前合约或指定地址的余额。
    // 访问 block、tx、msg 的成员：读取区块链相关信息，如 block.timestamp、tx.gasprice、msg.sender 等。
    // 调用未标记为 pure 的任何函数：调用任何未被标记为 pure 的函数，即使这些函数本身也只是读取状态。
    // 使用包含某些操作码的内联汇编：使用可能会读取状态的特定汇编代码。
}