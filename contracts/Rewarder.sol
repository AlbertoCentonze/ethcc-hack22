// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "./paladin/HolyPaladinToken.sol";


contract Rewarder is Ownable{
    mapping(address => mapping(address => uint256)) lastClaim;
    address constant PALtoken = 0x624D822934e87D3534E435b83ff5C19769Efd9f6; 
    mapping(address => mapping(uint256 => uint256)) indexList;//token address to (block to index)
    uint256[] indexBlocks;
    uint256 minimumBlock;
    uint256 lastBalance;

    constructor() {
        minimumBlock = block.number;
    }

    function createIndex(address[] memory tokenList) external{
        indexBlocks.push(block.number);
        HolyPaladinToken pal = HolyPaladinToken(PALtoken);
        for(uint i = 0; i< tokenList.length; i++){
            IERC20 token = IERC20(tokenList[i]);
            uint256 balanceDelta = token.balanceOf(address(this)) - lastBalance;
            uint256 index = balanceDelta / pal.currentTotalLocked();
            indexList[tokenList[i]][block.number] = index;
            lastBalance = token.balanceOf(address(this));
        }
        
    }

    function claim(address[] memory tokenList) external{
        //check at what block the user entered using "lastClaim"
        HolyPaladinToken pal = HolyPaladinToken(PALtoken);
        for (uint i = 0; i<tokenList.length; i++){
            uint256 balanceClaimable = 0;
            uint256 claimBlock = lastClaim[tokenList[i]][msg.sender];
            if (claimBlock < minimumBlock){
                claimBlock = minimumBlock;
            }
            for(uint j = 0; j< indexBlocks.length; j++){
                if (indexBlocks[j] > claimBlock){
                    uint256 index = indexList[tokenList[i]][indexBlocks[j]];
                    uint256 pastLock = pal.getUserPastLock(msg.sender, indexBlocks[j]).amount;
                    uint256 amount = pastLock * index;
                    balanceClaimable += amount;
                }
            }
            lastClaim[tokenList[i]][msg.sender] = block.number;
            IERC20(tokenList[i]).transfer(msg.sender, balanceClaimable);
        }      
    }
}