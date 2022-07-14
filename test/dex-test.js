const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Dex", function () {
  const USDC_ADDRESS = "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48";
  const WETH_ADDRESS = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2";

  let Dex;
  let dex;
  let deployer;
  let bob;
  let alice;

  beforeEach(async function () {
    [deployer, bob, alice] = await ethers.getSigners();
    Dex = await ethers.getContractFactory("Dex");
    dex = await Dex.deploy();
    await dex.deployed();
  });

  it("Owner should be deployer", async function () {
    const ownerAddress = await dex.owner();
    expect(ownerAddress).to.equal(deployer.address);
  });

  it("Should successfully create new liquidity pool", async function () {
    await dex.createLiquidityPool(USDC_ADDRESS, WETH_ADDRESS);

    await expect(
      dex.createLiquidityPool(WETH_ADDRESS, USDC_ADDRESS)
    ).to.be.revertedWith("Pool Already Exists");
  });
});
