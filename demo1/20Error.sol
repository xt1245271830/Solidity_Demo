// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Error {
    function req(uint i)public pure {
        require(i>10, "i < 10");
    }

    function rev(uint i) public pure returns (uint){
        if (i>2){
            if(i>10){
                revert("i>10");
            }
            return i;
        }
        return i;
    }

    uint public num=123;
    function asse()public view {
        assert(num==123);
    }

    function req2(uint i)public {
        num+=1;
        require(i>10);
    }

    error MyError(address add,uint i);

    function req3(uint i)public view {
        revert MyError(msg.sender,i);
        //require(i>10,"fwfjiowejhfoiwehfioweiofhdfgewfwfoweifiowejofweiohowehfowehjiowehfiowe");
    }
}