pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import "../utils/StrUtil.sol";
import "../HyperAGI_Roles_Cfg.sol";
import "../HyperAGI_Storage.sol";

import "@openzeppelin/contracts/utils/Strings.sol";

abstract contract IAgentFactory {
    function deploy(address account, string memory name, string memory symbol) public returns (address) {}
}

contract HyperAGI_Agent is OwnableUpgradeable {
    using Strings for *;
    using StrUtil for *;

    address public _agent721FactoryAddress;
    address public _agent1155FactoryAddress;
    address public _rolesCfgAddress;
    address public _storageAddress;
    address public _agentMintAddress;
    address public _agentPOPNFTAddress;

    uint256 public _erc721Version;
    uint256 public _erc1155Version;

    event eveSaveAgent(bytes32 sid);

    event eveErc721Version();
    event eveErc1155Version();

    function initialize(address onlyOwner) public initializer {
        __Ownable_init(onlyOwner);
    }

    function setAgent721FactoryAddress(address agent721FactoryAddress) public onlyOwner {
        _agent721FactoryAddress = agent721FactoryAddress;
    }

    function setAgent1155FactoryAddress(address agent1155FactoryAddress) public onlyOwner {
        _agent1155FactoryAddress = agent1155FactoryAddress;
    }

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    function setStorageAddress(address storageAddress) public onlyOwner {
        _storageAddress = storageAddress;
    }

    function setAgentMintAddress(address agentMintAddress) public onlyOwner {
        _agentMintAddress = agentMintAddress;
    }

    function setAgentPOPNFTAddress(address agentPOPNFTAddress) public onlyOwner {
        _agentPOPNFTAddress = agentPOPNFTAddress;
    }

    function setContractAddress(address[] memory contractaddressArray) public onlyOwner {
        _agent721FactoryAddress = contractaddressArray[0];
        _agent1155FactoryAddress = contractaddressArray[1];
        _rolesCfgAddress = contractaddressArray[2];
        _storageAddress = contractaddressArray[3];
        _agentMintAddress = contractaddressArray[4];
        _agentPOPNFTAddress = contractaddressArray[5];
    }

    function mint(uint256 tokenId, string memory avatar, string memory nickName, string memory personalization, string[] memory names, string[] memory symbols) public {
        require(IERC721(_agentPOPNFTAddress).ownerOf(tokenId) == msg.sender, "not owner");

        HyperAGI_Storage storageAddress = HyperAGI_Storage(_storageAddress);

        require(storageAddress.getUint(tokenId.toString()) == 0, "already minted");

        storageAddress.setUint(tokenId.toString(), 1);

        address island721Address = IAgentFactory(_agent721FactoryAddress).deploy(_agentMintAddress, names[0], symbols[0]);

        address island1155Address = IAgentFactory(_agent1155FactoryAddress).deploy(_agentMintAddress, names[1], symbols[1]);

        uint256 id = storageAddress.getNextId();

        bytes32 sid = generateUniqueHash(id);
        storageAddress.setBytes32Uint(sid, id);

        storageAddress.setUint(storageAddress.genKey("tokenId", id), tokenId);

        storageAddress.setString(storageAddress.genKey("avatar", id), avatar);

        storageAddress.setString(storageAddress.genKey("nickName", id), nickName);
        storageAddress.setString(storageAddress.genKey("personalization", id), personalization);

        storageAddress.setAddress(storageAddress.genKey("erc721Address", id), island721Address);

        storageAddress.setAddress(storageAddress.genKey("erc1155Address", id), island1155Address);

        storageAddress.setBytes32(storageAddress.genKey("sid", id), sid);

        storageAddress.setUint(storageAddress.genKey("erc721Version", id), _erc721Version);

        storageAddress.setUint(storageAddress.genKey("erc1155Version", id), _erc1155Version);

        emit eveSaveAgent(sid);
    }

    function updateErc721Address(bytes32 sid, string memory name, string memory symbol) public {
        HyperAGI_Storage storageAddress = HyperAGI_Storage(_storageAddress);

        uint256 id = storageAddress.getBytes32Uint(sid);

        require(id > 0, "not found");

        uint256 tokenId = storageAddress.getUint(storageAddress.genKey("tokenId", id));

        require(IERC721(_agentPOPNFTAddress).ownerOf(tokenId) == msg.sender, "not owner");

        address erc721Address = IAgentFactory(_agent721FactoryAddress).deploy(_agentMintAddress, name, symbol);

        storageAddress.setAddress(storageAddress.genKey("erc721Address", id), erc721Address);
        storageAddress.setUint(storageAddress.genKey("erc721Version", id), _erc721Version);

        emit eveSaveAgent(sid);
    }

    function updateErc1155Address(bytes32 sid, string memory name, string memory symbol) public {
        HyperAGI_Storage storageAddress = HyperAGI_Storage(_storageAddress);

        uint256 id = storageAddress.getBytes32Uint(sid);

        require(id > 0, "not found");

        uint256 tokenId = storageAddress.getUint(storageAddress.genKey("tokenId", id));

        require(IERC721(_agentPOPNFTAddress).ownerOf(tokenId) == msg.sender, "not owner");

        address erc1155Address = IAgentFactory(_agent1155FactoryAddress).deploy(_agentMintAddress, name, symbol);

        storageAddress.setAddress(storageAddress.genKey("erc1155Address", id), erc1155Address);

        storageAddress.setUint(storageAddress.genKey("erc1155Version", id), _erc1155Version);
        emit eveSaveAgent(sid);
    }

    function update(bytes32 sid, string memory avatar, string memory nickName, string memory personalization) public {
        HyperAGI_Storage storageAddress = HyperAGI_Storage(_storageAddress);

        uint256 id = storageAddress.getBytes32Uint(sid);

        require(id > 0, "not found");

        uint256 tokenId = storageAddress.getUint(storageAddress.genKey("tokenId", id));

        require(IERC721(_agentPOPNFTAddress).ownerOf(tokenId) == msg.sender, "not owner");

        storageAddress.setString(storageAddress.genKey("avatar", id), avatar);

        storageAddress.setString(storageAddress.genKey("nickName", id), nickName);
        storageAddress.setString(storageAddress.genKey("personalization", id), personalization);

        emit eveSaveAgent(sid);
    }

    function getAgent(bytes32 sid) public view returns (uint256, string memory, string memory, string memory, address, address, uint256, uint256) {
        HyperAGI_Storage storageAddress = HyperAGI_Storage(_storageAddress);

        uint256 id = storageAddress.getBytes32Uint(sid);

        require(id > 0, "not found");

        return (
            storageAddress.getUint(storageAddress.genKey("tokenId", id)),
            storageAddress.getString(storageAddress.genKey("avatar", id)),
            storageAddress.getString(storageAddress.genKey("nickName", id)),
            storageAddress.getString(storageAddress.genKey("personalization", id)),
            storageAddress.getAddress(storageAddress.genKey("erc721Address", id)),
            storageAddress.getAddress(storageAddress.genKey("erc1155Address", id)),
            storageAddress.getUint(storageAddress.genKey("erc721Version", id)),
            storageAddress.getUint(storageAddress.genKey("erc1155Version", id))
        );
    }

    function updateErc721Version(uint256 version) public {
        require(HyperAGI_Roles_Cfg(_rolesCfgAddress).hasAdminRole(msg.sender), "not admin role");
        _erc721Version = version;
        emit eveErc721Version();
    }

    function updateErc1155Version(uint256 version) public {
        require(HyperAGI_Roles_Cfg(_rolesCfgAddress).hasAdminRole(msg.sender), "not admin role");
        _erc1155Version = version;

        emit eveErc1155Version();
    }

    function getVersions() public view returns (uint256, uint256) {
        return (_erc721Version, _erc1155Version);
    }

    function generateUniqueHash(uint256 nextId) private view returns (bytes32) {
        return keccak256(abi.encodePacked(block.timestamp, block.difficulty, nextId));
    }
}
