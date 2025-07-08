const hre = require("hardhat");

async function main() {
  const WarrantyNFT = await hre.ethers.getContractFactory("WarrantyNFT");
  const warrantyNFT = await WarrantyNFT.deploy();

  await warrantyNFT.deployed();

  console.log("WarrantyNFT deployed to:", warrantyNFT.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
