// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

/**
 * @dev ERC165 标准的接口 https://eips.ethereum.org/EIPS/eip-165
 * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified
 */
interface IERC165 {
    /// @notice 查询合约是否实现接口
    /// @param interfaceID ERC-165 中指定的接口标识符
    /// @dev 接口标识在 ERC-165 中指定。此功能需要低于 30,000 gas。
    /// @return 如果合约实现了 interfaceID 且 interfaceID 不是 0xffffffff，则为 true，否则为 false
    function supportsInterface(bytes4 interfaceID) external view returns (bool);
}