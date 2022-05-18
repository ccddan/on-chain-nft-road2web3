import { ethers } from "hardhat";
import { join } from "path";
import { writeFileSync } from "fs";

async function main() {
  const contractName = "ChainBattles";
  const ChainBattles = await ethers.getContractFactory(contractName);
  const chainBattles = await ChainBattles.deploy();

  await chainBattles.deployed();

  console.log(`${contractName} deployed to:`, chainBattles.address);

  const exportFile = join(
    __dirname,
    "..",
    "artifacts",
    "contracts",
    `${contractName}.sol`,
    `${contractName}.addr.json`
  );
  const exportFileTimestamp = exportFile.replace(
    ".addr.",
    `.addr-${new Date().toISOString()}.`
  );
  const fileData = JSON.stringify(
    { name: contractName, addr: chainBattles.address },
    null,
    2
  );
  writeFileSync(exportFile, fileData, { flag: "w" });
  writeFileSync(exportFileTimestamp, fileData);

  console.log(
    "Contract info exported at:\n\t",
    exportFile,
    "\n\t",
    exportFileTimestamp
  );
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
