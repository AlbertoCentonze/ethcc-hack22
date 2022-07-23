pragma solidity ^0.8.0;
//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

//TODO safeERC20

contract VaultAave is Ownable {
    address private constant AaveTokenAddress =
        0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9; //TODO hardcoded address

    constructor() {}

    function stake(uint amount) public onlyOwner {
        _stakeAave();
        _depositStkAave();
        _stakePalStkAave();
    }

    function _stakeAave() private {}

    function _depositStkAave() private {}

    function _stakePalStkAave() private {}

    function rescue(uint amount) public onlyOwner {
        _unstakeAave();
        _withdrawStkAave();
        _unstakePalStkAave();
    }

    function _unstakeAave() private {}

    function _withdrawStkAave() private {}

    function _unstakePalStkAave() private {}

    function harvest() public {
			_harvestAutocompounder();
			_harvestPalRewards();
		}

		function _harvestAutocompounder() private {}

		function _harvestPalRewards() private {}
}
