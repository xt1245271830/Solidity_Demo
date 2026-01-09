// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract SimpleStorage {
    string public text;

    function setTex(string calldata _tex) external {
        text=_tex;
    }

        function getTex() external view returns (string memory txt){
        return text;
    }
}