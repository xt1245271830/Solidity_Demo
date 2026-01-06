// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract SimpleStorage {
    uint public storedData;
    uint public storedData12;
    function set(uint x) external {
        storedData=x;
    }
    function get() public view returns (uint){
        return storedData;
    }
}