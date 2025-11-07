// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Counter} from "../src/Counter.sol";

/// @title CounterScript
/// @notice Anvil などの RPC に対して Counter をデプロイする Foundry 用スクリプト。
/// @dev `forge script` から呼び出し、`vm.startBroadcast` / `vm.stopBroadcast` でトランザクション送信を制御します。
///      詳細なチュートリアル: https://getfoundry.sh/guides/scripting-with-solidity/
contract CounterScript is Script {
    /// @notice デプロイした Counter インスタンスを格納。
    Counter public counter;

    /// @notice 事前準備が必要な場合に利用します。今回は設定不要。
    function setUp() public {}

    /// @notice `forge script` 実行時に呼ばれるメインロジック。
    /// @dev `--broadcast` 付きで実行すると、ここで発行するトランザクションが実際に送信されます。
    function run() public {
        // ログを出力
        console.log("CounterScript run");

        // ブロードキャストを開始し、この後の操作をトランザクションとして送信
        vm.startBroadcast();

        // Counter を新規デプロイ
        counter = new Counter();

        // ブロードキャストを停止し、ログにデプロイ先アドレスを表示
        vm.stopBroadcast();
        console.log("Counter deployed at:", address(counter));
    }
}
