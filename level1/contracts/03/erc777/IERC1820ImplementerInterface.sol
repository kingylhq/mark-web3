// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;


/// @dev 如果合约为其他的地址实现了接口， 则必须实现这个接口。
interface IERC1820ImplementerInterface { 

    /// @notice 指示合约是否为地址 “addr” 实现接口 “interfaceHash”。
    /// @param interfaceHash 接口名称的 keccak256 哈希值
    /// @param addr 为哪一个地址实现接口
    /// @return 只有当合约为地址'addr'实现'interfaceHash'时返回 ERC1820_ACCEPT_MAGIC
    function canImplementInterfaceForAddress(bytes32 interfaceHash,address addr) external view returns(bytes32); 

}