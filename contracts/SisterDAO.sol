pragma solidity ^0.8.0;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IVault.sol";
import "hardhat/console.sol";

// TODO Ownable need to be set for a specific user in every contract
// TODO SafeERC20 needs to be used all accross the contracts
contract SisterDAO is Ownable {
    address[] public tokens;
    mapping(address => address) public tokenToVault;

    function addVault(address token, address vault) public onlyOwner {
        tokens.push(token);
        tokenToVault[token] = vault;
    }

    function removeVault(uint index) public onlyOwner {
        // TODO implement in a gas efficient way
    } 

    function sendAllTokenToVaults() public {
        for (uint i = 0; i < tokens.length; ++i) {
            sendTokenToVault(tokens[i]);
        }
    }

    function sendTokenToVault(address tokenAddress) public {
        IERC20 token = IERC20(tokenAddress);
        uint tokenBalance = token.balanceOf(address(this));
        if (tokenBalance > 0) {
            address vaultAddress = tokenToVault[tokenAddress];
            token.transfer(vaultAddress, tokenBalance);
            IVault(vaultAddress).stake(tokenBalance);
        }
    }
}
