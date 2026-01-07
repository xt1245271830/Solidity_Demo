// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract MyOwnable {
    address public owner;
    uint public count=0;
    constructor() {
        owner=msg.sender;
    }

    modifier onlyOwner(){
        require(owner==msg.sender, "not owner");
        _;
    }

    function transferOwnership1(address addr) external onlyOwner{
        require(msg.sender != address(0) && addr!=address(0), "address error!");
        owner = addr;
    }

    function inc() external{
        count+=1;
    }
    function ownerReset() external onlyOwner{
        count=0;
    }           
}