
// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

// 合约类型
contract Hello {

    function sayHi() public {
        // 合约成员函数
    }

    // 获取当前合约地址
    function getAddress() public view returns (address) {
        return address(this);
    }

    // 可支付回调函数
    receive() external payable  {
        // 
    }

    // 销毁合约
    function destroy(address payable recipient) public {
        // 这个版本去掉了
    }

    // 获取合约信息
    // function getContractInfo() public view returns(string memory, bytes memory, bytes memory) {
    // return (type(Hello).name, type(Hello).;
    // }

    function isContract(address addr) public view returns (bool){
        uint256 size; 
        assembly { size := extcodesize(addr) } // 获取地址的代码大小
        return size > 0;  // 大于0说明是合约地址
    }

    
}

