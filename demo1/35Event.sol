// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Event {
    //事件
    event log (address addr,uint i);
    //indexed修饰后，参数可以用来查询
    event IndexedLog(address indexed addr,uint i);

    function setLog() external {
        //触发事件
        emit log(msg.sender,123); 
        emit IndexedLog(msg.sender,124124); 
    }

    event Message(address indexed from,address indexed to,uint i);
    //最便宜的发送信息的小应用
    function senderMessage(address to) external {
        emit Message(msg.sender,to,10009);
    }
}