import { ethers } from "hardhat"
const helpers = require("@nomicfoundation/hardhat-network-helpers")

async function main() {
  const VaultAave = await ethers.getContractFactory("VaultAave")
  const vault = await VaultAave.deploy()
  await vault.deployed()

	const binanceAddress = "0xF977814e90dA44bFA03b6295A0616a897441aceC"
	await helpers.impersonateAccount(binanceAddress)
  
	const binanceSigner = await ethers.getSigner(binanceAddress)

  

	// await (await (await VaultAave.connect(binanceSigner)).deploy()).debug();
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
