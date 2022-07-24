// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IgaugeController {
    function vote_for_gauge_weights(address _gaugeAddress, _user_weight: uint256) external;
    mapping(address => uint256) vote_user_power;
    function vote_user_power(address) external returns(uint256);
}