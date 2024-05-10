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

import "./../token/Hyperdust_1155.sol";

contract Hyperdust_Miner_Service is OwnableUpgradeable {
    using Strings for *;
    using StrUtil for *;

    address public _HyperdustRolesCfgAddress;
    address public _erc20Address;
    address public _HyperdustMinerProductAddress;
    address public _creditedAccount;
    address public _HyperdustStorageAddress;
    address public _Hyperdust1155Address;
    uint256 public _tokenID;
    string public _tokenURI;
    uint256 public _scale;

    function initialize(address onlyOwner) public initializer {
        _tokenID = 1;

        _tokenURI = "https://ipfs.hyperdust.io/ipfs/QmSvQZ9i4NmcuujgsryEPWqU8Kc8gt9cYTYiDv5QYi6s82?suffix=json";

        _scale = 100;

        __Ownable_init(onlyOwner);
    }

    function setHyperdustRolesCfgAddress(address HyperdustRolesCfgAddress) public onlyOwner {
        _HyperdustRolesCfgAddress = HyperdustRolesCfgAddress;
    }

    function setHyperdustMinerProductAddress(address HyperdustMinerProductAddress) public onlyOwner {
        _HyperdustMinerProductAddress = HyperdustMinerProductAddress;
    }

    function setErc20Address(address erc20Address) public onlyOwner {
        _erc20Address = erc20Address;
    }

    function setCreditedAccount(address creditedAccount) public onlyOwner {
        _creditedAccount = creditedAccount;
    }

    function setHyperdust1155Address(address Hyperdust1155Address) public onlyOwner {
        _Hyperdust1155Address = Hyperdust1155Address;
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
        _Hyperdust1155Address = contractaddressArray[5];
    }

    function setHyperdustStorageAddress(address hyperdustStorageAddress) public onlyOwner {
        _HyperdustStorageAddress = hyperdustStorageAddress;
    }

    function setTokenId(uint256 tokenId) public onlyOwner {
        _tokenID = tokenId;
    }

    function setTokenURI(string memory tokenURI) public onlyOwner {
        _tokenURI = tokenURI;
    }

    event eveTransactionRecord(uint256 price, uint256 num, uint256 productId, address tokenAddress, uint256 tokenId, address account, uint256 payAmount, string tokenURI, uint256 invitationAmount, address invitationAddress);

    event eveInvitationCode(address account, bytes32 invitationCode);

    function stringToAddress(string memory str) public pure returns (address) {
        bytes32 tmp = keccak256(abi.encodePacked(str));
        return address(uint160(uint256(tmp)));
    }

    function buy(bytes32 invitationCode, uint256 productId, uint256 num) public {
        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(_HyperdustStorageAddress);

        Hyperdust_1155 erc1155 = Hyperdust_1155(_Hyperdust1155Address);

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

        string memory invitationAddress = hyperdustStorage.getBytes32String(invitationCode);

        uint256 invitationAmount;

        address _invitationAddress;

        if (bytes(invitationAddress).length != 0) {
            _invitationAddress = stringToAddress(invitationAddress);

            require(msg.sender != _invitationAddress, "You can't invite yourself");

            invitationAmount = (price * num * _scale) / 1000;

            erc20.transferFrom(msg.sender, _invitationAddress, invitationAmount);
        }

        uint256 amount = erc20.allowance(msg.sender, address(this));

        uint256 payAmount = price * num;

        require(amount >= payAmount, "Insufficient authorized amount");

        erc20.transferFrom(msg.sender, _creditedAccount, payAmount);

        erc1155.mint(msg.sender, _tokenID, num, _tokenURI, "0x");

        hyperdustStorage.setUint(accountLimitNumKey, accountLimitNum + num);

        bytes32 invitationCodeByte = hyperdustStorage.getBytes32(invitationCodeKey);

        if (invitationCodeByte == bytes32(0)) {
            invitationCodeByte = generateUniqueHash();

            hyperdustStorage.setBytes32(invitationCodeKey, invitationCodeByte);

            hyperdustStorage.setBytes32String(invitationCodeByte, msg.sender.toHexString());

            emit eveInvitationCode(msg.sender, invitationCodeByte);
        }

        emit eveTransactionRecord(price, num, productId, _Hyperdust1155Address, _tokenID, msg.sender, payAmount, _tokenURI, invitationAmount, _invitationAddress);
    }

    function generateUniqueHash() private view returns (bytes32) {
        return keccak256(abi.encodePacked(block.timestamp, block.difficulty));
    }
}
