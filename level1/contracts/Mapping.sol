
// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

// 映射
contract  MappingExample {

    mapping (address => uint) public balances;
    function update(uint newBalances) public returns (address) {
        balances[msg.sender] = newBalances;
        return msg.sender;
    }
}

contract MappingUser{

    function f() public returns(uint) {
        MappingExample me = new MappingExample();
        me.update(1000);
        // 通过 getter 函数访问 balances , balances 是 public,默认生成了getter方法
        return me.balances(address(this));
    }
}

// 作业
// 任务 1：基于映射创建一个简单的用户余额管理系统，并实现余额的增加与查询功能。
// 任务 2：扩展系统，使其能够记录每个用户的交易历史，模拟 Java 的 Map 中键集合的概念。
// 任务 3：结合映射与数组，实现一个简单的排行榜系统，记录并排序用户的积分。
contract PointsSystem {

    mapping (address => uint) public points;
    address[] public users;
    function addUser(address add) public  {
        require(points[add] == 0, "user already exist");
        points[add] = 100000000; // 默认余额
        users.push(add);
    }
    function transferPoints(address _to, uint _amount) public  {
        require(points[msg.sender] >= _amount, "Insufficient points.");
        points[msg.sender] -= _amount;
        points[_to] += _amount;
    }
    function getAllUsers() public returns (address[] memory) {
        return users;
    }
    function getPoints(address userAdd) public returns (uint) {
        return points[userAdd];
    }


}

