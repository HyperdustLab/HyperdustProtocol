// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@confluxfans/contracts/token/CRC1155/extensions/CRC1155Metadata.sol";

contract Agent_1155 is ERC1155, ERC1155Burnable, Ownable, ERC1155Supply, CRC1155Metadata {
    constructor(address initialAuthority, string memory name_, string memory symbol_) CRC1155Metadata(name_, symbol_) ERC1155("") Ownable(initialAuthority) {}

    mapping(uint256 => string) private _tokenURIs;

    function mint(address account, uint256 id, uint256 amount, string memory tokenURI, bytes memory data) public onlyOwner {
        _mint(account, id, amount, data);

        _setTokenURI(id, tokenURI);
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, string[] memory tokenURIs, bytes memory data) public onlyOwner {
        _mintBatch(to, ids, amounts, data);

        for (uint256 i = 0; i < tokenURIs.length; i++) {
            _setTokenURI(ids[i], tokenURIs[i]);
        }
    }

    function _update(address from, address to, uint256[] memory ids, uint256[] memory values) internal override(ERC1155, ERC1155Supply) {
        super._update(from, to, ids, values);
    }

    function _setTokenURI(uint256 tokenId, string memory tokenURI) private {
        string memory _tokenURI = _tokenURIs[tokenId];

        if (bytes(_tokenURI).length == 0) {
            _tokenURIs[tokenId] = tokenURI;
        }
    }

    function uri(uint256 tokenId) public view override(ERC1155, IERC1155MetadataURI) returns (string memory) {
        return _tokenURIs[tokenId];
    }
}
