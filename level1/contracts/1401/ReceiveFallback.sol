pragma solidity 0.8.26;


// fallback 函数是 Solidity 中的一种特殊函数，用于在调用的函数不存在或未定义时充当兜底。顾名思义，
// fallback 在中文中有回退、兜底的意思。类似于没有带现金时可以使用银行卡付款。需要注意的是，
// 这里所说的“匹配不到”、“不存在”、“没有定义”都指的是同一个意思。

// fallback 函数可以在以下两种情况下兜底：

// receive 函数不存在（因为没有定义）
// 普通函数不存在（因为没有定义）
// 简而言之：

// 当需要用到 receive 函数时，如果它没有被定义，就使用 fallback 函数兜底。
// 当调用的函数在合约中不存在或没有被定义时，也使用 fallback 函数兜底。

// receive 函数只能在合约接受纯转账（msg.data 为空）时被触发，例如通过以下方法进行转账：
// send(amount)：Gas 固定为 2300，错误时会 revert。
// transfer(amount)：Gas 固定为 2300，返回布尔值。
// call{value: amount}("")：Gas 可以随意设定，返回布尔值。
// 当使用上述三种方法之一进行转账时，交易的 msg.data 为空。因此，理论上应该触发 receive 函数。如果合约没有定义 receive 函数,
// 那么 fallback 函数将自动作为兜底函数被调用。如果 fallback 函数也没有定义，那么交易将失败并 revert。

contract Callee {

    event FunctionCalled(string);

    function foo() external payable {
        emit FunctionCalled("this is foo");
    }

    // 你可以注释掉 receive 函数来模拟它没有被定义的情况_
    receive() external payable {
        emit FunctionCalled("this is receive");
    }

    // 你可以注释掉 fallback 函数来模拟它没有被定义的情况_
    fallback() external payable {
        emit FunctionCalled("this is fallback");
    }
}

contract Caller {
    address payable callee;

    // 注意： 记得在部署的时候给 Caller 合约转账一些 Wei，比如 100_
    // 因为在调用下面的函数时需要用到一些 Wei_
    constructor() payable{
        callee = payable(address(new Callee()));
    }

    // 触发 receive 函数_
    function transferReceive() external {
        callee.transfer(1);
    }

    // 触发 receive 函数_
    function sendReceive() external {
        bool success = callee.send(1);
        require(success, "Failed to send Ether");
    }

    // 触发 receive 函数_
    function callReceive() external {
        (bool success, bytes memory data) = callee.call{value: 1}("");
        require(success, "Failed to send Ether");
    }

    // 触发 foo 函数_
    function callFoo() external {
        (bool success, bytes memory data) = callee.call{value: 1}(
            abi.encodeWithSignature("foo()")
        );
        require(success, "Failed to send Ether");
    }

    // 触发 fallback 函数，因为 funcNotExist() 在 Callee 没有定义_
    function callFallback() external {
        (bool success, bytes memory data) = callee.call{value: 1}(
            abi.encodeWithSignature("funcNotExist()")
        );
        require(success, "Failed to send Ether");
    }

    //当给返回值赋值后，并且有个return，以最后的return为主
    function test() public pure returns (uint256 mul) {
        uint256 a = 10;
        mul = 100;
        return a;
    }

}