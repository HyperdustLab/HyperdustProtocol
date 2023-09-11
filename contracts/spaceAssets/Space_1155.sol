pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "@confluxfans/contracts/token/CRC1155/extensions/CRC1155Enumerable.sol";
import "@confluxfans/contracts/token/CRC1155/extensions/CRC1155Metadata.sol";
import "@confluxfans/contracts/InternalContracts/InternalContractsHandler.sol";
import "../utils/StrUtil.sol";

abstract contract ITransactionCfg {
    function get(string memory func) public view returns (uint256) {}
}

abstract contract IWalletAccount {
    function addAmount(uint256 amount) public {}
}

abstract contract ISpaceAssetsCfg {
    function getAddressConfList()
        public
        view
        returns (
            address _transactionCfgAddress,
            address _erc20Address,
            address _walletAccountAddres,
            address _rolesCfgAddress
        )
    {}
}

abstract contract IERC20 {
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public returns (bool) {}

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256) {}

    function balanceOf(address account) external view returns (uint256) {}

    function approve(address spender, uint256 amount) external returns (bool) {}
}

contract Space_1155 is
    AccessControlEnumerable,
    CRC1155Enumerable,
    CRC1155Metadata,
    InternalContractsHandler
{
    using Strings for uint256;

    using StrUtil for *;

    address public _spaceAssetsCfgAddress;

    //tokenId => FeatureCode, the Feature code is generally md5 code for resource files such as images or videos.
    mapping(uint256 => uint256) public tokenFeatureCode;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant URI_SETTER_ROLE = keccak256("URI_SETTER_ROLE");

    mapping(uint256 => string) private _tokenURIs;

    constructor(
        address spaceAssetsCfgAddress
    ) CRC1155Metadata("Space_1155", "Space") ERC1155("") {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(MINTER_ROLE, _msgSender());
        _setupRole(URI_SETTER_ROLE, _msgSender());
        _setupRole(PAUSER_ROLE, _msgSender());
        _spaceAssetsCfgAddress = spaceAssetsCfgAddress;
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

        pay();

        if (_tokenURIs[id].toSlice().empty()) {
            _tokenURIs[id] = tokenURI;
        }

        _mint(to, id, amount, data);
    }

    function pay() private {
        (
            address _transactionCfgAddress,
            address _erc20Address,
            address _walletAccountAddres,
            address _rolesCfgAddress
        ) = ISpaceAssetsCfg(_spaceAssetsCfgAddress).getAddressConfList();

        ITransactionCfg transactionCfg = ITransactionCfg(
            _transactionCfgAddress
        );

        IERC20 erc20 = IERC20(_erc20Address);

        uint256 amount = erc20.allowance(msg.sender, address(this));

        uint256 mintNFTAmount = transactionCfg.get("mintNFT");

        require(amount >= mintNFTAmount, "Insufficient authorized amount");

        erc20.transferFrom(msg.sender, _walletAccountAddres, mintNFTAmount);

        IWalletAccount walletAccountAddress = IWalletAccount(
            _walletAccountAddres
        );

        walletAccountAddress.addAmount(mintNFTAmount);
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
