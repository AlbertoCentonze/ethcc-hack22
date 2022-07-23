// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IVaultCRV.sol";

contract VaultCRV is IVaultCRV {
    function pause() external override {}

    function harvest() external override {} //TODO: verify the arguments

    function bribeSplitting(
        address[] memory _change,
        uint256[] memory _change_ca_aussi
    ) external override {}

    //TODO: function wardenBoost(?) external OnlyOwner;

    function delegateCall(address _change, bytes[] memory _change_as_well)
        external
        override
    {}

    //Lock the initial CRV
    function createLock(uint256, uint256) external override {}

    //Lock more CRV
    function increaseAmount(uint256) external override {}

    //Relock CRV
    function increaseUnlockTime(uint256) external override {}

    function release() external override {}

    //claim 3CRV
    function claimNativeRewards(address, address) external override {}

    function execute(
        address,
        uint256,
        bytes calldata
    ) external override returns (bool, bytes memory) {}
}
