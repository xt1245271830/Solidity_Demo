// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract ViewAndPureFunction {
    uint public num=123;
    function viewFun() external view returns (uint) {

        return num;
    }

    function pureFun() external pure returns (uint) {

        return 1;
    }

    function pureFun2(uint x) external pure returns (uint) {

        return x;
    }
}