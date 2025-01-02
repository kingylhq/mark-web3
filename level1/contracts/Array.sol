
// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

// 引用数据类型
contract  DataHander {
    // 数据存储位置
    // memory:
    //      数据仅在函数调用期间存在，函数调用结束后自动释放。
    //      用于局部变量，不能用于外部调用

    // storage（存储）：
    //      数据存储在合约的持久化存储中，状态变量默认存储在这里。
    //      只要合约存在，数据就一直保存在区块链上。

    // calldata（调用数据）：
    //      用于存储函数参数的特殊数据位置。
    //      是一个不可修改的、非持久的存储区域，通常用于外部函数调用时的参数传递。

    // 数据位置的选择
    // 优化建议：
    // 如果可能，尽量使用 calldata 来存储数据，因为它既节省 Gas，又确保数据不可修改。
    // 使用 memory 来存储临时数据，以减少合约的持久化存储开销。
    // 使用 storage 来存储需要长期保存的数据，但要注意其较高的 Gas 消耗。

    uint[] public data;  // 存储的在storage中的数据

    // 将内存总memory中的数据复制到storeage中的data存储
    function updateData(uint[] memory newData) public {
        data = newData;
    }

    // 返回storage中存储的数据
    function getData() public view returns(uint[] memory) {
        return data;
    }

    // 修改storeage中存储的数据
    function modifyStoreData(uint index, uint value) public {
        require(index < data.length, "Index out of bounds");
        data[index] = value;
    }

    // 尝试修改传入的memory的内存数据
    function modifyMemoryData(uint[] memory md) public pure returns(uint[] memory) {
        if (md.length > 0) {
            md[0] = 99;
        }
        return md;
    }


    // 直观理解引用类型的赋值与数据位置的关系。
    uint[] x; // x 的数据存储位置是 storage
    function f(uint[] memory memoryArray) public {
        x = memoryArray; // 将整个数组拷贝到 storage 中
        uint[] storage y = x; // 分配一个指针，y 的数据存储位置是 storage
        y[0] = 100; // 修改 y 的值，同时 x 的值也会改变
        delete x; // 清除 x，同时影响 y
    }
    function g(uint[] storage) internal pure {}
    function h(uint[] memory) public pure {}
    
    // 关键点： - x 是状态变量，存储在 storage 中。 - f 函数演示了从 memory 到 storage 的赋值，
    // 以及在 storage 中引用同一数据时的修改行为。 
    // - 通过 g 函数和 h 函数展示如何在不同数据位置之间传递数据
}

// 数组
contract  DataArray {
    
    uint[] public dynamicArray;  // 存储的在storage中的数据
    // 
    function addElement(uint _element) public {
        dynamicArray.push(_element);
    }
    // 删除数组最后一个元素
    function removeLastElement() public {
        dynamicArray.pop();
    }
    function getLength() public view returns (uint) {
        return dynamicArray.length;
    }

    // 实践练习：
    // 编写合约，允许用户动态管理一个地址数组。
    // 实现一个函数，接收数组作为参数并返回其元素之和。
    // 创建一个函数，删除数组中的特定元素并调整数组长度。

    address[] public addArray;
    function addArr(address _element) public {
        addArray.push(_element);
    }
    function arrLen(string[] memory arr) public pure returns (uint) {
        return arr.length;
    }
    function arrDel(string[] memory arr, uint index) public pure returns (string[] memory)  {
        string[] memory newArr = new string[](arr.length - 1);
        
        for (uint i = 0; i < index; i++) {
            newArr[i] = arr[i];
        }
        for (uint i = index + 1; i < arr.length; i++) {
            newArr[i - 1] = arr[i];
        }
        return newArr;
    }

    // 
    bytes public byteData = new bytes(10);

}

