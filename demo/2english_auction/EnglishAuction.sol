// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

interface IERC721 {
    function transferFrom(
        address _from, 
        address _to, 
        uint256 _tokenId) external;
}
//英式拍卖
//拍卖时卖方首先公布物品底价作为初始当前价格，竞买人依次以高于当前价格应价，
//每次加价的幅度通常是预先设定好的，最高出价者在规定时间内无人加价后成交
contract EnglishAuction {
    //卖家发起拍卖完成事件
    event Start();
    //买家竞价完成事件 highestBidder最高竞价人，highestBid竞价价格
    event Bid(address indexed highestBidder,uint highestBid);
    //买家提款完成事件 bidder提款人 amount提款金额
    event Withdraw(address indexed bidder,uint amount);
    //拍卖结束完成事件, highestBidder最高竞价人，highestBid竞价价格
    event End(address highestBidder,uint highestBid);

    //NFT（商品） 相关信息
    IERC721 public immutable nft;
    uint public immutable nftId;


//拍卖信息
    //卖家
    address payable public immutable seller;
    //拍卖结束时间，开始时间就用当前时间
    uint32 public endAt;
    //拍卖是否开始
    bool public started;
    //拍卖是否结束
    bool public ended;

    //最高出价者的地址
    address public highestBidder;
    //最高出价的价格
    uint public highestBid;
    //所有出价人的价格map，后续需要把所有未成功拍卖下的出价人的以太币退还
    mapping (address => uint) public bids;



//初始化数据
    //_startingBid为起拍价格
    constructor(
        address _nft,
        uint _nftId,
        uint _startingBid){
        //初始化需要的值
        nft = IERC721(_nft);
        nftId = _nftId;
        //当前合约的拥有者作为卖家
        seller = payable(msg.sender);
        //最高出价者的价格为起拍价
        highestBid = _startingBid;

        }
        
//卖家发起拍卖
    function start() external  {
        //发起拍卖的人必须与初始化的卖家是一个人
        require(msg.sender == seller,"not seller");
        //保证拍卖还没未开始
        require(!started,"started");
        //拍卖开始
        started = true;
        //设置拍卖截止时间
        endAt = uint32(block.timestamp + 60);
        //把nft委托给合约，后续好进行拍卖
        nft.transferFrom(seller,address(this),nftId);
        //触发卖家发起拍卖完成事件
        emit Start();
    }




//买家竞价
    function bid()external payable  {
        //检查拍卖是否为开始状态
        require(started, "not started");
        //确保时间小于截止时间
        require(block.timestamp < endAt, "ended");
        //买家出价的数额要大于最高竞价，否则买家就是没有意义的竞价
        require(msg.value > highestBid, "value < highest Bid");
        
        //若以上条件都满足，则之前出价的人和价格就不是最高价格，需要把之前的出价人和价格放入bids，后续要做退还操作。
        if(highestBidder != address(0)){
            bids[highestBidder] += highestBid;
        }
        //把当前出价者和出价价格赋值给 最高出价者的地址highestBidder 最高出价的价格highestBid
        highestBidder = msg.sender;
        highestBid = msg.value;
        //触发买家竞价完成事件
        emit Bid(msg.sender,msg.value);
    }
//买家提款（买家出价的无效价格，需要退还给买家）
    function withdraw()external  {
        uint bal = bids[msg.sender];
        bids[msg.sender] = 0;
        payable (msg.sender).transfer(bal);
        //触发买家提款完成事件
        emit Withdraw(msg.sender,bal);
    }

//结束拍卖
    function end()external  {
        //确保拍卖已经开启了
        require(started,"not started");
        //确保拍卖未结束
        require(!ended,"not ended");
        //确保拍卖时间结束
        require(block.timestamp >= endAt,"not endAt");
        //拍卖状态设置未结束
        ended = true;
        //最高竞价者不能是无效地址
        if(highestBidder != address(0)){
            //把nft从本合约发给最高竞价者，
            nft.transferFrom(address(this), highestBidder, nftId);
        }else{
            //如果最高竞价者地址无效，则把nft从本合约发给卖家
            nft.transferFrom(address(this), seller, nftId);
        }
        emit End(highestBidder,highestBid);
    }

}