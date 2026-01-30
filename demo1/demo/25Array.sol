// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Array {
    uint[] array1 = [1,2,4];
    uint[3] array2 = [6,3,3];

    function ary()external {
        array1.push(6);
        array1.length;
        array1[0]=100;
        delete array1[3];
        array1.pop();
        uint i = array1[0];

        uint[] memory arrya3 = new uint[](5);
        arrya3[0]=213;
        
    }
    
    function retArrya()external view returns (uint[] memory) {
        return array1;
    }
}