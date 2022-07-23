// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

interface ILocker {
    //Lock the initial CRV
	function createLock(uint256, uint256) external;

    //Lock more CRV
	function increaseAmount(uint256) external;

    //Relock CRV
	function increaseUnlockTime(uint256) external;

	function release() external;

    //claim 3CRV
	function claimNativeRewards(address,address) external;

	function execute(
		address,
		uint256,
		bytes calldata
	) external returns (bool, bytes memory);
}