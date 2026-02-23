// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

// Simple ERC20 token for testing
contract TestToken is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        _mint(msg.sender, 1_000_000 * 10**18);
    }
}

contract DeployTokens is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);
        
        // Deploy two test tokens
        TestToken tokenA = new TestToken("Test USD Coin", "tUSDC");
        TestToken tokenB = new TestToken("Test Wrapped ETH", "tWETH");
        
        vm.stopBroadcast();
        
        console.log("Test tokens deployed!");
        console.log("tUSDC:", address(tokenA));
        console.log("tWETH:", address(tokenB));
        console.log("");
        console.log("Add these to your .env file:");
        console.log("TOKEN_A=", address(tokenA));
        console.log("TOKEN_B=", address(tokenB));
    }
}
