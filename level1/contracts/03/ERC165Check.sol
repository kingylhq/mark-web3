// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "./IERC165.sol";

// 使用 Solidity 和 EVM 静态调用检测合约是否实现 ERC-165
contract ERC165Checker {

    
    function checkERC165(address contractAddress) public view returns (bool) {
        // 1. 第一次调用 supportsInterface(0x01ffc9a7)
        (bool success, bytes memory result) = contractAddress.staticcall(
            abi.encodeWithSelector(IERC165.supportsInterface.selector, 0x01ffc9a7)
        );

        if (!success || result.length < 32) {
            return false; // 不支持 ERC-165
        }

        bool supportsERC165 = abi.decode(result, (bool));
        if (!supportsERC165) {
            return false; // supportsInterface(0x01ffc9a7) 返回 false
        }

        // 2. 第二次调用 supportsInterface(0xffffffff)
        (success, result) = contractAddress.staticcall(
            abi.encodeWithSelector(IERC165.supportsInterface.selector, 0xffffffff)
        );

        if (!success || result.length < 32 || abi.decode(result, (bool))) {
            return false; // supportsInterface(0xffffffff) 不符合标准
        }

        // 合约正确实现 ERC-165
        return true;
    }
    
}