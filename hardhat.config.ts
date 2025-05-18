import * as envEnc from "@chainlink/env-enc";
import "@nomicfoundation/hardhat-toolbox-viem";
import type { HardhatUserConfig } from "hardhat/config";

envEnc.config();

const config: HardhatUserConfig = {
  solidity: "0.8.28",
  networks: {
    mantleSepolia: {
      url: process.env.RPC_PROVIDER,
      accounts: [process.env.PRIVATE_KEY ?? ""],
    },
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
    customChains: [
      {
        network: "mantleSepolia",
        chainId: 5003,
        urls: {
          apiURL: "https://api-sepolia.mantlescan.xyz/api",
          browserURL: "https://sepolia.mantlescan.xyz/",
        },
      },
    ],
  },
};

export default config;
