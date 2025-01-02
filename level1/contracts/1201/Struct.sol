// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

struct Book {

    string title; // 书名

    uint price;   // 价格

}

contract MyContract {

    // datalocation 数据位置， storage、memory、calldata
    // 在 Solidity 中，memory 关键字只能用于函数内的局部变量或参数，用来指定变量存储在内存中，而不能用于全局变量。
    // Book memory book;
    // 定义为 storage 类型（状态变量）
    Book public book;

    // 示例函数设置 book
    function setBook(string memory _title, uint _price) public {

        // Book memory book1 = Book({title: "fds", price: 9999999999999999});
        // Book memory book3;
        // book3.title = "my book title"; // 给结构体成员赋值_
        // book3.price = 25; // 给结构体成员赋值_

        book.title = _title;
        book.price = _price;
    }

    function getBook() public view returns (string memory, uint) {
        return (book.title, book.price);
    }

    // 结构体可以和数组，映射类型互相嵌套
    // 通过使用结构体，数据管理在 Solidity 中变得更加方便和高效。结构体不仅可以独立使用，还可以与数组和映射类型进行嵌套（映射类型将在下一节中详细介绍）。
    // 这种嵌套能力显著增强了 Solidity 的编程表达力和灵活性。如下所示：
    // 结构体数组
    Book[] public lib; // Book数组，状态变量_
    function addNewBook(Book memory book) public {
        lib.push(book);
    }

}
