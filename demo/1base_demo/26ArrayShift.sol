// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract ArrayShift {
    uint[] array1;
    uint[3] array2 = [6,3,3];


    function remove(uint[] memory arr,uint index) public {
        array1=arr;
        for (uint i=index; i<array1.length-1; i++) {
            array1[i] = array1[i+1];
        }
        array1.pop();

        assert(array1[0]==2);
        assert(array1[1]==4);
        assert(array1.length==2);
    }

    // function removeElement(uint[] memory arr, uint index) public pure returns(uint[] memory) {
    //     require(index < arr.length, "Index out of bounds");
    //     for (uint i = index; i < arr.length - 1; i++) {
    //         arr[i] = arr[i + 1];
    //     }
    //     arr.pop();
    //     return arr;
    // }
}