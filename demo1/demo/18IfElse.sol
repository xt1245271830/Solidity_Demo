// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
contract IfElse {
    function processNumber(uint _x)external pure returns (string memory) {
        if(_x < 10){
            return unicode"小于10";
        }else if(_x<=20){
            return unicode"介于10到20";
        }else {
            return unicode"大于20";
        }
    }

    function processNumber2(uint _x)external pure returns (string memory) {
        return _x<10 ? unicode"小于10" : _x<=20 ? unicode"介于10到20" : unicode"大于20";
    }
}