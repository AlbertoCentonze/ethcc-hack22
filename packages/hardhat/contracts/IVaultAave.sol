pragma solidity ^0.8.0;
//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/libraries/SafeERC20.sol";

contract IVaultAave {

    using SafeERC20 for IERC20;

    private constant address AaveTokenAddress = 0x7fc66500c84a76ad7e9c93437bfc5ac33e2ddae9;

    private address owner;

    modifier OnlyOwner {
        require (msg.sender == owner);
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function stake(uint amount) OnlyOwner external {}

    function unstake(uint amount) external {}

}