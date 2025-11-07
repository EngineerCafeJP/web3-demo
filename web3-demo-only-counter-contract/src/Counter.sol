// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

/// @title Counter
/// @notice 学習用の最小限なカウンターコントラクト。
/// @dev Foundry でのテスト・デプロイ方法を学ぶことを目的としています。
contract Counter {
    /// @notice 現在のカウント値。`public` なので自動で getter が生成されます。
    uint256 public number;

    /// @notice 外部から任意の値にカウンターを設定する。
    /// @dev `forge test` 時のファズテストでも利用されます。
    /// @param newNumber 設定したい新しいカウント値
    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    /// @notice カウンターを 1 だけインクリメントする。
    /// @dev `number++` は `number = number + 1` と同じ意味です。
    function increment() public {
        number++;
    }
}
