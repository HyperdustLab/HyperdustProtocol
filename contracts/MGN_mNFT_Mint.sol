pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/utils/Counters.sol";

import "./utils/StrUtil.sol";

abstract contract IMGNRolesCfg {
    function hasAdminRole(address account) public view returns (bool) {}
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

abstract contract IERC721 {
    function safeMint(address to, string memory uri) public returns (uint256) {}

    function ownerOf(uint256 tokenId) public view virtual returns (address) {}
}

abstract contract IERC1155 {
    function mint(
        address to,
        uint256 id,
        uint256 amount,
        string memory tokenURI,
        bytes calldata data
    ) public virtual {}
}

contract MGN_mNFT_Mint is Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _id;

    using Strings for *;
    using StrUtil for *;

    address public _settlementAddress;
    address public _rolesCfgAddress;
    address public _erc20Address;

    struct MintInfo {
        uint256 id;
        string tokenURI;
        uint256 price;
        address contractAddress;
        uint256 tokenId;
        uint8 contractType;
        uint256 mintNum;
        uint256 allowNum;
    }

    event eveAdd(
        uint256 id,
        string tokenURI,
        uint256 price,
        address contractAddress,
        uint256 tokenId,
        uint8 contractType,
        uint256 allowNum
    );

    event eveUpdate(
        uint256 id,
        string tokenURI,
        uint256 price,
        address contractAddress,
        uint256 tokenId,
        uint8 contractType,
        uint256 allowNum
    );

    event eveMint(
        uint256 id,
        address account,
        uint256 mintNum,
        uint256 price,
        uint256 amount
    );

    event eveUpdateMintNum(uint256 id, uint256 mintNum);

    event eveDelete(uint256 id);

    MintInfo[] public _mintInfos;

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    function setErc20Address(address erc20Address) public onlyOwner {
        _erc20Address = erc20Address;
    }

    function setSettlementAddress(address settlementAddress) public onlyOwner {
        _settlementAddress = settlementAddress;
    }

    function addMintInfo(
        string memory tokenURI,
        uint256 price,
        address contractAddress,
        uint256 tokenId,
        uint8 contractType,
        uint256 allowNum
    ) public {
        require(
            IMGNRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );
        _id.increment();
        uint256 id = _id.current();
        _mintInfos.push(
            MintInfo(
                id,
                tokenURI,
                price,
                contractAddress,
                tokenId,
                contractType,
                0,
                allowNum
            )
        );

        emit eveAdd(
            id,
            tokenURI,
            price,
            contractAddress,
            tokenId,
            contractType,
            allowNum
        );
    }

    function updateNFT(
        uint256 id,
        string memory tokenURI,
        uint256 price,
        address contractAddress,
        uint256 tokenId,
        uint8 contractType,
        uint256 allowNum
    ) public {
        require(
            IMGNRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );
        for (uint256 i = 0; i < _mintInfos.length; i++) {
            if (_mintInfos[i].id == id) {
                _mintInfos[i].tokenURI = tokenURI;
                _mintInfos[i].price = price;
                _mintInfos[i].contractAddress = contractAddress;
                _mintInfos[i].tokenId = tokenId;
                _mintInfos[i].contractType = contractType;
                _mintInfos[i].allowNum = allowNum;

                emit eveUpdate(
                    id,
                    tokenURI,
                    price,
                    contractAddress,
                    tokenId,
                    contractType,
                    allowNum
                );

                return;
            }
        }

        revert("NFT does not exist");
    }

    function getMintInfo(uint256 id) public view returns (MintInfo memory) {
        for (uint256 i = 0; i < _mintInfos.length; i++) {
            if (_mintInfos[i].id == id) {
                return _mintInfos[i];
            }
        }
        revert("NFT does not exist");
    }

    function deleteMintInfo(uint256 id) public {
        require(
            IMGNRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );
        for (uint256 i = 0; i < _mintInfos.length; i++) {
            if (_mintInfos[i].id == id) {
                _mintInfos[i] = _mintInfos[_mintInfos.length - 1];
                _mintInfos.pop();
                emit eveDelete(id);
                return;
            }
        }

        revert("NFT does not exist");
    }

    function mint(uint256 id, uint256 num) public {
        IERC20 erc20 = IERC20(_erc20Address);

        MintInfo memory mintInfo = getMintInfo(id);

        uint256 amount = erc20.allowance(msg.sender, address(this));

        require(
            amount >= mintInfo.price * num,
            "Insufficient authorized amount"
        );

        require(
            mintInfo.allowNum >= mintInfo.mintNum + num,
            "Insufficient inventory"
        );

        erc20.transferFrom(
            msg.sender,
            _settlementAddress,
            mintInfo.price * num
        );

        if (mintInfo.contractType == 1) {
            for (uint i = 0; i < num; i++) {
                IERC721(mintInfo.contractAddress).safeMint(
                    msg.sender,
                    mintInfo.tokenURI
                );
            }
        } else if (mintInfo.contractType == 2) {
            IERC1155(mintInfo.contractAddress).mint(
                msg.sender,
                mintInfo.tokenId,
                num,
                mintInfo.tokenURI,
                ""
            );
        } else {
            revert("invalid contract type");
        }

        for (uint256 i = 0; i < _mintInfos.length; i++) {
            if (_mintInfos[i].id == id) {
                _mintInfos[i].mintNum += num;
                break;
            }
        }

        emit eveUpdateMintNum(id, mintInfo.mintNum + num);

        emit eveMint(id, msg.sender, num, mintInfo.price, amount);
    }
}
