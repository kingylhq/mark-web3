// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;
import "./IERC165.sol";

// 实现ERC165标准接口
contract ERC165Registry is IERC165 {

    // bytes4(keccak256('supportsInterface(bytes4)'))
    bytes4 constant private INTERFACE_ERC165_ID = 0x01ffc9a7;

    mapping (bytes4 => bool) internal  _supportedInterfacesId;

    constructor() {
       register(INTERFACE_ERC165_ID);
    }

    // 判断合约是否实现了某个接口
    // @notice 查询一个合约时候实现了一个接口
    // @param interfaceID  参数：接口ID, 参考上面的定义
    // @return true 如果函数实现了 interfaceID (interfaceID 不为 0xffffffff )返回true, 否则为 false
    // 这个接口的接口ID 为 0x01ffc9a7， 可以使用 bytes4(keccak256('supportsInterface(bytes4)')); 
    // 计算得到，或者使用合约函数的selector方法（如上面Selector）。
    function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
        if (interfaceId == 0x01ffc9a7 || interfaceId == 0x12345678) {
            return true;
        } else {
            bool support = _supportedInterfacesId[interfaceId]; // 查询是否支持 IERC165接口
            return support;
        }
    }

    function register(bytes4 interfaceId) public {
        require(!supportsInterface(interfaceId), "Registering already registered interface id");
        _supportedInterfacesId[interfaceId] = true;
    }

    function remove(bytes4 interfaceId) public {
        require(_supportedInterfacesId[interfaceId], "Unregistering not-registered interface id");
        delete _supportedInterfacesId[interfaceId]; // 取消注册
    } 

    // 计算给定名称的接口的keccak256哈希值。接口名称可以带上参数, 如: supportsInterface(bytes4)
    function interfaceHash(string calldata _interfaceName) external pure returns(bytes4) {
        return bytes4(keccak256(abi.encodePacked(_interfaceName)));
    }
}

    // ERC-165 的实现检测逻辑
    // ERC-165 是一个标准，用于检测合约是否支持某个接口。它的核心函数是：

    // function supportsInterface(bytes4 interfaceID) external view returns (bool);
    // 检测步骤解析
    // 第一次调用：
    // 使用 supportsInterface(0x01ffc9a7)，这是 ERC-165 本身的接口 ID。
    // 如果返回 true，说明合约可能支持 ERC-165。
    // 如果返回 false 或调用失败，说明该合约不支持 ERC-165。

    // 第二次调用：
    // 使用 supportsInterface(0xffffffff) 进行调用。
    // 根据标准，supportsInterface(0xffffffff) 应该总是返回 false。
    // 如果第二次调用失败或返回 true，则说明该合约错误地实现了 ERC-165。