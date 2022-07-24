// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./VoteEscrow.sol";

interface IVaultCRV {
    //Lock the initial CRV
	function createLock(uint256, uint256) external;

    //Lock more CRV
	function increaseAmount(uint256) external;

    //Relock CRV
	function increaseUnlockTime(uint256) external;

	function release() external;

    //claim 3CRV
	function claimNativeRewards(address,address) external;

	

    function pause() external;

    //Claim the 
    function harvest() external;//TODO: verify the arguments

    //Give the bribe distribution to the contract and vote for the gauges
    function bribeSplitting(address[] memory, uint256[] memory) external;

    //TODO: function wardenBoost(?) external OnlyOwner;

    //Let the multisig execute any transaction on the contract
    function execute(
		address,
		uint256,
		bytes calldata
	) external returns (bool, bytes memory);
}
