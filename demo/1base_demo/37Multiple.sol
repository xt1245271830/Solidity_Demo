// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract A {
    function functionA()external pure virtual returns (string memory){
        return "Function A from contract A";
    }
}

contract B is A{
    function functionA()external pure virtual override returns (string memory){
        return "Function A from contract B";
    }
}

contract C is A,B{
    function functionA()external pure override(A,B) returns (string memory){
        return "Function A from contract C";
    }
}