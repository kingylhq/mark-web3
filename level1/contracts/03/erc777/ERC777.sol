// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "./IERC777.sol"; 
import "./IERC777Token.sol"; 
import "./IERC777TokensRecipient.sol"; 
import "./IERC777TokensSender.sol"; 
import "../erc20/IERC20.sol"; 
import "./ERC1820Registry.sol"; 
import "../SafeMath.sol"; 
import "../utils/Address.sol"; 
// import "./IERC1820Registry.sol"; 
// 合约实现兼容了 
contract ERC777 is IERC777, ERC777Token, IERC20 { 

    using SafeMath for uint256; 

    using Address for address; // ERC1820 注册表合约地址 

    // 注册表合约地址 0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24，注册表合约地址在每个链的地址都一样，都是它。
    ERC1820Registry private _erc1820 = ERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24); 

    mapping(address => uint256) private _balances; 

    uint256 private _totalSupply; 

    string private _name; 

    string private _symbol; 

    // 硬编码 keccak256(abi.encodePacked("ERC777TokensSender"))为了减少gas
    bytes32 constant private TOKENS_SENDER_INTERFACE_HASH = 0x29ddb589b1fb5fc7cf394961c1adf5f8c6454761adf795e67fe149f658abe895; 
    // 硬编码 keccak256(abi.encodePacked("ERC777TokensRecipient") 
    bytes32 constant private TOKENS_RECIPIENT_INTERFACE_HASH =0xb281fc8c12954d22544db45de3159a39272895b169a852b314f9cc762e44c53b; 
    // 保存默认操作者列表 
    address[] private _defaultOperatorsArray; 
    // 为了索引默认操作者状态使用的 mapping 
    mapping(address => bool) private _defaultOperators; 
    // 保存授权的操作者 
    mapping(address => mapping(address => bool)) private _operators;
    // 保存取消授权的默认操作者 
    mapping(address => mapping(address => bool)) private _revokedDefaultOperators; 
    // 为了兼容 ERC20（保存授权信息） 
    mapping (address => mapping (address => uint256)) private _allowances; 
    /** * defaultOperators 是默认操作员，可以为空 */ 

    constructor(string memory name, string memory symbol, address[] memory defaultOperators) public { 
        _name = name; 
        _symbol = symbol; 
        _defaultOperatorsArray = defaultOperators; 
        for (uint256 i = 0; i < _defaultOperatorsArray.length; i++) {
            _defaultOperators[_defaultOperatorsArray[i]] = true;
         } 
        // 注册接口 
        _erc1820.setInterfaceImplementer(address(this), keccak256("ERC777Token"), address(this)); 
        _erc1820.setInterfaceImplementer(address(this), keccak256("ERC20Token"), address(this)); 
    } 

    function name() public view override returns (string memory) { 
        return _name; 
    } 

    function symbol() public view override returns (string memory) { 
        return _symbol; 
    } 

    // 为了兼容 ERC20 
    function decimals() public pure override returns (uint8) { 
        return 18; 
    } 
    
    // 默认粒度为 1 
    function granularity() public view returns (uint256) { 
        return 1; 
    } 

    function totalSupply() public view returns (uint256) { 
        return _totalSupply; 
    } 

    function balanceOf(address tokenHolder) public view returns(uint256) { 
        return _balances[tokenHolder]; 
    } 

    // 同时触发 ERC20 的 Transfer 事件 
    function send(address recipient, uint256 amount, bytes calldata data) external { 
        _send(msg.sender, msg.sender, recipient, amount, data, "",true); 
    } 

    // 为兼容 ERC20 的转账，同时触发 Sent 事件 
    function transfer(address recipient, uint256 amount) external returns (bool) { 
        require(recipient != address(0), "ERC777: transfer to thezeroaddress"); 
        address from = msg.sender; 
        _callTokensToSend(from, from, recipient, amount, "", "");
        _move(from, from, recipient, amount, "", ""); 
        //最后一个参数表示不要求接收者实现钩子函数 tokensReceived
        _callTokensReceived(from, from, recipient, amount, "", "",false); 
        return true; 
    } 

    // 为了兼容 ERC20， 触发 Transfer 事件 
    function burn(uint256 amount, bytes calldata data) external{
        _burn(msg.sender, msg.sender, amount, data, ""); 
    } 
    
    // 判断是否为操作员 
    function isOperatorFor(address operator, address tokenHolder) public view returns (bool) { 
        return operator == tokenHolder 
        || (_defaultOperators[operator] && !_revokedDefaultOperators[tokenHolder][operator]) 
        || _operators[tokenHolder][operator]; 
    } 

    // 授权操作员 
    function authorizeOperator(address operator) external { 
        require(msg.sender != operator, "ERC777: authorizing selfasoperator"); 
        if (_defaultOperators[operator]) { 
            delete _revokedDefaultOperators[msg.sender][operator];
        } else {
            _operators[msg.sender][operator] = true; 
        } 
        emit AuthorizedOperator(operator, msg.sender); 
    } 

    // 撤销操作员 
    function revokeOperator(address operator) external { 
        require(operator != msg.sender, "ERC777: revoking self asoperator"); 
        if (_defaultOperators[operator]) { 
            _revokedDefaultOperators[msg.sender][operator] = true;
        } 
        else { 
            delete _operators[msg.sender][operator];
        } 
        // 撤销操作员事件 ERC777Token.sol文件里
        emit RevokedOperator(operator, msg.sender); 
    } 

    // 默认操作者 
    function defaultOperators() public view returns (address[] memory){ 
        return _defaultOperatorsArray; 
    } 

    // 转移代币，需要有操作者权限，触发 Sent 和 Transfer 事件
    function operatorSend(address sender, address recipient, uint256 amount, bytes calldata data, bytes calldata operatorData ) external { 
        require(isOperatorFor(msg.sender, sender), "ERC777: callerisnot an operator for holder"); 
        _send(msg.sender, sender, recipient, amount, data, operatorData, true); 
    } 

    // 销毁代币 
    function operatorBurn(address account, uint256 amount, bytes calldata data, bytes calldata operatorData) external { 
        require(isOperatorFor(msg.sender, account), "ERC777: calleris not an operator for holder"); 
        _burn(msg.sender, account, amount, data, operatorData);
    } 

    // 为了兼容 ERC20，获取授权 
    function allowance(address holder, address spender) public view returns (uint256) { 
        return _allowances[holder][spender]; 
    }
    // 为了兼容 ERC20，进行授权 
    function approve(address spender, uint256 value) external returns(bool) { 
        address holder = msg.sender; 
        _approve(holder, spender, value); 
        return true; 
    } 

    // 注意，操作员没有权限调用（除非经过 approve） 
    // 触发 Sent 和 Transfer 事件 
    function transferFrom(address holder, address recipient, uint256 amount) external returns (bool) { 
        require(recipient != address(0), "ERC777: transfer to thezeroaddress"); 
        require(holder != address(0), "ERC777: transfer from the zeroaddress"); 
        address spender = msg.sender; 
        _callTokensToSend(spender, holder, recipient, amount, "","");
        _move(spender, holder, recipient, amount, "", ""); 
        _approve(holder, spender, _allowances[holder][spender].sub(amount)); 
        _callTokensReceived(spender, holder, recipient, amount, "","",false); 
        return true; 
    } 

    // 铸币函数（即常说的“挖矿”） 
    function _mint(address operator, address account, uint256 amount, bytes memory userData, bytes memory operatorData ) internal { 
        require(account != address(0), "ERC777: mint to the zeroaddress"); 
        // Update state variables 
        _totalSupply = _totalSupply.add(amount); 
        _balances[account] = _balances[account].add(amount); 
        _callTokensReceived(operator, address(0), account, amount,userData, operatorData, true); 
        emit Minted(operator, account, amount, userData, operatorData); 
        emit Transfer(address(0), account, amount); 
    } 

    // 转移 token 
    // 最后一个参数 requireReceptionAck 表示是否必须实现 ERC777TokensRecipient 
    function _send( address operator, address from, address to, uint256 amount, bytes memory userData, bytes memory operatorData, 
        bool requireReceptionAck) private { 
        require(from != address(0), "ERC777: send from the zeroaddress"); 
        require(to != address(0), "ERC777: send to the zero address");
        _callTokensToSend(operator, from, to, amount, userData,operatorData); 
        _move(operator, from, to, amount, userData, operatorData);
        _callTokensReceived(operator, from, to, amount, userData,operatorData, requireReceptionAck); 
    } 

    // 销毁代币实现 
    function _burn( address operator, address from, uint256 amount, bytes memory data, bytes memory operatorData ) private { 
        require(from != address(0), "ERC777: burn from the zeroaddress"); 
        _callTokensToSend(operator, from, address(0), amount, data,operatorData); 
        // Update state variables 
        _totalSupply = _totalSupply.sub(amount); 
        _balances[from] = _balances[from].sub(amount); 
        emit Burned(operator, from, amount, data, operatorData);
        emit Transfer(from, address(0), amount); 
    } 

    // 转移所有权 
    function _move( address operator, address from, address to, uint256 amount, bytes memory userData, bytes memory operatorData ) 
    private { 
        _balances[from] = _balances[from].sub(amount); 
        _balances[to] = _balances[to].add(amount); 
        emit Sent(operator, from, to, amount, userData, operatorData);
        emit Transfer(from, to, amount); 
    } 

    function _approve(address holder, address spender, uint256 value) private { 
        // TODO: restore this require statement if this function becomesinternal, or is called at a new callsite. It is 
        // currently unnecessary. 
        //require(holder != address(0), "ERC777: approve from thezeroaddress"); 
        require(spender != address(0), "ERC777: approve to the zeroaddress"); _allowances[holder][spender] = value; 
        emit Approval(holder, spender, value); 
    } 

    // 尝试调用持有者的 tokensToSend()函数 
    function _callTokensToSend(address operator, address from, address to, uint256 amount, bytes memory userData, 
    bytes memory operatorData ) private { 
        address implementer = _erc1820.getInterfaceImplementer(from,TOKENS_SENDER_INTERFACE_HASH); 
        if (implementer != address(0)) { 
            ERC777TokensSender(implementer).tokensToSend(operator, from,to, amount, userData, operatorData); 
        } 
    } 

    // 尝试调用接收者的 tokensReceived() 
    function _callTokensReceived( address operator, address from, address to, uint256 amount, bytes memory userData, 
    bytes memory operatorData, bool requireReceptionAck) private { 
        address implementer = _erc1820.getInterfaceImplementer(to,TOKENS_RECIPIENT_INTERFACE_HASH); 
        if (implementer != address(0)) {
            ERC777TokensRecipient(implementer).tokensReceived(operator,from, to, amount, userData, operatorData); 
        } else if (requireReceptionAck) {
            require(!to.isContract(), "ERC777: token recipient contract has no implementer for ERC777TokensRecipient"); 
        } 
    } 
}