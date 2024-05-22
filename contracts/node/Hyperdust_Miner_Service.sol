// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;
import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "../Hyperdust_Roles_Cfg.sol";

import "../utils/StrUtil.sol";

import "./../Hyperdust_Storage.sol";
import "./Hyperdust_Miner_Product.sol";

import "./../token/Hyperdust_721.sol";

contract Hyperdust_Miner_Service is OwnableUpgradeable {
    using Strings for *;
    using StrUtil for *;

    address public _HyperdustRolesCfgAddress;
    address public _erc20Address;
    address public _HyperdustMinerProductAddress;
    address public _creditedAccount;
    address public _HyperdustStorageAddress;
    address public _Hyperdust721Address;
    string public _tokenURI;
    uint256 public _scale;

    function initialize(address onlyOwner) public initializer {
        _tokenURI = "https://ipfs.hyperdust.io/ipfs/QmSvQZ9i4NmcuujgsryEPWqU8Kc8gt9cYTYiDv5QYi6s82?suffix=json";

        _scale = 100;

        __Ownable_init(onlyOwner);
    }

    function setHyperdustRolesCfgAddress(address hyperdustRolesCfgAddress) public onlyOwner {
        _HyperdustRolesCfgAddress = hyperdustRolesCfgAddress;
    }

    function setHyperdustMinerProductAddress(address hyperdustMinerProductAddress) public onlyOwner {
        _HyperdustMinerProductAddress = hyperdustMinerProductAddress;
    }

    function setErc20Address(address erc20Address) public onlyOwner {
        _erc20Address = erc20Address;
    }

    function setCreditedAccount(address creditedAccount) public onlyOwner {
        _creditedAccount = creditedAccount;
    }

    function setHyperdust721Address(address hyperdust721Address) public onlyOwner {
        _Hyperdust721Address = hyperdust721Address;
    }

    function setScale(uint256 scale) public onlyOwner {
        _scale = scale;
    }

    function setContractAddress(address[] memory contractaddressArray) public onlyOwner {
        _HyperdustRolesCfgAddress = contractaddressArray[0];
        _erc20Address = contractaddressArray[1];
        _HyperdustMinerProductAddress = contractaddressArray[2];
        _creditedAccount = contractaddressArray[3];
        _HyperdustStorageAddress = contractaddressArray[4];
        _Hyperdust721Address = contractaddressArray[5];
    }

    function setHyperdustStorageAddress(address hyperdustStorageAddress) public onlyOwner {
        _HyperdustStorageAddress = hyperdustStorageAddress;
    }

    function setTokenURI(string memory tokenURI) public onlyOwner {
        _tokenURI = tokenURI;
    }

    event eveTransactionRecord(uint256 price, uint256 num, uint256 productId, address tokenAddress, uint256[] tokenIds, address account, uint256 payAmount, string tokenURI, uint256 invitationAmount, address invitationAddress);

    event eveInvitationCode(address account, string invitationCode);

    function stringToAddress(string memory str) public pure returns (address) {
        bytes32 tmp = keccak256(abi.encodePacked(str));
        return address(uint160(uint256(tmp)));
    }

    function buy(string memory invitationCode, uint256 productId, uint256 num) public {
        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(_HyperdustStorageAddress);

        Hyperdust_721 erc721 = Hyperdust_721(_Hyperdust721Address);

        IERC20 erc20 = IERC20(_erc20Address);

        Hyperdust_Miner_Product hyperdust_Miner_Product = Hyperdust_Miner_Product(_HyperdustMinerProductAddress);

        (, uint256 price, uint256 limitNum, bytes1 status, , , ) = hyperdust_Miner_Product.get(productId);

        require(status == bytes1(0x01), "Product not on sale");

        string memory accountLimitNumKey = string(abi.encodePacked(msg.sender.toHexString(), productId.toString(), "_accountLimitNum"));

        string memory invitationCodeKey = string(abi.encodePacked(msg.sender.toHexString(), "_invitationCode"));

        uint256 accountLimitNum = hyperdustStorage.getUint(accountLimitNumKey);

        require(limitNum >= accountLimitNum + num, "Your purchase has exceeded the limit");

        require(num > 0, "num must > 0");

        hyperdust_Miner_Product.addSellNum(productId, num);

        uint256 invitationAmount;
        address invitationAddress;

        hyperdustStorage.setUint(accountLimitNumKey, accountLimitNum + num);

        string memory genInvitationCode = hyperdustStorage.getString(invitationCodeKey);

        if (bytes(genInvitationCode).length == 0) {
            uint256 nextId = hyperdustStorage.getNextId();

            genInvitationCode = string(abi.encodePacked(block.timestamp.toString(), nextId.toString()));

            hyperdustStorage.setString(invitationCodeKey, genInvitationCode);

            hyperdustStorage.setAddress(genInvitationCode, msg.sender);

            emit eveInvitationCode(msg.sender, genInvitationCode);
        }

        if (bytes(invitationCode).length > 0) {
            invitationAddress = hyperdustStorage.getAddress(invitationCode);

            require(invitationAddress != address(0), "Invitation code does not exist");

            require(msg.sender != invitationAddress, "You can't invite yourself");

            invitationAmount = (price * num * _scale) / 1000;

            erc20.transferFrom(msg.sender, invitationAddress, invitationAmount);
        }

        uint256 amount = erc20.allowance(msg.sender, address(this));

        uint256 payAmount = price * num;

        require(amount >= payAmount, "Insufficient authorized amount");

        uint256[] memory _tokenID = new uint256[](num);

        for (uint256 i = 0; i < num; i++) {
            uint256 tokenID = erc721.safeMint(msg.sender, _tokenURI);
            _tokenID[i] = tokenID;
        }

        erc20.transferFrom(msg.sender, _creditedAccount, payAmount - invitationAmount);

        emit eveTransactionRecord(price, num, productId, _Hyperdust721Address, _tokenID, msg.sender, payAmount, _tokenURI, invitationAmount, invitationAddress);
    }
}
