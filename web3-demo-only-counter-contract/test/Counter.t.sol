// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";

/// @title CounterTest
/// @notice Foundry のテスト構文とアサーションの使い方を解説するテストスイート。
contract CounterTest is Test {
    /// @notice テスト対象の Counter インスタンス。
    Counter public counter;

    /// @notice 各テストの前に呼び出され、クリーンな状態を用意します。
    /// @dev Foundry の `setUp` は各テストごとに実行され、状態がリセットされます。
    function setUp() public {
        counter = new Counter();
        counter.setNumber(0);
    }

    /// @notice increment 関数が 1 増分することを確認するユニットテスト。
    /// @dev `forge test -v` 以上で実行すると `console.log` の内容が表示されます。
    function test_Increment() public {
        // ログを出力
        console.log("test_Increment");

        // Counter をインクリメントし、期待値と照合
        counter.increment();
        assertEq(counter.number(), 1);
    }

    /// @notice Fuzz テストで任意の `uint256` 入力に対する setNumber の挙動を検証します。
    /// @dev Foundry が自動生成するランダム値 `x` を受け取り、そのままアサーションします。
    function testFuzz_SetNumber(uint256 x) public {
        // ログを出力
        console.log("testFuzz_SetNumber");
        // Foundry のファズテストでは成功ケースの console.log は抑制されるため、
        // `--fuzz-runs 1` で実行回数を減らしても標準ログには出力されません。
        // 確認したい場合は一時的にテストを失敗させるか、ユニットテストとして
        // 別メソッドに切り出す、または `forge test -vvvvvv` でトレースを参照してください。

        counter.setNumber(x);
        assertEq(counter.number(), x);
    }
}
