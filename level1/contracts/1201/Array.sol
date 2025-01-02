// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Arrays {

    // 定义数组的多种方式
    // 静态数组字面值初始化
    uint[3] nftArr = [uint(1000), 1001, 1002];

    uint[] public array_nfts;

    // 动态数组初始化
    // 动态数组的初始化需要使用关键字 new。它的所有元素值会被「零值初始化」，即赋予默认值。以下是一个整型动态数组的初始化示例
    // 初始化了一个有三个元素的动态数组，元素值被初始化为零值

    uint n = 3;
    uint[] nftArray = new uint[](n);
    // 使用 new 关键字可以在任何数据位置创建动态数组。如果你的动态数组是在 storage 中声明的，你也可以使用数组字面值来初始化
    // 在 storage 的动态数组可以用数组字面值初始化
    uint[] storageArr = [uint(1), 2]; // 动态数组只有在storage位置才能用数组字面值初始化

    // 数组切片
    // 数组切片（array slice）是建立在数组基础上的一种视图（view）。其语法形式为 arr[start:end]。这个视图包含的是从索引 start 到索引 end-1 的元素。
    // 与数组不同的是，切片是没有具体类型的，也不会占据存储空间。它是一种方便我们处理数据的抽象方式。

    // start 和 end 可以被省略。如果省略了 start，则视图将包含从索引 0 到索引 end-1 的元素：
    // 如果省略了 end，则视图将包含从索引 start 到数组末尾的元素：
    // 如果 start 和 end 都省略了，那么会包含 arr 所有元素：

    // 数组切片截取字符串前 4BYTES
    // 如果输入"abcdef"，将会输出"abcd"
    function arr(string calldata payload) public view returns (string memory, string memory, string memory, string memory) {
        string memory str1 = string(payload[:4]);  // abcd
        string memory str2 = string(payload[2:]);  // cdef
        string memory str3 = string(payload[1:3]); // bc
        string memory str4 = string(payload);      // abcdef
        return (str1, str2, str3, str4);
    }

    // 数组长度
    function arrLen(uint[] memory arrayUint) public view returns (uint, uint) {
        uint[3] memory arr1 = [uint(1000), 1001, 1002];
        uint[] memory arr2 = new uint[](3);
        uint arr1Len = arr1.length; 
        uint arr2Len = arr2.length;
        return (arr1Len ,arr2Len);
    }

    // 动态数组成员函数
    // 只有当动态数组位于存储（storage）位置时，它才具备成员函数。与此相对，静态数组以及位于 calldata 或 memory 中的动态数组不具备任何成员函数。这些成员函数可以改变数组的长度，具体包括：

    // push()：在数组末尾增加一个元素，并赋予零值，使得数组长度增加一。
    // push(x)：将元素 x 添加到数组末尾，同样使数组长度增加一。
    // pop()：从数组末尾移除一个元素，导致数组长度减少一。
    // 注意 只有当动态数组的数据位置为存储（storage）时，才可以使用成员函数 push(), push(x), 和 pop()。这三个函数都会影响数组的长度：
    // 注意这三个成员函数会改变数组的长度
    // push 和 pop 函数示例

    uint[] arrStorage; //定义在storage位置的数组_
    function pushPop() public returns(uint) {
        // 刚开始没有任何元素_
        arrStorage.push(); // 数组有一个元素：[0]
        arrStorage.push(1000); //数组有两个元素：[0, 1000]
        arrStorage.push(699); 
        arrStorage.pop(); // 数组剩下两个元素： [0, 1000]
        return arrStorage.length;
    }
    // 如果尝试在静态数组或数据位置不为 storage 的动态数组上执行上述成员函数（如 push() 或 pop()），编译器将会报错。
    // 这些操作仅适用于存储在 storage 中的动态数组：
    // 编译错误：静态数组或非 storage 动态数组不能使用 push 或 pop 成员函数。

    // uint[3] memory arrMemory;
    // arrMemory.push(1); //编译错误，只有 storage 上的动态数组才能调用 push 函数_
    // arrMemory.pop(); // 编译错误，只有 storage 上的动态数组才能调用 pop 函数_

    // uint[] memory arr = new uint[](3);
    // arr.push(1); //编译错误，只有 storage 上的动态数组才能调用 push 函数_
    // arr.pop(); // 编译错误，只有 storage 上的动态数组才能调用 pop 函数_

    // 多维数组，很少用到

    

}