/** @format */
require('dotenv').config()
import { HardhatUserConfig } from 'hardhat/config'
import '@nomicfoundation/hardhat-toolbox'
import 'hardhat-gas-reporter'
import '@openzeppelin/hardhat-upgrades'
require('./tasks/extract-metadata')

const { ProxyAgent, setGlobalDispatcher } = require('undici')
const proxyAgent = new ProxyAgent('http://127.0.0.1:7890')
setGlobalDispatcher(proxyAgent)

const config: HardhatUserConfig = {
  solidity: {
    version: '0.8.20',
    settings: {
      metadata: {
        useLiteralContent: true,
      },
      optimizer: {
        enabled: true,
        runs: 2000,
        details: {
          yul: true,
          yulDetails: {
            stackAllocation: true,
            optimizerSteps: 'dhfoDgvulfnTUtnIf',
          },
        },
      },
      viaIR: true,
    },
  },
  networks: {
    dev: {
      url: 'HTTP://127.0.0.1:8545',
      loggingEnabled: true,
    },
    sepolia: {
      url: process.env.SEPOLIA_RPC_URL,
      loggingEnabled: true,
      accounts: [process.env.PRIVATE_KEY, process.env.PRIVATE_KEY1],
    },
    arbitrumSepolia: {
      url: process.env.Arbitrum_Sepolia_Testnet_RPC_URL,
      accounts: [process.env.PRIVATE_KEY, process.env.PRIVATE_KEY_PROD],
      loggingEnabled: true,
    },
    arbitrumMainnet: {
      url: process.env.Arbitrum_Mainnet_RPC_URL,
      accounts: [process.env.PRIVATE_KEY_PROD],
      loggingEnabled: true,
    },
    optimismSepolia: {
      url: process.env.Optimism_Sepolia_Testnet_RPC_URL,
      accounts: [process.env.PRIVATE_KEY, process.env.PRIVATE_KEY1],
      loggingEnabled: true,
    },
    bvmTest: {
      url: 'http://rpc-testnet.hyperagi.network',
      accounts: [process.env.PRIVATE_KEY, process.env.PRIVATE_KEY1],
      loggingEnabled: true,
    },
    nova: {
      url: 'https://nova.arbitrum.io/rpc',
      accounts: [process.env.PRIVATE_KEY_PROD],
      loggingEnabled: true,
    },
  },
  etherscan: {
    solidity: true,
    apiKey: {
      sepolia: process.env.ETHERSCAN_API_KEY,
      optimismSepolia: process.env.Optimism_Sepolia_KEY,
      arbitrumSepolia: process.env.Arbitrum_Sepolia_KEY,
      arbitrumMainnet: process.env.Arbitrum_Mainnet_KEY,
      bvmTest: '123',
    },
    customChains: [
      {
        network: 'arbitrumSepolia',
        chainId: 421614,
        urls: {
          apiURL: 'https://api-sepolia.arbiscan.io/api',
          browserURL: 'https://sepolia.arbiscan.io/',
        },
      },
      {
        network: 'arbitrumSepolia',
        chainId: 421614,
        urls: {
          apiURL: 'https://api-sepolia.arbiscan.io/api',
          browserURL: 'https://sepolia.arbiscan.io/',
        },
      },
      {
        network: 'arbitrumMainnet',
        chainId: 42161,
        urls: {
          apiURL: 'https://api.arbiscan.io/api',
          browserURL: 'https://arbiscan.io/',
        },
      },
      {
        network: 'optimismSepolia',
        chainId: 11155420,
        urls: {
          apiURL: 'https://api-sepolia-optimistic.etherscan.io/api',
          browserURL: 'https://sepolia-optimism.etherscan.io/',
        },
      },
      {
        network: 'bvmTest',
        chainId: 111111,
        urls: {
          apiURL: 'https://block-testnet.hyperagi.network/api',
          browserURL: 'https://block-testnet.hyperagi.network/',
        },
      },
    ],
    timeout: 60000,
  },
  sourcify: {
    enabled: false,
  },
  verify: {
    etherscan: {
      apiKey: '',
      apiTimeout: 60 * 1000, // 设置超时时间为300秒
    },
  },
}

export default config
