// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

// 部署测试
// 账户 1（deployer）：-> launch
// 账户 2 -> pledge
// 账户 3 -> pledge
interface IERC20 {
    //把钱从当前合约转到to
    function transfer(address to, uint256 amount) external returns (bool);
    //转账，由用户转到当前合约中
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

//筹集资金，筹集资金类型未IERC20
contract CrowdFund {
    //发起众筹成功事件
    event Launch(uint id,address indexed creator,uint goal,uint startAt,uint endAt);
    //取消众筹成功事件
    event Cancel(uint id);
    //认捐资金成功事件，id众筹id，caller认捐用户地址，amount认捐金额
    event Pledge(uint indexed id, address indexed caller,uint amount);
    //撤回认捐成功事件，id众筹id，caller认捐用户地址，amount认捐金额
    event Unpledge(uint indexed id, address indexed caller,uint amount);
    //提取金额成功事件，id众筹id
    event Claim(uint id);
    //失败退款成功事件
    event Refund(uint indexed id, address indexed caller,uint amount);

    //众筹活动结构体
    struct Campaign{
        //众筹创建者
        address creator;
        //资金目标
        uint goal;
        //目前筹集到的钱
        uint pledge;
        //开始时间
        uint32 startAt;
        //结束时间
        uint32 endAt;
        //筹集资金是否已经提款
        bool claimed;
    }
    //众筹支持IERC20的资金筹集的token
    IERC20 public immutable token;
    //筹集资金的轮次
    uint public count;
    //保存轮次对应众筹信息
    mapping (uint => Campaign) public campaigns;
    //每个轮次下的每个用户对应的认捐的资金
    mapping (uint => mapping(address => uint)) public pledgedAmount;

    constructor(address _token) {
        token = IERC20(_token);
    }

    //发起众筹
    //_goal资金目标，_startOffset开始时间偏移量，_endOffset结束时间偏移量
    function launch(uint _goal,uint32 _startOffset,uint32 _endOffset) external {
        //结束时间偏移量要大于开始时间偏移量
        require(_endOffset > _startOffset,"endAt < tartAt");
        //结束时间偏移量不能无限大
        require(_endOffset <= 30 days,"end > 30 days");
        
        //把当前时间加上开始时间偏移量作为开始时间
        uint _startAt = uint32(block.timestamp) + _startOffset;
        //把当前时间加上结束时间偏移量作为结束时间
        uint _endAt = uint32(block.timestamp) + _endOffset;
        //记录轮次
        count +=1;
        campaigns[count] = Campaign({
            creator: msg.sender,
            goal: _goal,
            pledge: 0,
            startAt: _startAt,
            endAt: _endAt,
            claimed: false
        });
        emit Launch(count,msg.sender,_goal,_startAt,_endAt);
    }


    //取消众筹
    //id为轮次，因为我们把轮次作为了众筹id
    function cancel(uint _id) external {
        //从集合中获取轮次对应的众筹信息，因为是只读变量，所以用memory更节省gas
        Campaign memory campaign = campaigns[_id];
        //取消众筹必须是众筹的创建者
        require(campaign.creator == msg.sender,"not creator");
        //只有当众筹活动还没开始时才可以取消
        require(block.timestamp < campaign.startAt,"started");

        //取消众筹只需把众筹信息删除即可，众筹信息都在campaigns中，所以删除campaigns对应轮次的众筹
        delete campaigns[_id];
        emit Cancel(_id);
    }

    //认捐资金
    function pledge(uint _id,uint _amount) external {
        //从集合中获取轮次对应的众筹信息，因为需要改写数据，所以用storage更节省gas
        Campaign storage campaign = campaigns[_id];
        //认捐时间必须大于众筹开始时间，小于众筹结束时间
        require(block.timestamp >= campaign.startAt,"timestamp < startAt");
        require(block.timestamp <= campaign.endAt,"timestamp > endAt");
        //记录筹集到的资金
        campaign.pledge += _amount;
        //记录用户认捐的资金记录到pledgedAmount
        pledgedAmount[_id][msg.sender] += _amount;
        //转账，由用户转到当前合约中，转之前记得approve（授权）以下
        token.transferFrom(msg.sender,address(this),_amount);
        //触发认捐事件
        emit Pledge(_id,msg.sender,_amount);
    }

    //撤回认捐资金，_id轮次id，_amount金额
    function unpledge(uint _id, uint _amount) external {
        Campaign storage campaign = campaigns[_id];
        //撤回资金要确保本轮众筹还未结束
        require(block.timestamp <= campaign.endAt,"ended");
        //减去筹集到的资金
        campaign.pledge -= _amount;
        //减去用户认捐的资金
        pledgedAmount[_id][msg.sender] -= _amount;
        token.transfer(msg.sender,_amount);
        emit Unpledge(_id,msg.sender,_amount);
    }

    //提取资金，众筹结束后，发起人取款
    function claim(uint _id)external {
        Campaign storage campaign = campaigns[_id];
        //提取者必须是发起者
        require(msg.sender == campaign.creator,"not creator");
        //提取时间必须大于众筹结束时间
        require(block.timestamp > campaign.endAt, "not ended");
        //认捐资金大于目标资金才能提款
        require(campaign.pledge >= campaign.goal,"pledge < goal");
        //确保认捐资金还未被提取
        require(!campaign.claimed,"claimed");
        //修改提取状态
        campaign.claimed = true;
        //开始转账
        token.transfer(msg.sender,campaign.pledge);
        emit Claim(_id);
    }

    //失败退款，认捐者来调用
    function refund(uint _id)external {
        Campaign storage campaign = campaigns[_id];
        //提取时间必须大于众筹结束时间
        require(block.timestamp > campaign.endAt, "not ended");
        //认捐资金大于目标资金才能提款
        require(campaign.pledge < campaign.goal,"pledge >= goal");

        //先减金额再转账，是为了防止重入攻击
        uint bal = pledgedAmount[_id][msg.sender];
        pledgedAmount[_id][msg.sender] = 0;
        token.transfer(msg.sender,bal);

        emit Refund(_id,msg.sender,bal);

    }
}