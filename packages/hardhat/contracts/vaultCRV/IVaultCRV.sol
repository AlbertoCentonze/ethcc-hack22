// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./VoteEscrow.sol";
import "./ILocker.sol";

interface IVaultCRV is ILocker {
    function pause() external;

    function harvest() external;//TODO: verify the arguments

    function bribeSplitting(address[] memory, uint256[] memory) external;

    //TODO: function wardenBoost(?) external OnlyOwner;

    function delegateCall(address, bytes[] memory) external;
}
