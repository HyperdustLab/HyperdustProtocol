pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/utils/Counters.sol";

import "./utils/StrUtil.sol";

abstract contract IRole {
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

contract MGN_Mint is Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _id;

    using Strings for *;
    using StrUtil for *;

    address public _settlementAddress;
    address public _roleAddress;
    address public _erc20Address;

    struct NFT {
        uint256 id; //铸造NFT商品ID
        string tokenURI; //tokenURI
        uint256 price; //铸造价格
        address contractAddress; //合约地址
        uint256 tokenId; //token ID
        uint8 contractType; //合约类型(1:721 2:1155)
        uint256 mintNum; //已铸造的梳理
        uint256 allowNum; //允许铸造的数量
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

    NFT[] public _nfts;

    function setSettlementAddress(address settlementAddress) public onlyOwner {
        _settlementAddress = settlementAddress;
    }

    function setRoleAddress(address roleAddress) public onlyOwner {
        _roleAddress = roleAddress;
    }

    function setErc20Address(address erc20Address) public onlyOwner {
        _erc20Address = erc20Address;
    }

    function addNFT(
        string memory tokenURI,
        uint256 price,
        address contractAddress,
        uint256 tokenId,
        uint8 contractType,
        uint256 allowNum
    ) public {
        require(
            IRole(_roleAddress).hasAdminRole(msg.sender),
            "Does not have admin role"
        );
        _id.increment();
        uint256 id = _id.current();
        _nfts.push(
            NFT(
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
            IRole(_roleAddress).hasAdminRole(msg.sender),
            "Does not have admin role"
        );
        for (uint256 i = 0; i < _nfts.length; i++) {
            if (_nfts[i].id == id) {
                _nfts[i].tokenURI = tokenURI;
                _nfts[i].price = price;
                _nfts[i].contractAddress = contractAddress;
                _nfts[i].tokenId = tokenId;
                _nfts[i].contractType = contractType;
                _nfts[i].allowNum = allowNum;

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

    function getNFT(uint256 id) public view returns (NFT memory) {
        for (uint256 i = 0; i < _nfts.length; i++) {
            if (_nfts[i].id == id) {
                return _nfts[i];
            }
        }
        revert("NFT does not exist");
    }

    function deleteNFT(uint256 id) public {
        require(
            IRole(_roleAddress).hasAdminRole(msg.sender),
            "Does not have admin role"
        );

        for (uint256 i = 0; i < _nfts.length; i++) {
            if (_nfts[i].id == id) {
                _nfts[i] = _nfts[_nfts.length - 1];
                _nfts.pop();
                emit eveDelete(id);
                return;
            }
        }

        revert("NFT does not exist");
    }

    function mint(uint256 id, uint256 num) public {
        IERC20 erc20 = IERC20(_erc20Address);

        NFT memory nft = getNFT(id);

        uint256 amount = erc20.allowance(msg.sender, address(this));

        require(amount >= nft.price * num, "Insufficient authorized amount");

        require(nft.allowNum >= nft.mintNum + num, "Insufficient inventory");

        erc20.transferFrom(msg.sender, _settlementAddress, nft.price * num);

        if (nft.contractType == 1) {
            for (uint i = 0; i < num; i++) {
                IERC721(nft.contractAddress).safeMint(msg.sender, nft.tokenURI);
            }
        } else if (nft.contractType == 2) {
            IERC1155(nft.contractAddress).mint(
                msg.sender,
                nft.tokenId,
                num,
                nft.tokenURI,
                ""
            );
        } else {
            revert("invalid contract type");
        }

        for (uint256 i = 0; i < _nfts.length; i++) {
            if (_nfts[i].id == id) {
                _nfts[i].mintNum += num;
                break;
            }
        }

        emit eveUpdateMintNum(id, nft.mintNum + num);

        emit eveMint(id, msg.sender, num, nft.price, amount);
    }
}
