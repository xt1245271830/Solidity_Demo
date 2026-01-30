// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

//时间锁：比如你想执行一笔交易，可以先把交易入队存在queue队列里面，等一段时间（一天、一星期、一个月都可以）再去用execute执行这笔交易，
//这样做的作用就是可以在queue队列里面检查这笔交易有没有危险，检查你有没有执行危险的操作
contract TimeLock {
    error NotOwnerEror();
    error AlreadyQueuedError(bytes32 txId);
    error TimestampNotInRangeError(uint timestamp,uint _timestamp);
    error NotQueuedError(bytes32 txId);
    event Queue(
        bytes32 indexed  txId,
        address indexed target,
        uint value,
        string  func,
        bytes  data,
        uint timestamp);
    //只让当前合约的拥有者可以执行交易
    address public owner;
    //用来判断队列里面的txId是否存在
    mapping (bytes32 => bool) public queued;
    //最小延迟
    uint public constant MIN_DELAY = 10;
    //最大延迟
    uint public constant MAX_DELAY = 1000;
    constructor() {
        //只让当前合约的拥有者可以执行交易
        owner = msg.sender;
    }
    //只要有payable合约接受以太都需要有receive函数
    receive() external payable { }

    //限制只让当前合约的拥有者可以执行交易，否则报错
    modifier onlyOwner (){
        if(msg.sender != owner){
            revert NotOwnerEror();
        }
        _;
    }



//时间锁：比如你想执行一笔交易，可以先把交易入队存在queue队列里面，等一段时间（一天、一星期、一个月都可以）再去用execute执行这笔交易，
//这样做的作用就是可以在queue队列里面检查这笔交易有没有危险，检查你有没有执行危险的操作
    
    //_target调用的合约地址，_valu发送的以太数量，_func函数名称,_data发送的数据，_timestamp延迟的时间
    function queue(
        address _target,
        uint _value,
        string calldata _func,
        bytes calldata _data,
        uint _timestamp) external {
            //创建一个交易 tx id
            bytes32 txId = getTxId(_target,_value,_func,_data,_timestamp);
            //检查txid是否唯一
            if(queued[txId]){
                //不唯一则报错
                revert AlreadyQueuedError(txId);
            }
            //检查时间_timestamp设置是否正确，必须在最小延迟和最大延迟范围内
            if(_timestamp < block.timestamp + MIN_DELAY || _timestamp > block.timestamp + MAX_DELAY){
                //否则报错
                revert TimestampNotInRangeError(block.timestamp,_timestamp);
            }
            //入队
            queued[txId] = true;

            emit Queue(txId,_target,_value,_func,_data,_timestamp);
        }

    //_timestamp为最小延迟结果时间
    function execute(
        address _target,
        uint _value,
        string calldata _func,
        bytes calldata _data,
        uint _timestamp) external payable onlyOwner returns (bytes memory){
        //创建一个交易 tx id
        bytes32 txId = getTxId(_target,_value,_func,_data,_timestamp);
        //检查txid是否入队了，只能执行入队的交易
        if(!queued[txId]){
            //没入队，则报错
            revert NotQueuedError(txId);
        }
        //当前时间超过最小延迟就可以执行
        if(_timestamp < block.timestamp){
            //否则报错
            revert TimestampNotInRangeError(block.timestamp,_timestamp);
        }
        
    }

        //创建一个txdi
    function getTxId(address _target,
        uint _value,
        string calldata _func,
        bytes calldata _data,
        uint _timestamp) public pure returns(bytes32 txId) {
        return keccak256(abi.encode(_target,_value,_func,_data,_timestamp));
    }
}

contract TestTimeLock {
    address public  timeLock;

    constructor(address _timeLock) {
        timeLock = _timeLock;
    }

    // function test() external {
    //     require(msg.sender == timeLock);
    //     //升级合约
    //     //转移资产
    //     //修改预言机
    // }
}