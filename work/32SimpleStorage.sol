// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract MessageStore {
    string public message;

    function setMessage(string calldata _tex) external {
        message=_tex;
    }

        function getMessage() external view returns (string memory txt){
        return message;
    }
}