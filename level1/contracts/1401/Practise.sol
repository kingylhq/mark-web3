pragma solidity 0.8.26;


// 练习***************

// 创建一个 Utils 合约，其中有 sum 方法，传入任意数量的数组，都可以计算出求和结果。

contract Utils {

    function getArrSum(uint[] memory arr) public pure returns (uint) {
        uint total = 0;
        for (uint i = 0; i < arr.length; i++){
            total += arr[i];
        }
        return total;
    }

}