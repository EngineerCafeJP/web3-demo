// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

/// @title Token
/// @notice 学習用の最小限なトークンコントラクト。
/// @dev Foundry でのテスト・デプロイ方法を学ぶことを目的としています。
contract Token {
    /// @notice トークンの名前。
    string public name = "Engineer Cafe Token";
    /// @notice トークンのシンボル。
    string public symbol = "ECT";
    /// @notice 総供給量。
    uint256 public totalSupply;
    /// @notice 各アドレスの残高を管理するマッピング。
    mapping(address => uint256) public balanceOf;
    
    /// @notice コントラクトデプロイ時に初期供給量をデプロイ元アドレスに割り当てます。
    constructor() {
        uint256 initialAmount = 1000;
        balanceOf[msg.sender] = initialAmount;
        totalSupply += initialAmount;
    }

    /// @notice トークンを別のアドレスに転送します。
    /// @param to 転送先のアドレス
    /// @param amount 転送するトークン量
    function transfer(address to, uint256 amount) public {
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
    }
}

