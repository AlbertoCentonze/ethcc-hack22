pragma solidity ^0.8.0;
//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../paladin/IPalPool.sol";
import "../paladin/IPaladinController.sol";
import "../Aave/IStakedAave.sol";

import "hardhat/console.sol";

//TODO safeERC20
contract VaultAave is Ownable {
    //TODO hardcoded addresses
    address private constant Aave = 0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9;
    address private constant StkAave = 0x4da27a545c0c5B758a6BA100e3a049001de870f5; // Todo: Same address as staking SC ??
	address private constant PalStkAave = 0x24E79e946dEa5482212c38aaB2D0782F04cdB0E0;
    address private constant AaveStakingContract = 0x4da27a545c0c5B758a6BA100e3a049001de870f5;
    address private constant PaladinPoolContract = 0xCDc3DD86C99b58749de0F697dfc1ABE4bE22216d;
	address private constant PaladinController = 0x241326339ced11EcC7CA07E4AA350234C57F53E5;

    uint private lastExchangeRate = 0;
    uint private totalAmountStaked = 0;
    uint private totalInterestGenerated = 0;

    error GenericError();

    constructor() {}

    function debug() public {
        console.log(msg.sender);
    }

    function stake(uint amount) public onlyOwner {
        if (IERC20(Aave).balanceOf(address(this)) < amount) {
            revert GenericError();
        }

        _refreshInterestGenerated();

        _stakeAave(amount);
        
        uint palStkAaveAmount = _depositStkAave(amount);
        totalAmountStaked += palStkAaveAmount;

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
        _unstakeAave(amount);
        _withdrawStkAave(amount);
        _unstakePalStkAave(amount);
    }

    function _unstakeAave(uint amount) private {}

    function _withdrawStkAave(uint amount) private {}

    function _unstakePalStkAave(uint amount) private {}

    function harvest(address to) public {
        _harvestAutocompounder(to); // Receives the stkAave rewards
        _harvestPalRewards(to); // Receives the Pal rewards
    }

    function _harvestAutocompounder(address to) private {
        _refreshInterestGenerated();
        uint amountToWithdraw = totalInterestGenerated / IPalPool(PaladinPoolContract).exchangeRateCurrent();
        uint256 underlyingReceived = IPalPool(PaladinPoolContract).withdraw(amountToWithdraw);
        IERC20(StkAave).transfer(to, underlyingReceived);
    }

    function _harvestPalRewards(address to) private {

    }

    function _refreshInterestGenerated() private {
        uint deltaRate = IPalPool(PaladinPoolContract).exchangeRateCurrent() - lastExchangeRate;
        totalInterestGenerated += totalAmountStaked * deltaRate;
    }
}
