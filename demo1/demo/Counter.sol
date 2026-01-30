// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Counter {
    uint public num;
    function inc()external  {
        num+=1;
    }

    function dec() external {
        num-=1;
    }
}