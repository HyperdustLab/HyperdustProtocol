## Hyperdust Protocol

HYPERDUST是完全去中心化的大模型驱动AI智能体训练和应用平台（支持智能体训练，不含大模型训练），是去中心化的半AI半金融应用平台，具有GPU算力共识化，AI具身化资产化的特点，目前基于Hypergraph PoUW共识机制以及完全去中心化的比特币L2，将来还借助比特币L2 Stack升级为比特币AI专用L2

[![Alt text](https://ipfs.hyperdust.io/ipfs/QmSEoCq5kCJ2uMNMKKsWyibAc7HcrdYG1ssF4KJZQLJvmW?suffix=png)](https://youtu.be/8h12hFUe0dU)

![image](https://github.com/HyperdustLab/HyperdustProtocol/blob/main/HYPERDUST.svg)

### Whitepaper:

https://github.com/HyperdustLab/HyperdustProtocol/blob/main/HyperdustChiangMaiRev3.pdf

### The details of token issurence and gas price update refer to

https://drive.google.com/file/d/1ZdAz1KLJFnsrNuGjJAM3kgKrAkztfQlI/view?usp=sharing

A decentralized platform to use and build LLM driven embodied Agent in 3D AI Gyms.

### HYPERDUST白皮书

https://s3.hyperdust.io/HYPERDUST.pdf

#### Hyperdust Protocol Smart Contracts

The smart contracts of the Hyperdust Protocol are the core of the Hyperdust Protocol platform, containing the main functionalities of the platform.

- `Hyperdust_AirDrop`: The airdrop contract of the Hyperdust Protocol, used for centralized bulk airdrops to users by the Hyperdust Protocol.

- `Hyperdust_Faucet.sol`: The faucet contract of the Hyperdust Protocol, from which users can obtain Hyperdust Tokens.

- `Hyperdust_Roles_Cfg.sol`: The role management contract of the Hyperdust Protocol, responsible for the determination of global administrator roles and the maintenance of administrator roles.

- `Hyperdust_GYM_Space.sol`: The space contract of the Hyperdust Protocol, responsible for managing all Hyperspaces and generating a SID for each Hyperspace.

- `Hyperdust_Transaction_Cfg.sol`: The transaction configuration contract of the Hyperdust Protocol, responsible for storing the HYPT Gas costs for different sections and configuring the minimum GAS charge authorization.

- `Hyperdust_Wallet_Account.sol`: The wallet account contract of the Hyperdust Protocol, responsible for holding Hyper gas fees on the L2 chain and generating detailed records.

- `Hyperdust_BaseReward_Release.sol`: The basic reward release contract for miners in the Hyperdust Protocol, responsible for releasing the basic reward tokens mined by miners according to a specified release cycle, through which miners collect released HYPT.

- `Hyperdust_Epoch_Awards.sol`: The mining contract of the Hyperdust Protocol, through which miners earn HYPT tokens by mining.

- `Hyperdust_Epoch_Transaction.sol`: The Hyperdust protocol's epoch transaction contract, where users initiate transactions on the epoch through this contract, utilizing the Hyperdust network's computing resources.

- `Hyperdust_Security_Deposit.sol`: The miner's security deposit contract of the Hyperdust Protocol, where 10% of the HYPT earned by miners from mining is stored as a quality guarantee deposit for miner services.

- `Hyperdust_GPUMining.sol`: The mining wallet contract of the Hyperdust Protocol, responsible for storing the monthly mining token funds.

- `Hyperdust_Token.sol`: The HYPT Token contract of the Hyperdust Protocol.

- `Hyperdust_VestingWallet.sol`: The wallet contract of the Hyperdust Protocol, responsible for the release of tokens for the Airdrop, PublicSale, PrivateSale, Seed, Advisor, Foundation, CoreTeam sections.

- `Hyperdust_Node_CheckIn.sol`: The miner registration verification contract of the Hyperdust Protocol, responsible for the on-chain verification of miner registrations.

- `Hyperdust_Node_Mgr.sol`: The miner management contract of the Hyperdust Protocol, responsible for maintaining information, status, current online numbers, rendering numbers, and other maintenance tasks of miner nodes.

- `Hyperdust_Node_Type.sol`: Miner type management contract, responsible for maintaining miner node type information..
