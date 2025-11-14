// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Token} from "../src/Token.sol";

/// @title TokenScript
/// @notice Anvil などの RPC に対して Token をデプロイする Foundry 用スクリプト。
/// @dev `forge script` から呼び出し、`vm.startBroadcast` / `vm.stopBroadcast` でトランザクション送信を制御します。
///      詳細なチュートリアル: https://getfoundry.sh/guides/scripting-with-solidity/
contract TokenScript is Script {
    /// @notice デプロイした Token インスタンスを格納。
    Token public token;

    /// @notice 事前準備が必要な場合に利用します。今回は設定不要。
    function setUp() public {}

    /// @notice `forge script` 実行時に呼ばれるメインロジック。
    /// @dev `--broadcast` 付きで実行すると、ここで発行するトランザクションが実際に送信されます。
    function run() public {
        // ログを出力
        console.log("TokenScript run");

        // ブロードキャストを開始し、この後の操作をトランザクションとして送信
        vm.startBroadcast();

        // Token を新規デプロイ
        token = new Token();

        // ブロードキャストを停止し、ログにデプロイ先アドレスを表示
        vm.stopBroadcast();
        console.log("Token deployed at:", address(token));
        console.log("Token name:", token.name());
        console.log("Token symbol:", token.symbol());
        console.log("Total supply:", token.totalSupply());
    }
}

