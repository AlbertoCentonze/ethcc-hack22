// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IgaugeController {
    function vote_for_gauge_weights(address _gaugeAddress, uint256 _user_weight) external;
    function vote_user_power(address) external returns(uint256);
}