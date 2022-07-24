// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IVaultCRV.sol";
import "./IgaugeController.sol";

contract VaultCRV is IVaultCRV {
    bool isPaused;
    address constant gaugeControllerAddress = 0x2F50D538606Fa9EDD2B11E2446BEb18C9D5846bB;
    

    modifier notPaused{
        require(!isPaused, "Contract is paused");
        _;
    }
    function pause() external override {
        isPaused = !isPaused;
    }

    function harvest() external notPaused override {} //TODO: verify the arguments

    function bribeSplitting(
        address[] memory gaugeList,
        uint256[] memory percentage
    ) external notPaused override {
        IgaugeController gaugeController = IgaugeController(gaugeControllerAddress);
        uint256 totalSelfVotingPower = gaugeController.vote_user_power()
        for(int i = 0; i<gaugeList.length; i++){
            gaugeController.vote_for_gauge_weights(gaugeList[i], )
        }
    }

    //TODO: function wardenBoost(?) external OnlyOwner;

    function delegateCall(address _change, bytes[] memory _change_as_well)
        external
    {}

    //Lock the initial CRV
    function createLock(uint256, uint256) external notPaused override {}

    //Lock more CRV
    function increaseAmount(uint256) external notPaused override {}

    //Relock CRV
    function increaseUnlockTime(uint256) external notPaused override {}

    function release() external override {}

    //claim 3CRV
    function claimNativeRewards(address, address) external notPaused override {}

    function execute(
        address,
        uint256,
        bytes calldata
    ) external override returns (bool, bytes memory) {}
}
