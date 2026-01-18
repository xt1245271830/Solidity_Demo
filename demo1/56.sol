// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;
contract MultiSigWallet{
//多签钱包：（多重签名钱包）是一种通过多方协同授权机制管理资产的区块链工具，
//要求至少 M 个私钥持有者共同签名才能完成交易（如 2/3 或 3/5 模式），从而防止单点故障或未经授权的资金操作‌
    
//存款，当用户把钱存进来时出发记录log
event Deposit(address indexed sender, uint amount);
//提交，我们想要执行一笔交易，需要先把这笔交易提交到钱包里面
event Submit( uint indexed txId);
//合约的owner（拥有者）允许我们执行这笔交易，txId为交易id
event Approve(address indexed owner, uint indexed txId);
//当拥有者想返回一个自己
event Revoke(address indexed owner, uint indexed txId);
//满足一定数量的拥有者后，就可以执行这笔交易
event Execute(uint indexed txId);

//交易的结构，以下是交易的标准字段
struct Transaction{
    //发给谁
    address to;
    //带多少以太
    uint value;
    //最重要的data字段
    bytes data;
    //有没有被执行过
    bool executed;
}


//保存多个拥有者的数组
address[] public owners;
//把这些地址快速判断是否是拥有者，结果存进mapping中
mapping(address => bool) public isOwner;
//这笔交易的最少拥有者数量，达到这个数量才可以进行这笔交易
uint public required;

//所有提交的交易
Transaction[] public transactions;
//交易是否被允许,uint代表Transaction的一个id,address就是Owner拥有者
mapping (uint => mapping (address => bool)) public approved;
