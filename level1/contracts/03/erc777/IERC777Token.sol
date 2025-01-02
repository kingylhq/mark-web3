// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

// 每个函数、事件的解释查看对应的EIP标准文案，
// 地址：https://learnblockchain.cn/docs/eips/eip-777.html#

// 3.6.2 ERC777 标准
// 本节的主题是 ERC777，因为 ERC777 依赖 ERC1820 来实现转账时对持有者和接受者的通知
// 此处先通过 ERC777 的接口定义来进一步理解 ERC777 标准。
interface ERC777Token { 

    // 返回代币名称
    function name() external view returns (string memory); 

    // 返回代币的代号，如"MYT"
    function symbol() external view returns (string memory); 

    // 返回代币总流通量。
    // 注意: 总供应量必须是所有账号余额（balanceOf）之和。 
    // 注意: 总供应量必须等于所有挖出的币（ Minted 事件定义）减去销毁的币（Burned事件定义）
    function totalSupply() external view returns (uint256); 

    // 返回帐户（通过参数"holder"）的余额，余额 >=0 。
    // 接口ID：70a08231
    // 参数holder： 查询的账号
    // 返回值： 在代币合约里对应账号余额
    function balanceOf(address holder) external view returns (uint256); 

    // 获得代币最小的划分粒度（基于内部单位的个数），最小的挖矿、发送及销毁粒度。
    // granularity 需要满足一下规则：必须在创建时设置, 任何时候不可以更改, 必须大于等于1。
    // 所有的余额必须是granularity的整数倍。
    // 挖矿、发送及销毁数量必须是granularity的整数倍。
    // 非granularity的整数倍的操作都需要 revert 。
    // 注意: 大部分的代币应该是完全可切分的，如果没有特别的理由，这个函数应该返回1。
    function granularity() external view returns (uint256); 

    // 操作员相关的操作（操作员是可以代表持有者发送和销毁代币的账号地址）
    // 获取代币合约默认的操作员列表。
    // 注意: 如果代币合约没有默认操作员, 必须返回空列表。
    function defaultOperators() external view returns (address[]memory); 

    // 是否是某个持有者的操作员。
    // 接口ID: d95b6371
    // 参数：operator: 操作员,holder: 持有者
    // 返回值: 是某个持有者的操作员 返回 true 否则 false。
    // 注意: 要知道持有者有哪些操作员，需要字每个 默认操作员上调用isOperatorFor，
    // 同时解析 AuthorizedOperator 和 RevokedOperator 事件，进行相应的查询。
    function isOperatorFor(address operator, address holder ) external view returns (bool); 

    // 设置一个第三方的 operator 地址作为msg.sender 的操作员，此操作员可以代表 msg.sender 发送和销毁代币。
    // 注意: 持有者 (msg.sender) 总是自身的操作员。 因此，当出现授权自己作为操作员时（operator 等于 msg.sender）函数需要 revert。
    // 接口ID: 959b8c3f
    // 参数：operator: msg.sender 的操作员地址
    function authorizeOperator(address operator) external; 

    // 移除 msg.sender 的 操作员权限。
    // 注意: T持有者 (msg.sender) 总是自身的操作员。因此，当出现移除自己时（即operator 等于 msg.sender）函数需要 revert。
    // 接口ID: fad8b32a
    // 参数：operator: 要取消的msg.sender 的操作员地址
    function revokeOperator(address operator) external; 

    // 发送代币，给地址to发送 amount 数量的代币。
    // 操作员和持有者必须都是msg.sender.
    // 接口ID: 9bd9bbc6
    // 参数： to: 代币接收者，amount: 发送的代币数量，data: 持有者提供的信息
    function send(address to, uint256 amount, bytes calldata data)external; 
    
    // 操作员（msg.sender）代表 from地址 给地址to发送 amount 数量的代币。
    // 记住: 如果操作员没得到 from地址的授权，必须revert
    // 注意: from 和 msg.sender 可以是相同的地址。 例如: 地址可以自己调用 operatorSend，相当于调用send时用了确定的操作员数据（而这不可以通过send实现）
    // 接口ID: 62ad1b83
    // 参数：from: 代币持有者,to: 代币接收者, amount: 发送的代币数量, data: 持有者提供的信息,operatorData: 操作员提供的信息
    function operatorSend( address from, address to, uint256 amount, bytes calldata data, bytes calldata operatorData ) external; 
    
    // 销毁代币 
    function burn(uint256 amount, bytes calldata data) external;
    
    // msg.sender 操作员从 from 账号销毁 amount 数量的代币。
    // 记住: 如果操作员没有授权，需要 revert 。
    // 接口ID: fc673c4f
    // 参数：from: 销毁代币的账号（持有者, amount: 销毁数量, data: 持有者提供的信息, operatorData: 操作员提供的信息
    // 注意: 操作员可以用 operatorData 传递任何信息，信息必须是操作员提供的。
    // 注意: from 和 msg.sender 可以是相同的地址。
    // 例如: 持有者可以自己调用 operatorBurn ，相当于用了额外的操作员及信息operatorData 调用 burn。（而 burn 函数自身无法实现 ）
    function operatorBurn(address from, uint256 amount, bytes calldata data, bytes calldata operatorData) external; 
    
    // 发送代币事件，指示发送代币事件。
    // 注意: 不能在发送函数 send（或 ERC20 transfer 函数 ） 之外触发。
    // 参数：operator: 触发发送的地址,from: 持有者,to: 接收者,amount: 发送的代币数量,data: 持有者提供的信息,operatorData: 操作员提供的信息
    // 下面的 send 和 operatorSend 必须用于实现发送代币，当然合约也可以实现其他的方法来发送。
    event Sent( address indexed operator, address indexed from, address indexed to, uint256 amount, bytes data, bytes operatorData); 
    
    // 铸币事件, 铸币事件不能在铸币过程之外触发
    // 参数：operator: 触发铸币的地址, to: 铸币接收者, amount: 铸币量, data: 提供给接收者的信息, operatorData: 操作员提供的信息
    event Minted( address indexed operator, address indexed to, uint256 amount, bytes data, bytes operatorData); 
    
    // 销毁代币事件, 不能在销毁过程之外触发。
    // 参数： operator: 触发销毁的地址, from: 从哪个账号销毁, amount: 销毁数量, data: 持有者提供的信息, operatorData: 操作员提供的信息
    // 以下描述的函数 burn 和 operatorBurn 必须用来实现代币销毁，当然也可以实现自己的函数。
    event Burned( address indexed operator, address indexed from, uint256 amount, bytes data, bytes operatorData); 
    
    /** 
     *  授权操作员事件, 指示持有者授权一个操作员。不能在授权过程之外触发。
     *  @param operator: 操作员地址
     *  @param holder: 持有者地址
     */
     event AuthorizedOperator( address indexed operator, address indexed holder ); 
    
    // 撤销操作员事件,不能在撤销过程之外触发事件。
    // 参数： operator: 操作员地址 holder: 持有者地址
    event RevokedOperator(address indexed operator, address indexedholder); 

}