// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract ItMap {
    mapping(address => uint) balances;
    mapping(address => bool) inser;
    address[] keys;

    function set(address key,uint b) external {
        balances[key] = b; 
        if(!inser[key]){
            inser[key] = true;
            keys.push(key);
        }   
    }

    function get(uint index) external view returns (uint) {
         require(index < keys.length, "Index out of bounds");
        return balances[keys[index]];
    }

    function first() external view returns (uint) {
        require(keys.length > 0, "No keys");
        return balances[keys[0]];
    }

    function last() external view returns (uint) {
        require(keys.length > 0, "No keys");
        return balances[keys[keys.length-1]];
    }

    function getSize() external view returns (uint){
        return keys.length;
    }
}