// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Enum {
    enum OrderStatus {
        None,
        Pending,
        Shipped,
        Completed,
        Rejected,
        Cancelled
    }

    OrderStatus public status;

    struct Order{
        address addr;
        OrderStatus bo;
    } 

    Order[] public orders;
    Order public order;
    function getStatus()external view returns (OrderStatus) {
        return status;
    }

    function reset()external {
        delete status;
    }

    function updateBo()external {
        orders[0].bo=OrderStatus.Cancelled;
    }
    
    function setOrder()external {
        orders.push(Order(msg.sender,OrderStatus.Pending));
    }
}