pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@confluxfans/contracts/token/CRC1155/extensions/CRC1155Metadata.sol";

contract Hyperdust_1155 is
    ERC1155,
    ERC1155Burnable,
    AccessControl,
    ERC1155Supply,
    CRC1155Metadata
{
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    mapping(uint256 => string) private _tokenURIs;

    constructor(
        string memory name_,
        string memory symbol_
    ) CRC1155Metadata(name_, symbol_) ERC1155("") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
    }

    /**
     * @dev See {IERC1155MetadataURI-uri}.
     *
     * This implementation returns the same URI for *all* token types. It relies
     * on the token type ID substitution mechanism
     * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
     *
     * Clients calling this function must replace the `\{id\}` substring with the
     * actual token type ID.
     */
    function uri(
        uint256 tokenId
    )
        public
        view
        virtual
        override(ERC1155, IERC1155MetadataURI)
        returns (string memory)
    {
        return _tokenURIs[tokenId];
    }

    /**
     * @dev Creates `amount` new tokens for `to`, of token type `id`.
     *
     * See {ERC1155-_mint}.
     *
     * Requirements:
     *
     * - the caller must have the `MINTER_ROLE`.
     */
    function mint(
        address to,
        uint256 id,
        uint256 amount,
        string memory tokenURI,
        bytes calldata data
    ) public virtual {
        require(
            hasRole(MINTER_ROLE, _msgSender()),
            "CRC1155NatureAutoId: must have minter role to mint"
        );
        _tokenURIs[id] = tokenURI;

        _mint(to, id, amount, data);
    }

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] variant of {mint}.
     */
    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        string[] memory tokenURIs,
        bytes calldata data
    ) public virtual {
        require(
            hasRole(MINTER_ROLE, _msgSender()),
            "CRC1155NatureAutoId: must have minter role to mint"
        );

        for (uint256 i = 0; i < tokenURIs.length; i++) {
            _tokenURIs[ids[i]] = tokenURIs[i];
        }

        _mintBatch(to, ids, amounts, "");
    }

    function _update(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory values
    ) internal override(ERC1155, ERC1155Supply) {
        super._update(from, to, ids, values);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC1155, AccessControl, IERC165) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function _setTokenURI(uint256 tokenId, string memory tokenURI) private {
        string memory tokenURI = _tokenURIs[tokenId];

        if (bytes(tokenURI).length == 0) {
            _tokenURIs[tokenId] = tokenURI;
        }
    }
}
