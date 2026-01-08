// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Efficient {
    uint[] arr = [1,2,4];

    function efficientRemove(uint index) external {
        require(index<arr.length,"error");
        arr[index] = arr[arr.length-1];
        arr.pop();

        assert(arr.length==2);
        assert(arr[0]==4);
        assert(arr[1]==2);
    }
}