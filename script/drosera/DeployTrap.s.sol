// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../../src/ByzantineWatchTrap.sol";

contract DeployTrap is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        // IMPORTANT: You need the actual Uniswap V3 Position Manager on Hoodi
        // This is a placeholder - YOU MUST UPDATE THIS!
        address POSITION_MANAGER = 0x084ac3B07a7aAbb216FD98df3E2Ee66d42EC99e9;
        
        vm.startBroadcast(deployerPrivateKey);
        
        ByzantineWatchTrap trap = new ByzantineWatchTrap(POSITION_MANAGER);
        
        vm.stopBroadcast();
        
        console.log("ByzantineWatchTrap deployed at:", address(trap));
        console.log("");
        console.log("Drosera-compliant trap ready!");
        console.log("Features:");
        console.log("- Implements ITrap (collect + shouldRespond)");
        console.log("- Monitors Uniswap V3 positions");
        console.log("- Multi-vector detection");
    }
}
