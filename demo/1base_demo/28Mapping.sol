// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Mapping {
    mapping(address => uint) public map;
    mapping(address => mapping(address => bool)) mapBoll;

    function name() external {
        map[msg.sender] = 123;
        assert(map[msg.sender]==123);
        map[msg.sender] += 456;
        assert(map[msg.sender]==579);
        uint x = map[msg.sender];
        assert(x==579);
        uint x1 = map[address(0)];
        assert(x1==0);
        delete map[msg.sender];
        assert(map[msg.sender]==0);

        mapBoll[msg.sender][msg.sender]=true;
        mapBoll[msg.sender][address(this)]=true;
    }
}