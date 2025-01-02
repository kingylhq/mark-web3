// SPDX-License-Identifier: MIT
pragma solidity  0.8.26;

// 引入合约文件
import "./SimpleStorage.sol";

// 合约中部署合约
contract StorageFactory {

    SimpleStorage[] public simpleStorageArray;

    function createSimpleStorageContract() public {
        SimpleStorage simpleStorage = new SimpleStorage();
        simpleStorageArray.push(simpleStorage);
    }


}

