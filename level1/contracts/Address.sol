
// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract  AddressTest {

    // 值类型
    function testTransfer(address payable x) public {
        address myAddress = address(this);

        // 如果x的余额小于10，合约的余额大于等于10，则给x转10wei
        if (x.balance < 10 && myAddress.balance >= 10) {
            x.transfer(10);                
        }
    }
    
}

