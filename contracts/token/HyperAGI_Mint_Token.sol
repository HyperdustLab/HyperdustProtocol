import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "@openzeppelin/contracts/utils/math/Math.sol";

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

import "../utils/StrUtil.sol";
import "./HyperAGI_721.sol";
import "./HyperAGI_1155.sol";
import "../HyperAGI_Roles_Cfg.sol";

contract HyperAGI_Mint_Token is OwnableUpgradeable, AccessControlUpgradeable {
    using Strings for *;
    using StrUtil for *;
    using Math for uint256;

    address public _rolesCfgAddress;
    mapping(address => bytes1) public _contractTypeMap;
    mapping(address => string) public _urlMap;

    event eveMint(uint256[], address[], uint256[], uint256[]);

    function initialize(address onlyOwner) public initializer {
        __Ownable_init(onlyOwner);
    }

    function addContract(address contractAddress, bytes1 contractType, string memory uri) public onlyOwner {
        _contractTypeMap[contractAddress] = contractType;
        _urlMap[contractAddress] = uri;
    }

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    function mint(uint256[] memory ids, address[] memory contractAddressArray, uint256[] memory tokenIds, uint256[] memory nums, address[] memory accountArray) public {
        require(HyperAGI_Roles_Cfg(_rolesCfgAddress).hasAdminRole(msg.sender), "not admin role");

        require(ids.length == contractAddressArray.length, "ids length not equal contractAddressArray length");
        require(ids.length == tokenIds.length, "ids length not equal tokenIds length");
        require(ids.length == nums.length, "ids length not equal nums length");
        uint256[] memory mintTokenIds = new uint256[](ids.length);

        for (uint256 i = 0; i < ids.length; i++) {
            bytes1 contractType = _contractTypeMap[contractAddressArray[i]];
            string memory uri = _urlMap[contractAddressArray[i]];

            if (contractType == 0x01) {
                uint256 tokenId = HyperAGI_721(contractAddressArray[i]).safeMint(accountArray[i], uri);
                mintTokenIds[i] = tokenId;
            } else if (contractType == 0x02) {
                require(tokenIds[i] > 0, "tokenIds must > 0");
                HyperAGI_1155(contractAddressArray[i]).mint(accountArray[i], tokenIds[i], nums[i], uri, "");

                mintTokenIds[i] = tokenIds[i];
            } else {
                revert("contract type error");
            }
        }
        emit eveMint(ids, contractAddressArray, mintTokenIds, nums);
    }
}
