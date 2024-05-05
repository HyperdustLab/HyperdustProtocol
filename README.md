## Hyperdust Protocol

![image](https://github.com/HyperdustLab/HyperdustProtocol/blob/main/HYPERDUST.svg)

A decentralized platform to use and build LLM driven embodied Agent in 3D AI Gyms.

#### Hyperdust Protocol Smart Contracts

The smart contracts of the Hyperdust Protocol are the core of the Hyperdust Protocol platform, containing the main functionalities of the platform.

- `Hyperdust_AirDrop`: The airdrop contract of the Hyperdust Protocol, used for centralized bulk airdrops to users by the Hyperdust Protocol.
- `Hyperdust_Faucet.sol`: The faucet contract of the Hyperdust Protocol, from which users can obtain Hyperdust Tokens.

- `Hyperdust_Roles_Cfg.sol`: The role management contract of the Hyperdust Protocol, responsible for the determination of global administrator roles and the maintenance of administrator roles.

- `Hyperdust_Space.sol`: The space contract of the Hyperdust Protocol, responsible for managing all Hyperspaces and generating a SID for each Hyperspace.

- `Hyperdust_Transaction_Cfg.sol`: The transaction configuration contract of the Hyperdust Protocol, responsible for storing the HYPT Gas costs for different sections and configuring the minimum GAS charge authorization.

- `Hyperdust_Wallet_Account.sol`: The wallet account contract of the Hyperdust Protocol, responsible for holding Hyper gas fees on the L2 chain and generating detailed records.

- `Hyperdust_BaseReward_Release.sol`: The basic reward release contract for miners in the Hyperdust Protocol, responsible for releasing the basic reward tokens mined by miners according to a specified release cycle, through which miners collect released HYPT.

- `Hyperdust_Epoch_Awards.sol`: The mining contract of the Hyperdust Protocol, through which miners earn HYPT tokens by mining.

- `Hyperdust_Epoch_Transcition.sol`: The epoch transaction contract of the Hyperdust Protocol, through which users place orders under the epoch, using cloud computing power.

- `Hyperdust_Security_Deposit.sol`: The miner's security deposit contract of the Hyperdust Protocol, where 10% of the HYPT earned by miners from mining is stored as a quality guarantee deposit for miner services.

- `Hyperdust_GPUMining.sol`: The mining wallet contract of the Hyperdust Protocol, responsible for storing the monthly mining token funds.

- `Hyperdust_Token.sol`: The HYPT Token contract of the Hyperdust Protocol.

- `Hyperdust_VestingWallet.sol`: The wallet contract of the Hyperdust Protocol, responsible for the release of tokens for the Airdrop, PublicSale, PrivateSale, Seed, Advisor, Foundation, CoreTeam sections.

- `Hyperdust_Node_CheckIn.sol`: The wallet contract of the Hyperdust Protocol, responsible for the release of tokens for the Airdrop, PublicSale, PrivateSale, Seed, Advisor, Foundation, CoreTeam sections.

- `Hyperdust_Node_Mgr.sol`: The miner registration verification contract of the Hyperdust Protocol, responsible for the on-chain verification of miner registrations.

- `Hyperdust_Node_Type.sol`: The miner management contract of the Hyperdust Protocol, responsible for maintaining information, status, current online numbers, rendering numbers, and other maintenance tasks of miner nodes.

### Whitepaper:

https://github.com/HyperdustLab/HyperdustProtocol/blob/main/HyperdustChiangMaiRev3.pdf

### The details of token issurence and gas price update refer to

https://drive.google.com/file/d/1ZdAz1KLJFnsrNuGjJAM3kgKrAkztfQlI/view?usp=sharing
