// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./interfaces/ITrap.sol";
import "v3-periphery/contracts/interfaces/INonfungiblePositionManager.sol";
contract ByzantineWatchTrap is ITrap {
    INonfungiblePositionManager public immutable positionManager;
    
    struct WatchConfig {
        uint256 tokenId;
        uint256 maxTimeSinceLastHarvest;
        uint256 minLiquidity;
        uint256 priceThreshold;
        address owner;
    }
    
    WatchConfig[] public watchlist;
    
    event PositionAdded(uint256 indexed tokenId, address indexed owner);
    event PositionRemoved(uint256 indexed tokenId);
    
    constructor(address _positionManager) {
        positionManager = INonfungiblePositionManager(_positionManager);
    }
    
    function addPosition(
        uint256 _tokenId,
        uint256 _maxTimeSinceLastHarvest,
        uint256 _minLiquidity,
        uint256 _priceThreshold
    ) external {
        address owner = positionManager.ownerOf(_tokenId);
        require(owner == msg.sender, "Not position owner");
        
        watchlist.push(WatchConfig({
            tokenId: _tokenId,
            maxTimeSinceLastHarvest: _maxTimeSinceLastHarvest,
            minLiquidity: _minLiquidity,
            priceThreshold: _priceThreshold,
            owner: owner
        }));
        
        emit PositionAdded(_tokenId, owner);
    }
    
    function collect() external view override returns (bytes memory) {
        bytes[] memory positionData = new bytes[](watchlist.length);
        
        for (uint i = 0; i < watchlist.length; i++) {
            WatchConfig memory config = watchlist[i];
            
            (
                ,
                ,
                address token0,
                address token1,
                uint24 fee,
                int24 tickLower,
                int24 tickUpper,
                uint128 liquidity,
                ,
                ,
                uint128 tokensOwed0,
                uint128 tokensOwed1
            ) = positionManager.positions(config.tokenId);
            
            uint256 lastHarvest = 0;
            
            positionData[i] = abi.encode(
                config.tokenId,
                config.owner,
                token0,
                token1,
                fee,
                tickLower,
                tickUpper,
                liquidity,
                tokensOwed0,
                tokensOwed1,
                block.timestamp,
                lastHarvest,
                config.maxTimeSinceLastHarvest,
                config.minLiquidity,
                config.priceThreshold
            );
        }
        
        return abi.encode(positionData);
    }
    
    function shouldRespond(bytes[] calldata data) external pure override returns (bool) {
        for (uint i = 0; i < data.length; i++) {
            bytes memory batch = data[i];
            
            (
                uint256 tokenId,
                address owner,
                address token0,
                address token1,
                uint24 fee,
                int24 tickLower,
                int24 tickUpper,
                uint128 liquidity,
                uint128 tokensOwed0,
                uint128 tokensOwed1,
                uint256 currentTime,
                uint256 lastHarvest,
                uint256 maxTimeSinceLastHarvest,
                uint256 minLiquidity,
                uint256 priceThreshold
            ) = abi.decode(
                batch, 
                (
                    uint256, address, address, address, uint24,
                    int24, int24, uint128, uint128, uint128,
                    uint256, uint256, uint256, uint256, uint256
                )
            );
            
            bool timeTrigger = false;
            if (maxTimeSinceLastHarvest > 0 && currentTime > lastHarvest) {
                if (currentTime - lastHarvest > maxTimeSinceLastHarvest) {
                    timeTrigger = true;
                }
            }
            
            bool liquidityTrigger = false;
            if (minLiquidity > 0 && liquidity < minLiquidity) {
                liquidityTrigger = true;
            }
            
            bool feeTrigger = (tokensOwed0 > 0 || tokensOwed1 > 0);
            
            if (timeTrigger || liquidityTrigger || feeTrigger) {
                return true;
            }
        }
        
        return false;
    }
    
    function removePosition(uint256 index) external {
        require(index < watchlist.length, "Invalid index");
        require(watchlist[index].owner == msg.sender, "Not owner");
        
        emit PositionRemoved(watchlist[index].tokenId);
        
        watchlist[index] = watchlist[watchlist.length - 1];
        watchlist.pop();
    }
    
    function getWatchlist() external view returns (WatchConfig[] memory) {
        return watchlist;
    }
    
    function getWatchlistLength() external view returns (uint256) {
        return watchlist.length;
    }
}
