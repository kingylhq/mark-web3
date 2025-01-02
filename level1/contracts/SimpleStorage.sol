
// SPDX-License-Identifier: MIT
pragma solidity  0.8.26;


contract SimpleStorage {

    // bool hasWater = true;
    uint256 public favoriteNumber;
    // string str = "marklsy";
    // bytes b = "0xe2e2";
    // int256 i = 590;
    // address myAdd = "";
    People public person = People({favoriteNumber: 20, name: "lsy"});

    // 定义数组
    People[] public people;

    // 将名字映射为key, favoriteNumber 为 value
    mapping (string => uint256) public nameToFavorites; 

    struct People {
        uint256 favoriteNumber;
        string name;
    }

    function store (uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
        // favoriteNumber = favoriteNumber + 100000; // 会消耗更多的gas
    }

    // 读取区块链数据不需要支付gas,只有发生交易状态发生改变才需要支付gas
    // 但是在消化了gas的函数中调用了view、pure函数也会消化gas
    // view 不允许修改任何状态, 单独调用不需要支付gas
    function retrieve () public view returns(uint256) {
        return favoriteNumber;
    }

    // pure 也不允许修改任何状态, 也不允许读取区块链数据, 单独调用不需要支付gas
    function  add() public pure returns(uint256) {
        return (1 + 1);
    }

    // 掌握着三张存储方式
    // colldata 修饰不能被修改的临时变量
    // memory   修饰可被修改的临时变量
    // storage  可被修改的永久变量
    function addPerson (string memory _name, uint256 _favoriteNumber) public {
        // 写法一
        // peoples.push(People(_favoriteNumber, name));

        // 写法二
        People memory peo = People({favoriteNumber: _favoriteNumber, name: _name});
        people.push(peo);

        nameToFavorites[_name] = _favoriteNumber;

    }


    

}

