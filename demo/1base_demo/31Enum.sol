// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Enum {
    enum Status {
        a,
        b,
        c,
        d
    }

    Status public status;

    function getStatus()external view returns (Status) {
        return status;
    }

    function setStatus(Status _status) external {
        status = _status;
    }

    function setB()external {
        status=Status.b;
    }

    function reset()external {
        delete status;
    }
}