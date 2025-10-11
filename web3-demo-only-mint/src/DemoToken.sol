// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DemoToken is ERC20, Ownable {
    constructor() ERC20("Demo Token", "DEMO") Ownable(msg.sender) {
        // 初期供給量として1000万トークンをデプロイヤーにミント
        _mint(msg.sender, 10_000_000 * 10 ** decimals());
    }

    // 誰でもトークンをミントできる関数（デモ用）
    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }

    // オーナーのみがトークンをミントできる関数
    function mintByOwner(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}

