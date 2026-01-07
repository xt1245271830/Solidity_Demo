// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract FunMod {
    uint public count=11;

    modifier whereNoti(){
        require(count>10, "count<=10");
        _;
    }
        
    function inc()external whereNoti{
        count +=1;
    }
    function dec()external whereNoti{
        count -=1;
    }

    modifier whereNoti1(uint i){
        require(i>10, "count<=10");
        _;
    }
    function inc1(uint i)external whereNoti1(i){
        count +=1;
    }
    function dec1(uint i)external whereNoti1(i){
        count -=1;
    }

    modifier whereNoti2(){
        count += 100;
        _;
        count /= 2;
    }
    function inc2()external whereNoti2(){
        count +=1;
    }
    function dec2()external whereNoti2(){
        count -=1;
    }
}