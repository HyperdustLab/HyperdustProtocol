// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "@openzeppelin/contracts/utils/Strings.sol";

import "../HyperAGI_Roles_Cfg.sol";

import "./Agent_721.sol";
import "./Agent_1155.sol";

import "../utils/StrUtil.sol";
import "../HyperAGI_Roles_Cfg.sol";
import "../HyperAGI_Transaction_Cfg.sol";
import "../HyperAGI_Wallet_Account.sol";
import "../agent/HyperAGI_Agent.sol";

contract Agent_Mint is OwnableUpgradeable {
    address public _agentAddress;
    address public _walletAccountAddress;
    address public _transactionCfgAddress;
    address public _agentPOPNFTAddress;
    address public _rolesCfgAddress;

    using Strings for *;
    using StrUtil for *;

    function initialize(address onlyOwner) public initializer {
        __Ownable_init(onlyOwner);
    }

    function setAgentAddress(address agentAddress) public onlyOwner {
        _agentAddress = agentAddress;
    }

    function setWalletAccountAddress(address walletAccountAddress) public onlyOwner {
        _walletAccountAddress = walletAccountAddress;
    }

    function setTransactionCfgAddress(address transactionCfgAddress) public onlyOwner {
        _transactionCfgAddress = transactionCfgAddress;
    }

    function setAgentPOPNFTAddress(address agentPOPNFTAddress) public onlyOwner {
        _agentPOPNFTAddress = agentPOPNFTAddress;
    }

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    function setContractAddress(address[] memory contractaddressArray) public onlyOwner {
        _agentAddress = contractaddressArray[0];
        _walletAccountAddress = contractaddressArray[1];
        _transactionCfgAddress = contractaddressArray[2];
        _agentPOPNFTAddress = contractaddressArray[3];
        _rolesCfgAddress = contractaddressArray[4];
    }

    function mint721(bytes32 sid, string memory tokenURI) public payable {
        HyperAGI_Wallet_Account walletAccountAddress = HyperAGI_Wallet_Account(_walletAccountAddress);
        HyperAGI_Agent agentAddress = HyperAGI_Agent(_agentAddress);

        address _GasFeeCollectionWallet = walletAccountAddress._GasFeeCollectionWallet();

        require(_GasFeeCollectionWallet != address(0), "not set GasFeeCollectionWallet");

        (uint256 tokenId, , , , address erc721Address, , , ) = agentAddress.getAgent(sid);

        require(IERC721(_agentPOPNFTAddress).ownerOf(tokenId) == msg.sender, "not owner");

        uint256 gasFee = HyperAGI_Transaction_Cfg(_transactionCfgAddress).getGasFee("mintNFT");

        require(msg.value == gasFee, "not enough gas fee");

        if (gasFee > 0) {
            HyperAGI_Wallet_Account(_walletAccountAddress).addAmount(gasFee);
        }

        Agent_721(erc721Address).safeMint(msg.sender, tokenURI);
    }

    function mint1155(bytes32 sid, uint256 id, uint256 amount, string memory tokenURI) public payable {
        HyperAGI_Wallet_Account walletAccountAddress = HyperAGI_Wallet_Account(_walletAccountAddress);
        HyperAGI_Agent agentAddress = HyperAGI_Agent(_agentAddress);

        address _GasFeeCollectionWallet = walletAccountAddress._GasFeeCollectionWallet();

        require(_GasFeeCollectionWallet != address(0), "not set GasFeeCollectionWallet");

        (uint256 tokenId, , , , , address erc1155Address, , ) = agentAddress.getAgent(sid);

        require(IERC721(_agentPOPNFTAddress).ownerOf(tokenId) == msg.sender, "not owner");

        uint256 gasFee = HyperAGI_Transaction_Cfg(_transactionCfgAddress).getGasFee("mintNFT");

        require(msg.value == gasFee, "not enough gas fee");

        if (gasFee > 0) {
            HyperAGI_Wallet_Account(_walletAccountAddress).addAmount(gasFee);
        }

        Agent_1155(erc1155Address).mint(msg.sender, id, amount, tokenURI, "");
    }
}
