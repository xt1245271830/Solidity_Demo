// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Outputs {
    uint public i1;
    bool public b1;
    string public str1;
    function returnMultiple() public  pure returns (uint i,bool b,string memory str){
        i = 1;
        b = true;
        str = "Hello";
    }

    function captureOutputs()public {
        (uint i,bool b,string memory str) = returnMultiple();
        i1 = i;
        b1 = b;
        str1 = str;
    }

    function displayOutputs()external view returns (uint,bool,string memory) {
        return (i1,b1,str1);
    }
}