// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract HelloWorld {
    // This is a single-line comment  0xF4EF13a0c667B0dF23197106Df29ffBd491ddd0B
    // 0x5B3...eddC4 (99.999999999999119686 ether)
    string storeMsg;

    function set(string memory message) public {
        storeMsg = message;
    }

    function get() public view returns (string memory) {
        return storeMsg;
    }
}