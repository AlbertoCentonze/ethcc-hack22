pragma solidity ^0.8.0;
// SPDX-License-Identifier: MIT

interface IVault {
    function stake(uint amount) external;
    function unstake() external;
    function harvest(address to) external;
}