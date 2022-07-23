pragma solidity ^0.8.0;
//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IPalPool.sol";
import "./IStakedAave.sol";
import "./IPaladinController.sol";

//TODO safeERC20
contract VaultAave is Ownable {
    //TODO hardcoded addresses
    address private constant Aave = 0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9;
    address private constant StkAave = 0x4da27a545c0c5B758a6BA100e3a049001de870f5; // Todo: Same address as staking SC ??
	address private constant PalStkAave = 0x24E79e946dEa5482212c38aaB2D0782F04cdB0E0;
    address private constant AaveStakingContract = 0x4da27a545c0c5B758a6BA100e3a049001de870f5;
    address private constant PaladinPoolContract = 0xCDc3DD86C99b58749de0F697dfc1ABE4bE22216d;
	address private constant PaladinController = 0x241326339ced11EcC7CA07E4AA350234C57F53E5;

    error GenericError();

    constructor() {}

    function stake(uint amount) public onlyOwner {
        if (IERC20(Aave).balanceOf(address(this)) < amount) {
            revert GenericError();
        }
        _stakeAave(amount);
        uint palStkAaveAmount = _depositStkAave(amount);
        _stakePalStkAave(palStkAaveAmount);
    }

    function _stakeAave(uint amount) private {
        IERC20(Aave).approve(AaveStakingContract, amount);
		IStakedAave(AaveStakingContract).stake(address(this), amount);
    }

    function _depositStkAave(uint amount) private returns (uint palStkAaveAmount) {
		IERC20(StkAave).approve(PaladinPoolContract, amount);
		palStkAaveAmount = IPalPool(PaladinPoolContract).deposit(amount);
	}

    function _stakePalStkAave(uint amount) private {
		IERC20(PalStkAave).approve(PaladinController, amount);
        if (!IPaladinController(PaladinController).deposit(PalStkAave, amount)) {
            revert GenericError();
        }
	}

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
