// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "v3-core/contracts/interfaces/IUniswapV3Factory.sol";
import "v3-periphery/contracts/interfaces/INonfungiblePositionManager.sol";
import "v3-core/contracts/interfaces/IUniswapV3Pool.sol";

interface IERC20 {
    function approve(address spender, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
}

contract CreatePool is Script {
    address constant UNISWAP_FACTORY = 0x3d0F464e34fE27A2dB0a0D923E9527E3bE2Fc32d;
    address constant POSITION_MANAGER = 0x084ac3B07a7aAbb216FD98df3E2Ee66d42EC99e9;
    
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address tokenA = vm.envAddress("TOKEN_A");
        address tokenB = vm.envAddress("TOKEN_B");
        
        // Your wallet address
        address wallet = 0x0eFF4B84eeAD02D66914950609bB54ac87ae7Db0;
        
        console.log("Starting pool creation...");
        console.log("Token A (tUSDC):", tokenA);
        console.log("Token B (tWETH):", tokenB);
        console.log("");
        
        vm.startBroadcast(deployerPrivateKey);
        
        // 1. Create pool with 0.3% fee
        IUniswapV3Factory factory = IUniswapV3Factory(UNISWAP_FACTORY);
        address pool = factory.createPool(tokenA, tokenB, 3000);
        console.log("Pool created at:", pool);
        
        // 2. Initialize pool with initial price (1:1 ratio)
        uint160 sqrtPriceX96 = 79228162514264337593543950336;
        IUniswapV3Pool(pool).initialize(sqrtPriceX96);
        console.log("Pool initialized with 1:1 price ratio");
        
        // 3. Check token balances
        uint256 balanceA = IERC20(tokenA).balanceOf(wallet);
        uint256 balanceB = IERC20(tokenB).balanceOf(wallet);
        console.log("Your token balances:");
        console.log("   tUSDC:", balanceA / 1e18, "tokens");
        console.log("   tWETH:", balanceB / 1e18, "tokens");
        
        // 4. Approve tokens for position manager (using smaller amount for safety)
        uint256 amountToApprove = 100_000 * 10**18;
        IERC20(tokenA).approve(POSITION_MANAGER, amountToApprove);
        IERC20(tokenB).approve(POSITION_MANAGER, amountToApprove);
        console.log("Tokens approved for Position Manager");
        
        // 5. Mint a position with smaller amount (1000 tokens)
        INonfungiblePositionManager positionManager = INonfungiblePositionManager(POSITION_MANAGER);
        
        // Make sure token order is correct (token0 < token1)
        // tWETH (0xe4...) is smaller than tUSDC (0xF1...), so token0 = tWETH, token1 = tUSDC
        address token0 = tokenB; // tWETH
        address token1 = tokenA; // tUSDC
        
        uint256 amount0Desired = 1_000 * 10**18; // 1000 tWETH
        uint256 amount1Desired = 1_000 * 10**18; // 1000 tUSDC
        
        console.log("Minting position with:");
        console.log("   token0 (tWETH):", token0);
        console.log("   token1 (tUSDC):", token1);
        console.log("   amount0Desired:", amount0Desired / 1e18, "tWETH");
        console.log("   amount1Desired:", amount1Desired / 1e18, "tUSDC");
        
        INonfungiblePositionManager.MintParams memory params = INonfungiblePositionManager.MintParams({
            token0: token0,
            token1: token1,
            fee: 3000,
            tickLower: -887220,
            tickUpper: 887220,
            amount0Desired: amount0Desired,
            amount1Desired: amount1Desired,
            amount0Min: 0,
            amount1Min: 0,
            recipient: wallet,
            deadline: block.timestamp + 3600
        });
        
        (uint256 tokenId, uint128 liquidity, uint256 amount0, uint256 amount1) = positionManager.mint(params);
        
        console.log("LP Position minted successfully!");
        console.log("   Token ID:", tokenId);
        console.log("   Liquidity:", liquidity);
        console.log("   Amount0 deposited:", amount0 / 1e18, "tWETH");
        console.log("   Amount1 deposited:", amount1 / 1e18, "tUSDC");
        
        vm.stopBroadcast();
        
        console.log("");
        console.log("==========================================");
        console.log("SUCCESS! Your LP position is ready!");
        console.log("Token ID:", tokenId);
        console.log("");
        console.log("Add this to your trap with:");
        console.log("cast send 0x3b963bccdB7152b35f0b7abE7113E6D5a87cAe81 \\");
        console.log('  "addPosition(uint256,uint256,uint256,uint256)" \\');
        console.log("  ", tokenId, "86400 1000000 1000 \\");
        console.log("  --rpc-url $HOODI_RPC_URL --private-key $PRIVATE_KEY");
    }
}
