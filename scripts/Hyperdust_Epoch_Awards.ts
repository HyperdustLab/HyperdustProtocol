/** @format */

import { ethers, run, upgrades } from 'hardhat'

async function main() {
  const contract = await ethers.getContractFactory('Hyperdust_Epoch_Awards')
  const instance = await upgrades.deployProxy(contract, [process.env.ADMIN_Wallet_Address])
  await instance.waitForDeployment()

  await (
    await instance.setContractAddress([
      '0x213b5E4FF6B805dC5C9AF66B0e1f84A035Fa80D5',
      '0x7a798E8eC045f911684dAa28B38a54b883b9523C',
      '0xb16B5c14425853cd36E6671D7240B290D3c1B039',
      '0xaea9e80F367363c4255A055cA11080DaA5BB840B',
      '0x74BD810D6C5978cdd35873ee64244F563b78Bc6e',
      '0x1a41f86248E33e5327B26092b898bDfe04C6d8b4',
    ])
  ).wait()

  const Hyperdust_Roles_Cfg = await ethers.getContractAt('Hyperdust_Roles_Cfg', '0x213b5E4FF6B805dC5C9AF66B0e1f84A035Fa80D5')

  await (await Hyperdust_Roles_Cfg.addAdmin(instance.target)).wait()

  console.info('contractFactory address:', instance.target)
}

// We recommend this pattern to be able to use async/await everywhere q
// and properly handle errors.
main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
