// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./LiquidityPool.sol";

contract Dex {
    // Owner's address of DEX
    address public immutable owner;
    // Array of liquidity pool addresses
    address[] public liquidityPools;

    // Mapping to get address of liquidity pool with token addresses
    mapping(address => mapping(address => address)) public getLiquidityPool;

    // Event
    event LiquidityPoolCreted(
        address indexed _addressToken1,
        address indexed _addressToken2,
        address indexed _addressLiquidityPool
    );

    constructor() {
        owner = msg.sender;
    }

    function createLiquidityPool(address _tokenA, address _tokenB)
        external
        returns (address _liquidityPool)
    {
        (address _token1, address _token2) = _tokenA < _tokenB
            ? (_tokenA, _tokenB)
            : (_tokenB, _tokenA);

        require(_token1 != _token2, "Same Token Addresses");
        require(_token1 != address(0), "Invalid Token Address");
        require(_token2 != address(0), "Invalid Token Address");
        require(
            getLiquidityPool[_token1][_token2] == address(0),
            "Pool Already Exists"
        );

        // Create new liquidity pool
        _liquidityPool = address(new LiquidityPool(_token1, _token2));
        getLiquidityPool[_token1][_token2] = _liquidityPool;
        // Add new liquidity pool address to state array
        liquidityPools.push(_liquidityPool);

        emit LiquidityPoolCreted(_token1, _token2, _liquidityPool);
    }
}
