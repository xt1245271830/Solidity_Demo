// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract ValueTypes {
    bool public b=true;
    uint public u=123;  //uint is unsigned integer
    int public i=-123;

    int public minInt=type(int).min;
    int public maxInt=type(int).max;
    address public addr;
    bytes32 public b32=keccak256(abi.encodePacked("Cyborg"));
}