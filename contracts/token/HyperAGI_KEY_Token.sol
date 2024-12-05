// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract HyperAGI_KEY_Token is Initializable, ERC1155Upgradeable, ERC1155BurnableUpgradeable, AccessControlUpgradeable, UUPSUpgradeable {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    mapping(uint256 => string) private _tokenURIs;

    mapping(uint256 => uint256) private _totalMinted;
    mapping(uint256 => uint256) private _maxMintAmount;

    mapping(address => bool) private _transferWhitelist;
    address private _designatedAddress;

    function setDesignatedAddress(address designatedAddress) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _designatedAddress = designatedAddress;
    }

    function addToWhitelist(address account) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _transferWhitelist[account] = true;
    }

    function removeFromWhitelist(address account) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _transferWhitelist[account] = false;
    }

    function isWhitelisted(address account) public view returns (bool) {
        return _transferWhitelist[account]; 
    }

    function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes memory data) public virtual override {
        require(_transferWhitelist[_msgSender()] || to == _designatedAddress, "HyperAGI_KEY_Token: transfer not allowed");
        super.safeTransferFrom(from, to, id, amount, data);
    }

    function safeBatchTransferFrom(address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) public virtual override {
        require(_transferWhitelist[_msgSender()] || to == _designatedAddress, "HyperAGI_KEY_Token: transfer not allowed");
        super.safeBatchTransferFrom(from, to, ids, amounts, data);
    }

    function setMaxMintAmount(uint256 tokenId, uint256 maxAmount) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _maxMintAmount[tokenId] = maxAmount;
    }

    function mint(address to, uint256 id, uint256 amount, string memory tokenURI, bytes memory data) public virtual {
        require(hasRole(MINTER_ROLE, _msgSender()), "HyperAGI_KEY_Token: must have minter role to mint");
        require(_totalMinted[id] + amount <= _maxMintAmount[id], "HyperAGI_KEY_Token: mint amount exceeds max limit");

        if (bytes(_tokenURIs[id]).length == 0) {
            _tokenURIs[id] = tokenURI;
        }
        _totalMinted[id] += amount;
        _mint(to, id, amount, data);
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, string[] memory tokenURIs, bytes memory data) public virtual {
        require(hasRole(MINTER_ROLE, _msgSender()), "HyperAGI_KEY_Token: must have minter role to mint");

        for (uint256 i = 0; i < ids.length; i++) {
            require(_totalMinted[ids[i]] + amounts[i] <= _maxMintAmount[ids[i]], "HyperAGI_KEY_Token: mint amount exceeds max limit");

            if (bytes(_tokenURIs[ids[i]]).length == 0) {
                _tokenURIs[ids[i]] = tokenURIs[i];
            }
            _totalMinted[ids[i]] += amounts[i];
        }

        _mintBatch(to, ids, amounts, data);
    }

    function initialize(address onlyOwner) public initializer {
        __ERC1155_init("");
        __ERC1155Burnable_init();
        __AccessControl_init();
        __UUPSUpgradeable_init();

        _grantRole(DEFAULT_ADMIN_ROLE, onlyOwner);
        _grantRole(MINTER_ROLE, onlyOwner);
    }

    function uri(uint256 tokenId) public view virtual override returns (string memory) {
        return _tokenURIs[tokenId];
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyRole(DEFAULT_ADMIN_ROLE) {}

    function supportsInterface(bytes4 interfaceId) public view override(ERC1155Upgradeable, AccessControlUpgradeable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function burn(address account, uint256 id, uint256 amount) public virtual override {
        require(_transferWhitelist[_msgSender()], "HyperAGI_KEY_Token: burn not allowed");
        require(account == _msgSender() || isApprovedForAll(account, _msgSender()), "HyperAGI_KEY_Token: caller is not owner nor approved");
        _burn(account, id, amount);
    }

    function burnBatch(address account, uint256[] memory ids, uint256[] memory amounts) public virtual override {
        require(_transferWhitelist[_msgSender()], "HyperAGI_KEY_Token: burn not allowed");
        require(account == _msgSender() || isApprovedForAll(account, _msgSender()), "HyperAGI_KEY_Token: caller is not owner nor approved");
        _burnBatch(account, ids, amounts);
    }
}
