// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface IERC721 {
    function transferFrom(
        address _from, 
        address _to, 
        uint256 _tokenId) external;
}

//荷兰拍卖：荷兰拍卖（也称减价拍卖），是一种价格由高到低递减，直到有人应价便立即成交的拍卖方式。它的两个核心规则是 “递减定价” 和 “首个应价者成交” 
contract DutchAuction {
//NFT相关信息
    //immutable在构造函数中初始化
    IERC721 public immutable nft;
    //nft商品的id
    uint public immutable nftId;

//拍卖信息
    //拍卖时间，七天
    uint private constant DURATION = 7 days;
    //卖家,immutable在构造函数中初始化
    address public immutable seller;
    //价格
    uint public immutable startingPrice;
    //开始时间
    uint public immutable startAt;
    //截至时间
    uint public immutable expiresAt;
    //逐渐减小的步长
    uint public immutable discountRate;

//卖家出售NFT
    //简单起见，卖家出售写在构造函数中,参数为 价格、逐渐减小的步长、商品nft的地址、nft商品的id
    constructor(
        uint _startingPrice,
        uint _discountRate,
        address _nft,
        uint _nftId
    ){
        //卖家地址
        seller = payable(msg.sender); 
        //价格
        startingPrice = _startingPrice;
        discountRate = _discountRate;
        //把拍卖的开始时间设置为初始化当前构造函数的时间
        startAt =  block.timestamp;
        //截至时间就是当前时间+DURATION七天
        expiresAt = block.timestamp + DURATION;

        require(_startingPrice >= _discountRate * DURATION , "_startingPrice < DURATION");
        
        //初始化IERC721
        nft = IERC721(_nft);
        
        nftId = _nftId;
    }
    
    //买家购买NFT
    function buy()external payable {
        //先检查拍卖时间是否到期了
        require(block.timestamp < expiresAt , "Time expired");
        //开始购买操作,先获取当前时间的价格
        uint price = getPrice();
        //校验用户的出价，必须大于当前商品价格
        require(msg.value >= price, "ETH < price");

        //是 ERC-721 标准（NFT 标准）中定义的一个核心函数，用于 安全地将一个 NFT 从当前所有者转移给另一个地址
        nft.transferFrom(seller, msg.sender, nftId);
        //将出价的差价，退还给买家
        uint refund = msg.value - price;
        if(refund > 0){
        payable(msg.sender).transfer(msg.value - price);
        }
    }

    //获取当前时间的价格，价格是从开始时间算，每一个时间戳单位减一个discountRate
    function getPrice() public view returns (uint price){
        //获取从开始时间计算，已经过去的时间
        uint timeElapsed = block.timestamp - startAt;
        //计算需要减少的金额
        uint discount = timeElapsed * discountRate;

        uint price = startingPrice - discount;
    }
}