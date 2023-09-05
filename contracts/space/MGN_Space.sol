pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/utils/Counters.sol";

import "../utils/StrUtil.sol";

abstract contract IMGNRolesCfg {
    function hasAdminRole(address account) public view returns (bool) {}
}

abstract contract IERC721 {
    function safeMint(address to, string memory uri) public returns (uint256) {}

    function ownerOf(uint256 tokenId) public view virtual returns (address) {}
}

abstract contract IUniswapLiquidityCfg {
    struct LiquidityCfg {
        uint256 liquidity;
        uint256 airdropNum;
    }

    function getLiquidityCfgList(
        address token
    ) public view returns (IUniswapLiquidityCfg.LiquidityCfg[] memory) {}

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual {}
}

abstract contract IUniswapV3PositionsNFTV1 {
    function positions(
        uint256 tokenId
    )
        external
        view
        returns (
            uint96 nonce,
            address operator,
            address token0,
            address token1,
            uint24 fee,
            int24 tickLower,
            int24 tickUpper,
            uint128 liquidity,
            uint256 feeGrowthInside0LastX128,
            uint256 feeGrowthInside1LastX128,
            uint128 tokensOwed0,
            uint128 tokensOwed1
        )
    {}

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual {}
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

abstract contract IWorldMap {
    struct WorldMap {
        uint256 spaceTVLId;
        uint256 coordinate;
        bool isMint;
    }

    function getWorldMap(uint256 id) public view returns (WorldMap memory) {}

    function updateMintStatus(uint256 coordinate, bool isMint) public {}
}

abstract contract ISpaceTVL {
    struct SpaceTVL {
        uint256 id;
        uint256 orderNum;
        string name;
        string coverImage;
        string remark;
        uint256 payPrice;
        uint256 airdropPrice;
    }

    function getSpaceTVL(uint256 id) public view returns (SpaceTVL memory) {}
}

contract MGN_Space is Ownable {
    Counters.Counter private _index;
    address public _rolesCfgAddress;
    address public _spaceNftAddress;
    address public _worldMapAddress;
    address public _spaceTVLAddress;
    address public _settlementAddress;
    address public _erc20Address;
    address public _uniswapLiquidityCfgAddress;
    address public _uniswapV3PositionsNFTV1Address;
    address public _transactionProceduresCfgAddres;
    address public _spaceAirdropAddress;
    using Counters for Counters.Counter;
    Counters.Counter private _id;

    using Strings for *;
    using StrUtil for *;

    Space[] public _spaces;

    SpaceEditInfo[] public _spaceEditInfos;

    SpacePayInfo[] public _spacePayInfos;

    SpaceContractAddress[] public _spaceContractAddresses;

    mapping(uint256 => string[]) public _spaceNFTTokenURI;
    mapping(string => bool) public _spaceNFTTokenURIExists;

    mapping(bytes32 => bool) public hashExists;

    string public defCoverImage;
    string public defFile;
    string public fileHash;

    struct SpaceEditInfo {
        uint256 id;
        string name;
        string coverImage;
        string file;
        string fileHash;
    }

    struct SpacePayInfo {
        uint256 id;
        uint8 payType;
        uint256 payPrice;
        uint256 liquidity;
        uint256 airdropPrice;
        uint256 uniswapNFTId;
    }

    struct SpaceContractAddress {
        uint256 id;
        address erc721Address;
        address erc1155Address;
    }

    struct Space {
        uint256 id;
        uint256 spaceTVLId;
        bytes32 sid;
        uint256 tokenId;
        uint256 coordinate;
    }

    event eveAdd(
        uint256 id,
        uint256 spaceTypeId,
        bytes32 sid,
        uint256 tokenId,
        uint256 coordinate,
        uint32 payType,
        uint256 payPrice,
        uint256 liquidity,
        uint256 airdropPrice
    );

    event eveUpdate(
        uint256 id,
        string name,
        string coverImage,
        string file,
        string fileHash
    );
    event eveUpdateERC721Contract(uint256 id, address erc721Address);

    event eveUpdateERC1155Contract(uint256 id, address erc1155Address);

    event eveAddSpaceNFTTokenURI(uint256, string[]);
    event eveDelSpaceNFTTokenURI(uint256, string[]);

    function setDefParameter(
        string memory _defCoverImage,
        string memory _defFile,
        string memory _fileHash
    ) public onlyOwner {
        defCoverImage = _defCoverImage;
        defFile = _defFile;
        fileHash = _fileHash;
    }

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    function setSpaceNftAddress(address spaceNftAddress) public onlyOwner {
        _spaceNftAddress = spaceNftAddress;
    }

    function setWorldMapAddress(address worldMapAddress) public onlyOwner {
        _worldMapAddress = worldMapAddress;
    }

    function setSpaceTVLAddress(address spaceTVLAddress) public onlyOwner {
        _spaceTVLAddress = spaceTVLAddress;
    }

    function settlementAddress(address settlementAddress) public onlyOwner {
        _settlementAddress = settlementAddress;
    }

    function setErc20Address(address erc20Address) public onlyOwner {
        _erc20Address = erc20Address;
    }

    function setUniswapLiquidityCfgAddress(
        address uniswapLiquidityCfgAddress
    ) public onlyOwner {
        _uniswapLiquidityCfgAddress = uniswapLiquidityCfgAddress;
    }

    function setUniswapV3PositionsNFTV1Address(
        address uniswapV3PositionsNFTV1Address
    ) public onlyOwner {
        _uniswapV3PositionsNFTV1Address = uniswapV3PositionsNFTV1Address;
    }

    function setSpaceAirdropAddress(
        address spaceAirdropAddress
    ) public onlyOwner {
        _spaceAirdropAddress = spaceAirdropAddress;
    }

    function pledge(uint256 coordinate, uint256 tokenId) public {
        IUniswapV3PositionsNFTV1 uniswapV3PositionsNFTV1 = IUniswapV3PositionsNFTV1(
                _uniswapV3PositionsNFTV1Address
            );
        (
            ,
            ,
            address token0,
            address token1,
            ,
            ,
            ,
            uint128 liquidity,
            ,
            ,
            ,

        ) = uniswapV3PositionsNFTV1.positions(tokenId);
        uint256 spaceTVLId = updateSpaceLocation(coordinate);
        IUniswapLiquidityCfg uniswapLiquidityCfg = IUniswapLiquidityCfg(
            _transactionProceduresCfgAddres
        );
        if (token0 != _erc20Address && token1 != _erc20Address) {
            revert("Invalid pledge token");
        }
        IUniswapLiquidityCfg.LiquidityCfg[]
            memory liquidityCfgs = uniswapLiquidityCfg.getLiquidityCfgList(
                _erc20Address
            );
        require(liquidityCfgs.length > 0, "Invalid pledge token");
        IERC20 erc20 = IERC20(_erc20Address);
        uint256 airdropNum = 0;
        for (uint i = 0; i < liquidityCfgs.length; i++) {
            if (liquidityCfgs[i].liquidity <= liquidity) {
                erc20.transferFrom(
                    _settlementAddress,
                    msg.sender,
                    liquidityCfgs[i].airdropNum
                );
                airdropNum = liquidityCfgs[i].airdropNum;
                break;
            }
        }
        require(airdropNum > 0, "Your liquidity does not meet the conditions");

        uniswapV3PositionsNFTV1.safeTransferFrom(
            msg.sender,
            address(this),
            tokenId
        );

        IERC721 erc721Address = IERC721(_spaceNftAddress);
        require(_spaceNFTTokenURI[spaceTVLId].length > 0, "No NFT Token URI");
        string memory tokenURI = _spaceNFTTokenURI[spaceTVLId][0];
        uint256 spaceTokenId = erc721Address.safeMint(msg.sender, tokenURI);
        delSpaceNFTTokenURI(spaceTVLId, tokenURI);
        _index.increment();
        bytes32 sid = generateHash(
            (block.timestamp + _index.current()).toString()
        );
        _id.increment();

        Space memory space = Space({
            id: _id.current(),
            spaceTVLId: spaceTVLId,
            sid: sid,
            tokenId: spaceTokenId,
            coordinate: coordinate
        });

        SpaceEditInfo memory spaceEditInfo = SpaceEditInfo({
            id: space.id,
            name: msg.sender.toHexString(),
            coverImage: defCoverImage,
            file: defFile,
            fileHash: fileHash
        });
    }

    function saveSpace(
        Space memory space,
        SpaceEditInfo memory spaceEditInfo,
        SpacePayInfo memory spacePayInfo
    ) private {
        _spaces.push(space);
        _spacePayInfos.push(spacePayInfo);
        _spaceEditInfos.push(spaceEditInfo);
        emit eveAdd(
            space.id,
            space.spaceTVLId,
            space.sid,
            space.tokenId,
            space.coordinate,
            spacePayInfo.payType,
            spacePayInfo.payPrice,
            spacePayInfo.liquidity,
            spacePayInfo.airdropPrice
        );
        emit eveUpdate(
            spaceEditInfo.id,
            spaceEditInfo.name,
            spaceEditInfo.coverImage,
            spaceEditInfo.file,
            spaceEditInfo.fileHash
        );
    }

    // function getPayPrice(
    //     uint256 spaceTVLId,
    //     uint8 payType
    // ) private view returns (uint256[] memory) {
    //     ISpaceTVL spaceTVLAddress = ISpaceTVL(_spaceTVLAddress);

    //     ISpaceTVL.SpaceTVL memory spaceTVL = spaceTVLAddress.getSpaceTVL(
    //         spaceTVLId
    //     );

    //     require(spaceTVL.id > 0, "Space type does not exist");

    //     uint256 price;

    //     if (payType == 1) {
    //         price = spaceTVL.payPrice;
    //     } else if (payType == 2) {
    //         price = spaceTVL.pledgePrice;
    //     } else {
    //         revert("Pay type error");
    //     }

    //     uint256[] memory result = new uint256[](2);
    //     result[0] = price;
    //     result[1] = spaceTVL.airdropPrice;

    //     return result;
    // }

    function updateSpaceLocation(uint256 id) private returns (uint256) {
        IWorldMap worldMapAddress = IWorldMap(_worldMapAddress);

        IWorldMap.WorldMap memory worldMap = worldMapAddress.getWorldMap(id);

        if (worldMap.isMint) {
            revert("Space already exists");
        }

        worldMapAddress.updateMintStatus(id, true);

        return worldMap.spaceTVLId;
    }

    function update(
        uint256 id,
        string memory name,
        string memory coverImage,
        string memory file,
        string memory fileHash
    ) public {
        Space memory space = getSpace(id);

        IERC721 erc721Address = IERC721(_spaceNftAddress);

        for (uint256 i = 0; i < _spaceEditInfos.length; i++) {
            if (_spaceEditInfos[i].id == id) {
                address owner = erc721Address.ownerOf(_spaces[i].tokenId);
                require(msg.sender == owner, "No permission");
                _spaceEditInfos[i].name = name;
                _spaceEditInfos[i].coverImage = coverImage;
                _spaceEditInfos[i].file = file;
                _spaceEditInfos[i].fileHash = fileHash;
                emit eveUpdate(id, name, coverImage, file, fileHash);
                return;
            }
        }
        revert("Space does not exist");
    }

    function getSpace(uint256 id) public view returns (Space memory) {
        for (uint256 i = 0; i < _spaces.length; i++) {
            if (_spaces[i].id == id) {
                return _spaces[i];
            }
        }
        revert("Space does not exist");
    }

    function getSpaceEditInfo(
        uint256 id
    ) public view returns (SpaceEditInfo memory) {
        for (uint256 i = 0; i < _spaceEditInfos.length; i++) {
            if (_spaceEditInfos[i].id == id) {
                return _spaceEditInfos[i];
            }
        }
        revert("Space does not exist");
    }

    function getSpacePayInfo(
        uint256 id
    ) public view returns (SpacePayInfo memory) {
        for (uint256 i = 0; i < _spacePayInfos.length; i++) {
            if (_spacePayInfos[i].id == id) {
                return _spacePayInfos[i];
            }
        }
        revert("Space does not exist");
    }

    function getSpaceContractAddress(
        uint256 id
    ) public view returns (SpaceContractAddress memory) {
        for (uint256 i = 0; i < _spaceContractAddresses.length; i++) {
            if (_spaceContractAddresses[i].id == id) {
                return _spaceContractAddresses[i];
            }
        }
        revert("Space does not exist");
    }

    function generateHash(string memory input) public returns (bytes32) {
        bytes32 hash = keccak256(abi.encodePacked(input));
        require(!hashExists[hash], "Hash already exists");
        hashExists[hash] = true;
        return hash;
    }

    function updateErc721Address(uint256 id, address erc721Address) public {
        Space memory space = getSpace(id);

        IERC721 erc721AddressContract = IERC721(_spaceNftAddress);
        for (uint256 i = 0; i < _spaceContractAddresses.length; i++) {
            if (_spaceEditInfos[i].id == id) {
                address owner = erc721AddressContract.ownerOf(
                    _spaces[i].tokenId
                );
                require(msg.sender == owner, "No permission");
                _spaceContractAddresses[i].erc721Address = erc721Address;
                emit eveUpdateERC721Contract(id, erc721Address);
                return;
            }
        }
        revert("Space does not exist");
    }

    function updateErc1155Address(uint256 id, address erc1155Address) public {
        Space memory space = getSpace(id);

        IERC721 erc721Address = IERC721(_spaceNftAddress);
        for (uint256 i = 0; i < _spaceContractAddresses.length; i++) {
            if (_spaceEditInfos[i].id == id) {
                address owner = erc721Address.ownerOf(_spaces[i].tokenId);
                require(msg.sender == owner, "No permission");
                _spaceContractAddresses[i].erc1155Address = erc1155Address;
                emit eveUpdateERC1155Contract(id, erc1155Address);
                return;
            }
        }
        revert("Space does not exist");
    }

    function putSpaceNFTTokenURI(
        uint256 spaceTypeId,
        string[] memory tokenURIs
    ) public {
        require(
            IMGNRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );

        for (uint i = 0; i < tokenURIs.length; i++) {
            require(
                !_spaceNFTTokenURIExists[tokenURIs[i]],
                tokenURIs[i].toSlice().concat(
                    " tokenURI already exists".toSlice()
                )
            );

            _spaceNFTTokenURIExists[tokenURIs[i]] = true;

            _spaceNFTTokenURI[spaceTypeId].push(tokenURIs[i]);
        }

        emit eveAddSpaceNFTTokenURI(spaceTypeId, tokenURIs);
    }

    function delSpaceNFTTokenURI(
        uint256 spaceTypeId,
        string memory tokenURI
    ) private {
        for (uint j = 0; j < _spaceNFTTokenURI[spaceTypeId].length; j++) {
            if (
                keccak256(
                    abi.encodePacked(_spaceNFTTokenURI[spaceTypeId][j])
                ) == keccak256(abi.encodePacked(tokenURI))
            ) {
                _spaceNFTTokenURI[spaceTypeId][j] = _spaceNFTTokenURI[
                    spaceTypeId
                ][_spaceNFTTokenURI[spaceTypeId].length - 1];
                _spaceNFTTokenURI[spaceTypeId].pop();
                break;
            }
        }

        _spaceNFTTokenURIExists[tokenURI] = false;

        string[] memory tokenURIs = new string[](1);
        tokenURIs[0] = tokenURI;

        emit eveDelSpaceNFTTokenURI(spaceTypeId, tokenURIs);
    }

    function deleteSpaceNFTTokenURI(
        uint256 spaceTypeId,
        string[] memory tokenURIs
    ) public {
        require(
            IMGNRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );
        for (uint i = 0; i < tokenURIs.length; i++) {
            _spaceNFTTokenURIExists[tokenURIs[i]] = false;

            for (uint j = 0; j < _spaceNFTTokenURI[spaceTypeId].length; j++) {
                if (
                    keccak256(
                        abi.encodePacked(_spaceNFTTokenURI[spaceTypeId][j])
                    ) == keccak256(abi.encodePacked(tokenURIs[i]))
                ) {
                    _spaceNFTTokenURI[spaceTypeId][j] = _spaceNFTTokenURI[
                        spaceTypeId
                    ][_spaceNFTTokenURI[spaceTypeId].length - 1];
                    _spaceNFTTokenURI[spaceTypeId].pop();
                    break;
                }
            }
        }
        emit eveDelSpaceNFTTokenURI(spaceTypeId, tokenURIs);
    }
}
