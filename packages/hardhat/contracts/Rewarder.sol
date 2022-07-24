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

    constructor() {
        minimumBlock = block.number;
    }

    function createIndex(address[] memory tokenList) external{
        indexBlocks.push(block.number);
        HolyPaladinToken pal = HolyPaladinToken(PALtoken);
        for(uint i = 0; i< tokenList.length; i++){
            IERC20 token = IERC20(tokenList[i]);
            uint256 balance = token.balanceOf(address(this));
            uint256 index = balance / pal.currentTotalLocked();
            indexList[tokenList[i]][block.number] = index;
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

    /*address[] public tokenList;
    mapping(address => address[]) tokenToVault;

    function deleteToken(address _address) external onlyOwner{
        for(uint i = 0; i<tokenList.length; i++){
            if (tokenList[i] == _address){
                tokenList[i] = tokenList[tokenList.length - 1];
                tokenList.pop();
            }
        }
    }

    function addToken(address tokenAddress, address vaultAddress) external onlyOwner{
        tokenList.push(tokenAddress);
        tokenToVault[tokenAddress].push(vaultAddress);
    }

    //TODO: restrict
    function claimSingle(address tokenAddress) external {
        
    }*/

}