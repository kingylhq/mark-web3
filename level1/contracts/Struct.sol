// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract StructExample {

    // 用户结构体
    struct User {
        string name;
        uint age;
        mapping (string => uint) score;
    }
    mapping (address => User) public users;
    function createUser(string memory _name, uint _age) public {
        User storage user = users[msg.sender];
        user.name = _name;
        user.age = _age;
    }
    function updateUserScore(string memory _subject, uint _score) public returns(address) {
        users[msg.sender].score[_subject] = _score;
        return msg.sender;
    }
    // 需要读取合约的数据，这里需要加view
    function getUserScore(string memory _subject) public view returns(uint) {
        return users[msg.sender].score[_subject];
    }
}

// 作业：

// 任务 1：创建一个合约，定义一个结构体用于存储产品信息，包括产品 ID、名称、价格和库存。实现增加、修改和查询产品信息的功能。
// 任务 2：扩展合约，定义一个结构体用于存储订单信息，并实现订单的创建和查询功能，考虑如何设计结构体以便有效存储和访问订单数据。
// 任务 3：设计一个用户管理合约，使用结构体记录用户的个人信息、余额及交易历史，探索如何优化结构体的设计以减少存储成本。

contract ProductsExample {

    // 1,pc,20000,109
    struct Product {
        uint id;     // id
        string name; // 名称
        uint price;  // 价格
        uint stock;  // 库存
    }

    mapping (uint => Product) public products;
    uint public productCount;
    // 添加产品
    function addProduct(uint _id, string memory _name, uint _price, uint _stock) public {
        productCount++;
        products[_id] = Product(_id, _name, _price, _stock);
    }
    // 更新库存
    function updateProductStock(uint _id, uint _stock) public {
        Product storage p = products[_id];
        p.stock = _stock;
    }
    // 获取产品信息
    function getProduct(uint _id) public view returns(string memory, uint, uint) {
        Product storage p = products[_id];
        return (p.name, p.price, p.stock);
    }

}




