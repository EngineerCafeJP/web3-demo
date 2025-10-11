// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/DemoToken.sol";

contract DeployDemoToken is Script {
    function run() external {
        // 環境変数から秘密鍵を読み込む
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);
        
        // DemoTokenをデプロイ
        DemoToken token = new DemoToken();
        
        console.log("DemoToken deployed at:", address(token));
        console.log("Deployer address:", msg.sender);
        console.log("Initial supply:", token.totalSupply());
        
        vm.stopBroadcast();
    }
}

