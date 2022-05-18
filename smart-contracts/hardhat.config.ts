import "@nomiclabs/hardhat-etherscan";
import "@nomiclabs/hardhat-waffle";
import "@typechain/hardhat";
import "hardhat-gas-reporter";
import "solidity-coverage";

import * as dotenv from "dotenv";

import { HardhatUserConfig, task } from "hardhat/config";

dotenv.config();

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

const undefinedParam = "Parameter not defined";
const accounts =
  process.env.ACCOUNT_PRIVATE_KEY !== undefined
    ? [process.env.ACCOUNT_PRIVATE_KEY]
    : [];

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.10",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
        details: {
          yul: true,
          yulDetails: {
            stackAllocation: true,
            optimizerSteps: "dhfoDgvulfnTUtnIf",
          },
        },
      },
    },
  },
  defaultNetwork: "localhost",
  networks: {
    localhost: {
      // hardhat
      chainId: 31337,
    },
    mumbai: {
      url: process.env.POLYGON_MUMBAI_URL || undefinedParam,
      accounts,
    },
  },
  gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    currency: "USD",
  },
  etherscan: {
    apiKey: {
      polygonMumbai:
        process.env.POLYGON_MUMBAI_ETHERSCAN_API_KEY || undefinedParam,
    },
  },
};

export default config;
