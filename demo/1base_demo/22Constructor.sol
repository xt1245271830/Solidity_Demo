// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Con {
    uint public value;
    address public addr;
    constructor(uint i) {
        value=i;
        addr=msg.sender;
    }
}