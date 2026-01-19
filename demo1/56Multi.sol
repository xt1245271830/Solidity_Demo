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
//当拥有者想撤回自己提交的交易，前提是该交易还未执行
event Revoke(address indexed owner, uint indexed txId);
//满足一定数量的拥有者后，就可以执行这笔交易
event Execute(uint indexed txId);

//交易的结构，以下是交易的标准字段
struct Transaction{
    //发给谁
    address to;
    //带多少以太
    uint value;
    //最重要的data字段，签名和参数
    bytes data;
    //有没有被执行过
    bool executed;
}


    //保存多个拥有者的数组
    address[] public owners;
    //把这些地址快速判断是否是拥有者添加过，结果存进mapping中
    mapping(address => bool) public isOwner;
    //这笔交易的最少拥有者数量，达到这个数量才可以进行这笔交易
    uint public required;

    //所有提交的交易
    Transaction[] public transactions;
    //Owne交易是否被允许,uint代表Transaction的一个id,address就是Owner拥有者
    mapping (uint => mapping (address => bool)) public approved;

    //_owners所有该笔交易的拥有者，_required这笔交易最少owner数量
    constructor(address[] memory _owners, uint _required) {
        //owners数组长度必须大于零
        require(_owners.length>0, "owners required");
        require(_required>0 && _required<=_owners.length, "_required Incorrecto");
        //把owner写入数组owners，方便后续使用
        for (uint i=0; i<_owners.length; i++) {
            address owner=_owners[i];
            //owner不能未为0
            require(owner != address(0), "owners required");
            //owner必须是未添加过的
            require(!isOwner[owner], "Owner debe ser sin agregar");
            owners.push(owner);
            isOwner[owner] = true;
        }
        required = _required;
    }

    //用receive触发存款事件并发送交易的以太
    receive() external payable {
        emit Deposit(msg.sender,msg.value);
    }

    //onlyOwner为判断只有owner可以提交交易,owner在一笔交易中不能重复出现
    modifier onlyOwner(){
        require(isOwner[msg.sender],"The owner is already in the transaction process");
        _;
    }
    //交易必须存在
    modifier txExists(uint _txId){
        require(_txId<transactions.length,"The transaction does not exist");
        _;
    }
    //交易必须还没有被允许过
    modifier notApprove(uint _txId){
        require(!approved[_txId][msg.sender],"The transaction has been allowed");
        _;
    }

    //这笔交易必须没有执行
    modifier notExecuted(uint _txId){
        require(!transactions[_txId].executed,"The transaction has been executed");
        _;
    }    
    //只有owner可以提交这笔交易，这笔交易需要满足required数量，参数为Transaction的结构，外部函数使用calldata可以节省一些gas，onlyOwner为判断只有owner可以提交交易,owner在一笔交易中不能重复出现
    function submit(address _to,uint _value,bytes calldata _data) external onlyOwner{
        //把交易提交到transactions中
        transactions.push(Transaction({
            to:_to,
            value:_value,
            data:_data,
            executed:false
        }));
        //txId交易id设置为插入数据的索引
        emit Submit(transactions.length-1);
    }
    


    //approve 合约的owner（拥有者）允许我们执行这笔交易，要保证：只有owner可以提交交易,owner在一笔交易中不能重复出现，交易必须存在，owne交易必须还没有被允许过，这笔交易没有执行
    //onlyOwner只有owner可以提交交易,owner在一笔交易中不能重复出现，
    //txExists交易必须存在
    //notApprove owne交易必须还没有被允许过
    //notExecuted这笔交易没有执行
    function approve(uint _txId) external onlyOwner txExists(_txId) notApprove(_txId) notExecuted(_txId){
        emit Approve(msg.sender,_txId);
        approved[_txId][msg.sender] = true;
    }

    //查询一下owner数量有没有满足交易的最小数量,统计owner的交易被允许的数量
    function getApproveCount(uint txId)private view returns (uint count) {
        for (uint i; i<owners.length; i++) {
            if(approved[txId][owners[i]]){
                count+=1;            
            }
        }
    }
    //执行交易，要保证：交易必须存在，这笔交易没有执行
    //txExists交易必须存在
    //notExecuted这笔交易没有执行
    function execute(uint _txId) external txExists(_txId) notExecuted(_txId){
        require(getApproveCount(_txId) >= required, "ApproveCount < required");
        //获取交易结构体，使用storage因为需要修改获取到的结构体
        Transaction storage transaction = transactions[_txId];
        transaction.executed = true;

        //发送给谁transaction.to，transaction.value以太数量，transaction.data发送时携带的签名
        (bool success, ) = transaction.to.call{value: transaction.value}(
            transaction.data
        );
        require(success, "tx failure");

        emit Execute(_txId);
    }

    //撤销允许过的交易，要保证：只有自己可以撤销，交易必须存在，交易还没有执行过
    //onlyOwner只有owner可以提交交易,owner在一笔交易中不能重复出现，
    //txExists交易必须存在
    //notExecuted这笔交易没有执行
    function revoke(uint _txId) external onlyOwner txExists(_txId) notExecuted(_txId){
        //检查交易是否被允许过了，因为方法是要撤销允许的交易，没允许过自然不用撤销
        require(approved[_txId][msg.sender], "tx not approved");
        approved[_txId][msg.sender]=false;
        emit Revoke(msg.sender, _txId);
    }
}