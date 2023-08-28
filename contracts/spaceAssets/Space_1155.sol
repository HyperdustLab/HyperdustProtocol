pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "@confluxfans/contracts/token/CRC1155/extensions/CRC1155Enumerable.sol";
import "@confluxfans/contracts/token/CRC1155/extensions/CRC1155Metadata.sol";
import "@confluxfans/contracts/InternalContracts/InternalContractsHandler.sol";

contract Space_1155 is
    AccessControlEnumerable,
    CRC1155Enumerable,
    CRC1155Metadata,
    InternalContractsHandler
{
    using Strings for uint256;

    //tokenId => FeatureCode, the Feature code is generally md5 code for resource files such as images or videos.
    mapping(uint256 => uint256) public tokenFeatureCode;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant URI_SETTER_ROLE = keccak256("URI_SETTER_ROLE");
    //tokenID对应的元数据URL地址
    mapping(uint256 => string) private _tokenURIs;
    //tokenId对应的mint总数
    mapping(uint256 => uint256) private _mintNums;

    constructor(
    ) CRC1155Metadata("Space_721", "Space") ERC1155("") {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(MINTER_ROLE, _msgSender());
        _setupRole(URI_SETTER_ROLE, _msgSender());
        _setupRole(PAUSER_ROLE, _msgSender());
    }

    /**
     * @dev Update the URI for all tokens.
     *
     * Requirements:
     *
     * - the caller must have the `DEFAULT_ADMIN_ROLE`.
     */
    function setURI(string memory newuri) public virtual {
        require(
            hasRole(URI_SETTER_ROLE, _msgSender()),
            "CRC1155NatureAutoId: must have admin role to set URI"
        );
        _setURI(newuri);
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

    //获取tokenId总共铸造数量
    function getMintNum(uint256 tokenId) public view virtual returns (uint256) {
        return _mintNums[tokenId];
    }

    //设置tokenId对应的元数据URI
    function setTokenURI(uint256 tokenId, string memory newuri) public virtual {
        require(
            hasRole(URI_SETTER_ROLE, _msgSender()),
            "CRC1155NatureAutoId: must have admin role to set URI"
        );
        _tokenURIs[tokenId] = newuri;
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
        _mintNums[id] += amount;

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

    //Optional functions：The feature code can only be set once for each id, and then it can never be change again。
    function setTokenFeatureCode(
        uint256 tokenId,
        uint256 featureCode
    ) public virtual {
        require(
            hasRole(MINTER_ROLE, _msgSender()),
            "CRC721NatureAutoId: must have minter role to mint"
        );
        require(
            tokenFeatureCode[tokenId] == 0,
            "CRC721NatureAutoId: token Feature Code is already set up"
        );
        tokenFeatureCode[tokenId] = featureCode;
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        virtual
        override(AccessControlEnumerable, CRC1155Enumerable, IERC165)
        returns (bool)
    {
        return
            AccessControlEnumerable.supportsInterface(interfaceId) ||
            CRC1155Enumerable.supportsInterface(interfaceId);
    }

    function burn(address account, uint256 id, uint256 value) public virtual {
        require(
            account == _msgSender() || isApprovedForAll(account, _msgSender()),
            "ERC1155: caller is not token owner nor approved"
        );

        _burn(account, id, value);
    }

    function burnBatch(
        address account,
        uint256[] memory ids,
        uint256[] memory values
    ) public virtual {
        require(
            account == _msgSender() || isApprovedForAll(account, _msgSender()),
            "ERC1155: caller is not token owner nor approved"
        );

        _burnBatch(account, ids, values);
    }
}
