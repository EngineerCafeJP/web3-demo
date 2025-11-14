// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Token} from "../src/Token.sol";

/// @title TokenTest
/// @notice Foundry のテスト構文とアサーションの使い方を解説するテストスイート。
contract TokenTest is Test {
    /// @notice テスト対象の Token インスタンス。
    Token public token;
    /// @notice テスト用のアドレス。
    address public deployer;
    /// @notice テスト用の受信者アドレス。
    address public recipient;

    /// @notice 各テストの前に呼び出され、クリーンな状態を用意します。
    /// @dev Foundry の `setUp` は各テストごとに実行され、状態がリセットされます。
    function setUp() public {
        deployer = address(this);
        recipient = address(0x1);
        token = new Token();
    }

    /// @notice コントラクトデプロイ時の初期状態を確認するテスト。
    /// @dev デプロイ元アドレスに初期供給量が割り当てられていることを確認します。
    function test_InitialState() public view {
        // ログを出力
        console.log("test_InitialState");

        assertEq(token.name(), "Engineer Cafe Token");
        assertEq(token.symbol(), "ECT");
        assertEq(token.totalSupply(), 1000);
        assertEq(token.balanceOf(deployer), 1000);
    }

    /// @notice transfer 関数が正常に動作することを確認するテスト。
    /// @dev 送信者の残高が減り、受信者の残高が増えることを確認します。
    function test_Transfer() public {
        // ログを出力
        console.log("test_Transfer");

        uint256 transferAmount = 100;
        
        uint256 deployerBalanceBefore = token.balanceOf(deployer);
        uint256 recipientBalanceBefore = token.balanceOf(recipient);
        
        token.transfer(recipient, transferAmount);
        
        assertEq(token.balanceOf(deployer), deployerBalanceBefore - transferAmount);
        assertEq(token.balanceOf(recipient), recipientBalanceBefore + transferAmount);
    }

    /// @notice Fuzz テストで任意の転送量に対する transfer の挙動を検証します。
    /// @dev Foundry が自動生成するランダム値 `amount` を受け取り、残高が十分な場合に転送が成功することを確認します。
    function testFuzz_Transfer(uint256 amount) public {
        // ログを出力
        console.log("testFuzz_Transfer");
        
        // 初期残高を超えないように制限
        uint256 maxAmount = token.balanceOf(deployer);
        if (amount > maxAmount) {
            vm.expectRevert();
            token.transfer(recipient, amount);
        } else {
            uint256 deployerBalanceBefore = token.balanceOf(deployer);
            uint256 recipientBalanceBefore = token.balanceOf(recipient);
            
            token.transfer(recipient, amount);
            
            assertEq(token.balanceOf(deployer), deployerBalanceBefore - amount);
            assertEq(token.balanceOf(recipient), recipientBalanceBefore + amount);
        }
    }
}

