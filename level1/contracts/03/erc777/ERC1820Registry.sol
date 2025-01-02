// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;
import "./IERC1820ImplementerInterface.sol";

// ERC777 功能型代币
// ERC20 代币简洁使用，非常合适用它来代表某种权益，不过有时想要在 ERC20 添加一些功能，就会显得有些力不从心，举两个典型的场景：
// 使用 ERC20 代币购买商品时，ERC20 合约上无法记录购买具体商品的信息，那就需要额外用其他的方式记录，势必增加整个过程的成本。
// 在经典的存币生息 Defi 应用中，理想的情况是代币在转入存币生息合约之后，后者就开始计息，然而由于 ERC20 代币的缺陷，存币生息合约实际上无法知道有人向它转账，因此也无法开始计息。
// 如果要解决场景（2）的问题，在 ERC20 标准中必须把存币生息分解为两步，第一步：让用户用 approve()函数授权存币生息合约可以转移用户的币；第二步：再次让用户调用存币生息合约的计息函数，计息函数中通过 transferFrom 把代币转移到自身合约内，开始计息。
// 除此之外，ERC20 还有一个缺陷：ERC20 误转入一个合约后，如果目标合约没有对代币作相应的处理，则代币将永远锁死在合约里，没有办法把代币从合约里取出来。
// ERC777 很好地解决了这些问题，同时 ERC777 也兼容 ERC20 标准。建议大家在开发新的代币时使用 ERC777 标准。
// ERC777 定义了 send(dest, value, data)函数来进行代币的转账。 ERC777 标准特意避开和 ERC20 标准使用同样的 transfer()函数，这样就能让用户同时实现两个函数以兼容两个标准。
// send()函数有一个额外的参数 data 用来携带转账的附加信息，同时 send 函数在转账时还会对代币的持有者和接收者发送通知，以方便在转账发生时，持有者和接收者可以进行额外的处理。
// 代币的持有者和接收者需要实现额外的函数才能收到转账通知。
// send 函数的通知是通过 ERC1820 接口注册表合约来实现的，所以这里先介绍 ERC1820。

// 3.6.1 ERC1820 接口注册表
// 前文介绍的 ERC165 标准可以声明合约实现了那些接口，却没法为普通账户地址声明实现了哪些接口。ERC1820 标准通过一个全局的注册表合约来记录任何地址声明的接口，其实现 机制类似于 Windows 的系统注册表，注册表记录的内容包含地址（声明实现接口的地址）、注册的接口、接口实现在哪个合约地址（可以和第一个地址一样）。
// ERC1820 是一个全局的合约，它在链上有一个固定的合约地址，并且在所有的以太坊网络（包含测试、以太坊经典等）上都具有相同合约地址，这个地址总是：0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24，因此总是可以在这个合约上查询地址实现了哪些接口。
// ERC1820 是通过非常巧妙的方式（被称为无密钥部署方法）部署的。有兴趣可以阅读 ERC1820 标准-部署方法部分，链接：https://learnblockchain.cn/docs/eips/eip-1820.html。
// 需要注意的是，ERC1820 标准是一个实现了的合约，前面讲到的如 ERC20 标准定义的是接口，需要用户来实现部署（例如参考 OpenZeppelin 提供的模板实现）。
// 对于 ERC1820 合约，除了地址、接口、合约三个部分，还需要了解几个要点。①ERC1820 引入了管理员角色，由管理员来设置哪个合约在哪个地址实现了哪一个接口。②ERC1820 要求实现接口的合约，必须实现 canImplementInterfaceForAddress 函数，来声明其实现的接口，并且当用户查询其实现的接口时，必须返回常量 ERC1820_ACCEPT_MAGIC。
// ③ERC1820 也兼容 ERC165，即也可以在 ERC1820 合约上查询 ERC165 接口，为此 ERC1820 使用了函数签名的完整 Keccak256 哈希来表示接口（下方代码的 interfaceHash），而不是 ERC165 接口定义的前 4 个字节的函数选择器。
// 在了解上面的要点后，理解下方 ERC1820 合约的官方实现代码就比较容易了，看看它是如何实现接口注册的。为了方便理解，代码中已经加入注释。


/// @title ERC1820 伪自省注册表合约
/// @notice 该合约是ERC1820注册表的官方实现。
contract ERC1820Registry { 

    /// @notice ERC165 无效 ID.
    bytes4 constant internal INVALID_ID = 0xffffffff;
    /// @notice ERC165 的 supportsInterface 接口ID (= `bytes4(keccak256('supportsInterface(bytes4)'))`).
    bytes4 constant internal ERC165ID = 0x01ffc9a7;
    /// @notice 如果合约代表某个其他地址实现接口，则返回Magic值。
    bytes32 constant internal ERC1820_ACCEPT_MAGIC = keccak256(abi.encodePacked("ERC1820_ACCEPT_MAGIC"));

    /// @notice 映射地址及接口到对应的实现合约地址
    mapping(address => mapping(bytes32 => address)) internal interfaces;
    /// @notice 映射地址到管理者
    mapping(address => address) internal managers;
    /// @notice 每个地址和erc165接口的flag，指示是否被缓存。
    mapping(address => mapping(bytes4 => bool)) internal erc165Cached;

    /// @notice 表示合约是'addr'的'interfaceHash'的'实现者'。
    event InterfaceImplementerSet(address indexed addr, bytes32 indexed interfaceHash, address indexed implementer);
    /// @notice 表示'newManager'是'addr'的新管理者的地址。
    event ManagerChanged(address indexed addr, address indexed newManager);

    /// @notice 查询地址是否实现了接口以及通过哪个合约实现的。
    /// @param _addr 查询地址（如果'_addr'是零地址，则假定为'msg.sender'）。
    /// @param _interfaceHash 查询接口，它是接口名称字符串的 keccak256 哈希值
    /// 例如: 'web3.utils.keccak256("ERC777TokensRecipient")' 表示 'ERC777TokensRecipient' 接口.
    /// @return 返回实现者的地址，没有实现返回 ‘0’
    function getInterfaceImplementer(address _addr, bytes32 _interfaceHash) external view returns (address) {
        address addr = _addr == address(0) ? msg.sender : _addr;
        if (isERC165Interface(_interfaceHash)) {
            bytes4 erc165InterfaceHash = bytes4(_interfaceHash);
            return implementsERC165Interface(addr, erc165InterfaceHash) ? addr : address(0);
        }
        return interfaces[addr][_interfaceHash];
    }

    /// @notice 设置某个地址的接口由哪个合约实现，需要由管理员来设置。（每个地址是他自己的管理员，直到设置了一个新的地址）。
    /// @param _addr 待设置的关联接口的地址（如果'_addr'是零地址，则假定为'msg.sender'）
    /// @param _interfaceHash 接口，它是接口名称字符串的 keccak256 哈希值
    /// 例如: 'web3.utils.keccak256("ERC777TokensRecipient")' 表示 'ERC777TokensRecipient' 接口。
    /// @param _implementer 为地址'_addr'实现了 '_interfaceHash'接口的合约地址
    function setInterfaceImplementer(address _addr, bytes32 _interfaceHash, address _implementer) external {
        address addr = _addr == address(0) ? msg.sender : _addr;
        require(getManager(addr) == msg.sender, "Not the manager");

        require(!isERC165Interface(_interfaceHash), "Must not be an ERC165 hash");
        if (_implementer != address(0) && _implementer != msg.sender) {
            require(
                IERC1820ImplementerInterface(_implementer)
                    .canImplementInterfaceForAddress(_interfaceHash, addr) == ERC1820_ACCEPT_MAGIC,
                "Does not implement the interface"
            );
        }
        interfaces[addr][_interfaceHash] = _implementer;
        emit InterfaceImplementerSet(addr, _interfaceHash, _implementer);
    }

    /// @notice 为地址_addr 设置新的管理员地址_newManager， 新的管理员能给'_addr' 调用 'setInterfaceImplementer' 
    // 设置是实现者。
    ///  (传 '0x0' 为地址_addr 重置管理员)
    function setManager(address _addr, address _newManager) external {
        require(getManager(_addr) == msg.sender, "Not the manager");
        managers[_addr] = _newManager == _addr ? address(0) : _newManager;
        emit ManagerChanged(_addr, _newManager);
    }

    /// @notice 获取地址 _addr的管理员
    function getManager(address _addr) public view returns(address) {
        // By default the manager of an address is the same address
        if (managers[_addr] == address(0)) {
            return _addr;
        } else {
            return managers[_addr];
        }
    }

    /// @notice 计算给定名称的接口的keccak256哈希值。
    function interfaceHash(string calldata _interfaceName) external pure returns(bytes32) {
        return keccak256(abi.encodePacked(_interfaceName));
    }

    /* --- ERC165 相关方法 --- */
    /// @notice 更新合约是否实现了ERC165接口的缓存。
    function updateERC165Cache(address _contract, bytes4 _interfaceId) external {
        interfaces[_contract][_interfaceId] = implementsERC165InterfaceNoCache(
            _contract, _interfaceId) ? _contract : address(0);
        erc165Cached[_contract][_interfaceId] = true;
    }

    /// @notice 检查合约是否实现ERC165接口。
    //  如果未缓存结果，则对合约地址进行查找。 如果结果未缓存或缓存已过期，则必须通过使用合约地址调用“updateERC165Cache”手动更新缓存。
    /// @param _contract 要检查的合约地址。
    /// @param _interfaceId 要检查ERC165接口。
    /// @return True 如果合约实现了接口返回 true, 否则false.
    function implementsERC165Interface(address _contract, bytes4 _interfaceId) public view returns (bool) {
        if (!erc165Cached[_contract][_interfaceId]) {
            return implementsERC165InterfaceNoCache(_contract, _interfaceId);
        }
        return interfaces[_contract][_interfaceId] == _contract;
    }

    /// @notice 在不使用或更新缓存的情况下检查合约是否实现ERC165接口。
    /// @param _contract 要检查的合约地址。
    /// @param _interfaceId 要检查ERC165接口。
    /// @return True 如果合约实现了接口返回 true, 否则false.
    function implementsERC165InterfaceNoCache(address _contract, bytes4 _interfaceId) public view returns (bool) {
        uint256 success;
        uint256 result;

        (success, result) = noThrowCall(_contract, ERC165ID);
        if (success == 0 || result == 0) {
            return false;
        }

        (success, result) = noThrowCall(_contract, INVALID_ID);
        if (success == 0 || result != 0) {
            return false;
        }

        (success, result) = noThrowCall(_contract, _interfaceId);
        if (success == 1 && result == 1) {
            return true;
        }
        return false;
    }

    // @notice 检查 `_interfaceHash` 是否是 ERC165 接口标识符（4 字节）。
    // @param _interfaceHash 要检查的接口标识符（hash）。
    // @return 如果 '_interfaceHash' 是 ERC165 接口返回 True, 否则返回 False。
    // 解释：
    // _interfaceHash >> 32 == 0:
    // _interfaceHash >> 32 将 bytes32 类型的值右移 32 位。
    // 如果 _interfaceHash 的前 28 个字节全为零，那么移位后会变成 0。
    // 这符合 ERC165 接口标识符的特性，验证了它是有效的 4 字节接口 ID。
    // 与其通过位掩码和按位与操作，不如直接右移 32 位后判断是否为零，更直观且更易读。
    function isERC165Interface(bytes32 _interfaceHash) internal pure returns (bool) {
        // 检查是否只有前 28 个字节为零，即接口标识符只占用最后 4 个字节。
        return (_interfaceHash >> 32) == 0;
    }

    /// @dev 调用合约接口，如果函数不存在也不抛出异常。
    function noThrowCall(address _contract, bytes4 _interfaceId)
        internal view returns (uint256 success, uint256 result)
    {
        bytes4 erc165ID = ERC165ID;

        assembly {
            let x := mload(0x40)               // Find empty storage location using "free memory pointer"
            mstore(x, erc165ID)                // Place signature at beginning of empty storage
            mstore(add(x, 0x04), _interfaceId) // Place first argument directly next to signature

            success := staticcall(
                30000,                         // 30k gas
                _contract,                     // To addr
                x,                             // Inputs are stored at location x
                0x24,                          // Inputs are 36 (4 + 32) bytes long
                x,                             // Store output over input (saves space)
                0x20                           // Outputs are 32 bytes long
            )

            result := mload(x)                 // Load the result
        }
    }
 }
