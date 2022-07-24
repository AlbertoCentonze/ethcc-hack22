import { ethers } from "hardhat"
const helpers = require("@nomicfoundation/hardhat-network-helpers")
import { abi, palControllerAbi, palPoolAbi } from "./external_abis"

async function main() {
  const VaultAave = await ethers.getContractFactory("VaultAave")
  const vault = await VaultAave.deploy()
  await vault.deployed()

  const binanceAddress = "0xF977814e90dA44bFA03b6295A0616a897441aceC"
  const initialStakeAmount = 1500000000
  await helpers.impersonateAccount(binanceAddress)

  const binanceSigner = await ethers.getSigner(binanceAddress)

	const aaveAddress = "0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9"
  const aave = await ethers.getContractAt(
    abi,
    aaveAddress,
    binanceSigner
  )
	console.log("Aave token loaded correctly from mainnet")

  const palPoolAddress = "0xCDc3DD86C99b58749de0F697dfc1ABE4bE22216d"
  const palPool = await ethers.getContractAt(
    palPoolAbi,
    palPoolAddress,
    binanceSigner
  )
	console.log("palPool loaded correctly from mainnet")

	const palControllerAddress = "0x241326339ced11EcC7CA07E4AA350234C57F53E5"
  const palController = await ethers.getContractAt(
    palControllerAbi,
    palControllerAddress,
    binanceSigner
  )
	console.log("palController loaded correctly from mainnet")

  aave.transfer(vault.address, initialStakeAmount)
	console.log(`transfered ${initialStakeAmount} aave to vault`)

  await vault.stake(initialStakeAmount)
	console.log("staking aave in vault")

  await palPool.deposit(10)

  // console.log("End Deposit")

  // await vault.harvest(vault.address)

  // await (await (await VaultAave.connect(binanceSigner)).deploy()).debug();
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
