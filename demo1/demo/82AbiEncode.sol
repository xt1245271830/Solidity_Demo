// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title IERC20
 * @dev ERC20代币标准接口（简化版）
 */
interface IERC20 {
    
    function transfer(address, uint256) external;
}

/**
 * @title Token
 * @dev 一个简单的代币合约，用于演示
 */
contract Token {
    function transfer(address, uint256) external {}
}

/**
 * @title AbiEncode
 * @dev 演示三种不同的ABI编码方式
 */
contract AbiEncode {
    /**
     * @dev 执行任意调用数据
     * @param _contract 目标合约地址
     * @param data 编码后的调用数据
     */
    function test(address _contract, bytes calldata data) external {
        (bool ok, ) = _contract.call(data);
        require(ok, "call failed");
    }

    /**
     * @dev 使用encodeWithSignature编码transfer调用
     * @param to 接收地址
     * @param amount 转账金额
     * @return 编码后的调用数据
     */
    function encodeWithSignature(
        address to,
        uint256 amount
    ) external pure returns (bytes memory) {
        return abi.encodeWithSignature("transfer(address,uint256)", to, amount);
    }

    /**
     * @dev 使用encodeWithSelector编码transfer调用
     * @param to 接收地址
     * @param amount 转账金额
     * @return 编码后的调用数据
     */
    function encodeWithSelector(
        address to,
        uint256 amount
    ) external pure returns (bytes memory) {
        return abi.encodeWithSelector(IERC20.transfer.selector, to, amount);
    }

    /**
     * @dev 使用encodeCall编码transfer调用（推荐方式）
     * @param to 接收地址
     * @param amount 转账金额
     * @return 编码后的调用数据
     */
    function encodeCall(
        address to,
        uint256 amount
    ) external pure returns (bytes memory) {
        return abi.encodeCall(IERC20.transfer, (to, amount));
    }
}