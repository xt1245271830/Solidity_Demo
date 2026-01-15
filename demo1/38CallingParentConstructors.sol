// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract A {
    string text1;

    constructor(string memory _text1) {
        text1 = _text1;
    }
}

contract B {
    string text2;

    constructor(string memory _text1) {
        text2 = _text1;
    }
}

contract C is A,B{
    constructor(string memory _text1,string memory _text2) A(_text1) B(_text2){}
}