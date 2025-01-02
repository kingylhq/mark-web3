// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

// 合约结构体基本语法

contract ContractStructBase {

    uint sum = 0;
    
    struct User {
        uint id;
        string name;
        uint salary;
    }

    uint[]  userIds;
    mapping (address => User) public users;
    
    function add(uint x, uint y) public pure returns(uint, uint) {
        return (x + y, x * y); 
    } 

    function addUser(uint _id, string memory _name, uint _salary) public {
        userIds.push(_id);
        users[msg.sender] = User({id: _id, name: _name, salary: _salary});
    }

    // 直接返回结构体会报错，因为没有构造函数。如果想让它不报错，使用initialize()方法
    function getUser(uint _id) public view returns (string memory, uint) {
        User memory temp = users[msg.sender];
        return (temp.name, temp.salary);
    }

    // 事件
    event received(address sender, uint newBalance);
    event fallbackCalled(address sender, uint newBalance);

    // 仅用于接收以太币，没有其他数据时
    receive() external payable {
        // 触发事件
        emit received(msg.sender, msg.value);
    }
    // 函数或调用签名不存在时，包含其他数据(以太币之外的其他数据)
    fallback() external payable { 
        emit fallbackCalled(msg.sender, msg.value);
    }



}