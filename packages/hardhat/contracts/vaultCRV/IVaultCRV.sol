// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "openzeppelin/contracts/interfaces/IERC20.sol";
import "openzeppelin/contracts/access/Ownable.sol";
import "VoteEscrow.sol";

interface IVaultCRV is ILocker, Ownable {
    function pause() public OnlyOwner;

    function harvest() external;//TODO: verify the arguments

    function bribeSplitting(address[], uint256[]) external OnlyOwner;

    //TODO: function wardenBoost(?) external OnlyOwner;

    function delegateCall(address _address, bytes[] data) external OnlyOwner;
}
