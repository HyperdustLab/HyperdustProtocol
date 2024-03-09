/** @format */

import { ethers } from 'hardhat';

describe('Hyperdust_HYDT_Price', () => {
  describe('sendRequest', () => {
    it('sendRequest', async () => {
      const accounts = await ethers.getSigners();

      const Hyperdust_20 = await ethers.getContractAt('Hyperdust_20', '0xfcb8A945DC86D72f906D9C63222Dc470b5A35548');

      const tx = await Hyperdust_20.balanceOf('0xc6c58BbB0d40ACE763b55D72CaA31A8A27dD9F5b');

      console.info(tx);
    });
  });
});
