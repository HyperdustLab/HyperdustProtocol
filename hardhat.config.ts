/** @format */

import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
const { ProxyAgent, setGlobalDispatcher } = require("undici");
const proxyAgent = new ProxyAgent("http://127.0.0.1:10809");
setGlobalDispatcher(proxyAgent);

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.1",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
    dev: {
      url: "HTTP://127.0.0.1:7545",
    },
    test1: {
      url: "https://evmtestnet.confluxrpc.com",
      chainId: 71,
      loggingEnabled: true,
      gas: 10000000,
      accounts: ["144c29e35cb6d579fc739249eadd4c1d6ff3cbc8cc32798b32788bf615fedf74"],
    },
    sepolia: {
      url: "https://eth-sepolia.g.alchemy.com/v2/8Ia31q08r5SELcMy3EYU8ZUrDHh_iuoF",
      accounts: ["144c29e35cb6d579fc739249eadd4c1d6ff3cbc8cc32798b32788bf615fedf74"],
      loggingEnabled: true,
      gas: 10000000,
    },
  },
  etherscan: {
    apiKey: "I71WBCEDU9J5I2K7CGDSM9HXUKD2NSS4DZ",
  },
};

export default config;
