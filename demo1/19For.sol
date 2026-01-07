// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract For {
    function name(uint n) external pure returns (uint){
        uint sum = 0;
        for (uint i=1; i<=n; i++) {
            sum+=i;
        }
        return sum;
    }

    // 定义一个函数来计算从1到n的累加和
    function sum1(uint n) external pure returns (uint) {
    uint total = 0;
    for (uint i = 1; i <= n; i++) {
    total += i;
    }
    return total;
    }
}