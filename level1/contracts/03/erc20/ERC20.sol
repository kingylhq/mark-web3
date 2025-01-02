// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;
import "../SafeMath.sol";
import "./IERC20.sol";


abstract contract ERC20 is IERC20 {

    using SafeMath for uint256; 
    mapping (address => uint256) private _balances; 
    mapping (address => mapping (address => uint256)) private _allowances; 
    uint256 private _totalSupply; 

    function totalSupply() public view virtual returns (uint256) { 
        return _totalSupply; 
    }    
    function balanceOf(address account) public view returns (uint256){ 
        return _balances[account]; 
    } 
    function transfer(address recipient, uint256 amount) public returns (bool) { 
        _transfer(msg.sender, recipient, amount); 
        return true; 
    } 
    function allowance(address owner, address spender) public view returns (uint256) { 
        return _allowances[owner][spender]; 
    } 
    function approve(address spender, uint256 value) public returns(bool) { 
        _approve(msg.sender, spender, value); 
        return true; 
    } 
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) { 
        _transfer(sender, recipient, amount); 
        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub2(amount)); 
        return true; 
    } 
    function _transfer(address sender, address recipient, uint256 amount) internal { 
        require(sender != address(0), "ERC20: transfer from the zeroaddress"); 
        require(recipient != address(0), "ERC20: transfer to the zeroaddress"); 
        _balances[sender] = _balances[sender].sub2(amount); 
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount); 
    } 
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zeroaddress"); 
        _totalSupply = _totalSupply.add(amount); 
        _balances[account] = _balances[account].add(amount); 
        emit Transfer(address(0), account, amount); 
    } 
    function _burn(address account, uint256 value) internal { 
        require(account != address(0), "ERC20: burn from the zeroaddress"); 
        _balances[account] = _balances[account].sub2(value); 
        _totalSupply = _totalSupply.sub2(value); 
        emit Transfer(account, address(0), value); 
    } 
    function _approve(address owner, address spender, uint256 value)internal { 
        require(owner != address(0), "ERC20: approve from the zeroaddress"); 
        require(spender != address(0), "ERC20: approve to the zeroaddress");
        _allowances[owner][spender] = value; 
        emit Approval(owner, spender, value); 
    } 
    
}

// ERC20 实现的关键是使用了两个 mapping:_balances 和_allowances，_balances 用来保存某个地址的余额，_allowances 
// 用来保存某个地址授权给另一个地址可使用的余额。

// transfer()用来实现代币转账的转账，有两个参数：转账的目标（接收者）及数量。在执行 transfer()的时候（对照_transfer()的实现），
// 主要是修改控制账号余额的_balances 变量，修改方法为：发送方账号（即交易的发起人）的余额减去相应的金额，同时目标账号的余额加上相应的金额，
// 加减法使用了 safemath 来防止溢出，transfer()的实现需要触发 Transfer 事件。approve()函数和 transferFrom()函数需要配合使用，
// 使用场景是这样的：操作者先通过 approve() 授权第三方可以转移操作者的币，然后第三方通过 transferFrom()去转移币。
// 举一个通俗的例子：假如使用代币来发送工资，总经理就可以授权财务使用部分代币（使用 approve()函数），财务把代币发放给员工（使用 transferFrom()函数）。

// 目前最常用的一个场景是去中心化交易（以下简称 DEX，它使用智能合约来处理代币之间的兑换）。假如 Bob 要使用 DEX 智能合约用 100 个代币 A 购买 150 个代币 B，
// 那么通常操作步骤是：Bob 先把 100 个 A 授权给 DEX，然后调用 DEX 的兑换函数，在兑换函数里使用 transferFrom()函数把 Bob 的 100 个 A 转走，
// 之后再转给 Bob150 个 B。

// approve()函数通过修改_allowances 变量来控制被授权人及授权代币数量（请对照上面代码的_approve()函数），_allowances[owner][spender]=value;
// 的意思是：owner 账号授权 spender 账号可消费数量为 value 的代币。 transferFrom()是由被授权人发起调用，transferFrom()的第一个参数 sender 
// 是真正扣除代币的账号（也就是_allowances 中的 owner）。