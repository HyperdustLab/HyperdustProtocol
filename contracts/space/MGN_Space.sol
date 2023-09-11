pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/utils/Counters.sol";

import "../utils/StrUtil.sol";

abstract contract IMGNRolesCfg {
    function hasAdminRole(address account) public view returns (bool) {}

    function addAdmin2(address account) public {}
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

    function transferFrom(
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

abstract contract ISpace721Factory {
    function deploy(
        address account,
        address spaceAssetsCfgAddress
    ) public returns (address) {}
}

abstract contract ISpace1155Factory {
    function deploy(
        address account,
        address spaceAssetsCfgAddress
    ) public returns (address) {}
}

abstract contract ISpaceAirdrop {
    function addSpaceAirdrop(uint256 spaceId, uint256 amount) public {}

    function reduceSpaceAirdrop(uint256 spaceId, uint256 amount) public {}
}

contract MGN_Space is Ownable {
    Counters.Counter private _index;
    address public _rolesCfgAddress;
    address public _spaceNftAddress;
    address public _worldMapAddress;
    address public _spaceTVLAddress;
    address public _erc20Address;
    address public _uniswapLiquidityCfgAddress;
    address public _uniswapV3PositionsNFTV1Address;
    address public _transactionCfgAddress;
    address public _spaceAirdropAddress;
    address public _spaceAssetsCfgAddress;
    address public _space721FactoryAddress;
    address public _space1155FactoryAddress;
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

    event eveSave(uint256 id);

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

    function setSpaceAssetsCfgAddress(
        address spaceAssetsCfgAddress
    ) public onlyOwner {
        _spaceAssetsCfgAddress = spaceAssetsCfgAddress;
    }

    function setTransactionCfgAddress(
        address transactionCfgAddress
    ) public onlyOwner {
        _transactionCfgAddress = transactionCfgAddress;
    }

    function setSpace721FactoryAddress(
        address space721FactoryAddress
    ) public onlyOwner {
        _space721FactoryAddress = space721FactoryAddress;
    }

    function setSpace1155FactoryAddress(
        address space1155FactoryAddress
    ) public onlyOwner {
        _space1155FactoryAddress = space1155FactoryAddress;
    }

    function setContractAddress(
        address[] memory contractaddressArray
    ) public onlyOwner {
        _rolesCfgAddress = contractaddressArray[0];
        _spaceNftAddress = contractaddressArray[1];
        _worldMapAddress = contractaddressArray[2];
        _spaceTVLAddress = contractaddressArray[3];
        _erc20Address = contractaddressArray[4];
        _uniswapLiquidityCfgAddress = contractaddressArray[5];
        _uniswapV3PositionsNFTV1Address = contractaddressArray[6];
        _transactionCfgAddress = contractaddressArray[7];
        _spaceAirdropAddress = contractaddressArray[8];
        _spaceAssetsCfgAddress = contractaddressArray[9];
        _space721FactoryAddress = contractaddressArray[10];
        _space1155FactoryAddress = contractaddressArray[11];
    }

    function pledge(uint256 coordinate, uint256 tokenId) public {
        _id.increment();
        SpacePayInfo memory spacePayInfo = pledgeVeripication(
            coordinate,
            tokenId,
            _id.current()
        );

        uint256 spaceTVLId = updateSpaceLocation(coordinate);

        IERC721 erc721Address = IERC721(_spaceNftAddress);
        require(_spaceNFTTokenURI[spaceTVLId].length > 0, "No NFT Token URI");
        string memory tokenURI = _spaceNFTTokenURI[spaceTVLId][0];
        uint256 spaceTokenId = erc721Address.safeMint(msg.sender, tokenURI);
        delSpaceNFTTokenURI(spaceTVLId, tokenURI);
        _index.increment();
        bytes32 sid = generateHash(
            (block.timestamp + _index.current()).toString()
        );

        Space memory space = Space({
            id: _id.current(),
            spaceTVLId: spaceTVLId,
            sid: sid,
            tokenId: spaceTokenId,
            coordinate: coordinate
        });

        SpaceEditInfo memory spaceEditInfo = SpaceEditInfo({
            id: _id.current(),
            name: msg.sender.toHexString(),
            coverImage: defCoverImage,
            file: defFile,
            fileHash: fileHash
        });

        saveSpace(space, spaceEditInfo, spacePayInfo);
    }

    function getSpace(
        uint256 id
    )
        public
        view
        returns (
            string[] memory,
            uint256[] memory,
            address[] memory,
            bytes32,
            uint8
        )
    {
        for (uint256 i = 0; i < _spaces.length; i++) {
            if (_spaces[i].id == id) {
                string[] memory strArray = new string[](4);
                strArray[0] = _spaceEditInfos[i].name;
                strArray[1] = _spaceEditInfos[i].coverImage;
                strArray[2] = _spaceEditInfos[i].file;
                strArray[3] = _spaceEditInfos[i].fileHash;

                uint256[] memory uintArray = new uint256[](8);
                uintArray[0] = _spacePayInfos[i].id;
                uintArray[1] = _spacePayInfos[i].payPrice;
                uintArray[2] = _spacePayInfos[i].liquidity;
                uintArray[3] = _spacePayInfos[i].airdropPrice;
                uintArray[4] = _spacePayInfos[i].uniswapNFTId;
                uintArray[5] = _spaces[i].spaceTVLId;
                uintArray[6] = _spaces[i].tokenId;
                uintArray[7] = _spaces[i].coordinate;

                address[] memory addressArray = new address[](2);
                addressArray[0] = _spaceContractAddresses[i].erc721Address;
                addressArray[1] = _spaceContractAddresses[i].erc1155Address;

                return (
                    strArray,
                    uintArray,
                    addressArray,
                    _spaces[i].sid,
                    _spacePayInfos[i].payType
                );
            }
        }
        revert("Space does not exist");
    }

    function pledgeVeripication(
        uint256 coordinate,
        uint256 tokenId,
        uint256 spaceId
    ) private returns (SpacePayInfo memory) {
        // IUniswapV3PositionsNFTV1 uniswapV3PositionsNFTV1 = IUniswapV3PositionsNFTV1(
        //         _uniswapV3PositionsNFTV1Address
        //     );
        // (
        //     ,
        //     ,
        //     address token0,
        //     address token1,
        //     ,
        //     ,
        //     ,
        //     uint128 liquidity,
        //     ,
        //     ,
        //     ,

        // ) = uniswapV3PositionsNFTV1.positions(tokenId);

        // IUniswapLiquidityCfg uniswapLiquidityCfg = IUniswapLiquidityCfg(
        //     _uniswapLiquidityCfgAddress
        // );
        // if (token0 != _erc20Address && token1 != _erc20Address) {
        //     revert(
        //         "Invalid pledge token"
        //             .toSlice()
        //             .concat(token0.toHexString().toSlice())
        //             .toSlice()
        //             .concat(" ".toSlice())
        //             .toSlice()
        //             .concat(token1.toHexString().toSlice())
        //     );
        // }

        // address tokenAddress = token0 == _erc20Address ? token1 : token0;

        // IUniswapLiquidityCfg.LiquidityCfg[]
        //     memory liquidityCfgs = uniswapLiquidityCfg.getLiquidityCfgList(
        //         tokenAddress
        //     );
        // require(liquidityCfgs.length > 0, "Invalid pledge token");
        // uint256 airdropNum = 0;
        // for (uint i = 0; i < liquidityCfgs.length; i++) {
        //     if (liquidityCfgs[i].liquidity <= liquidity) {
        //         airdropNum = liquidityCfgs[i].airdropNum;
        //         break;
        //     }
        // }
        // require(airdropNum > 0, "Your liquidity does not meet the conditions");

        // uniswapV3PositionsNFTV1.transferFrom(
        //     msg.sender,
        //     address(this),
        //     tokenId
        // );

        SpacePayInfo memory spacePayInfo = SpacePayInfo({
            id: spaceId,
            payType: 2,
            payPrice: 0,
            liquidity: 200,
            airdropPrice: 200,
            uniswapNFTId: tokenId
        });

        ISpaceAirdrop(_spaceAirdropAddress).addSpaceAirdrop(spaceId, 200);

        return spacePayInfo;
    }

    function saveSpace(
        Space memory space,
        SpaceEditInfo memory spaceEditInfo,
        SpacePayInfo memory spacePayInfo
    ) private {
        _spaces.push(space);
        _spacePayInfos.push(spacePayInfo);
        _spaceEditInfos.push(spaceEditInfo);

        address space721Address = ISpace721Factory(_space721FactoryAddress)
            .deploy(msg.sender, _spaceAssetsCfgAddress);

        IMGNRolesCfg MGNRolesCfg = IMGNRolesCfg(_rolesCfgAddress);

        MGNRolesCfg.addAdmin2(space721Address);

        address space1155Address = ISpace1155Factory(_space1155FactoryAddress)
            .deploy(msg.sender, _spaceAssetsCfgAddress);

        MGNRolesCfg.addAdmin2(space1155Address);

        _spaceContractAddresses.push(
            SpaceContractAddress({
                id: space.id,
                erc721Address: space721Address,
                erc1155Address: space1155Address
            })
        );

        emit eveSave(space.id);
    }

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
        IERC721 erc721Address = IERC721(_spaceNftAddress);

        for (uint256 i = 0; i < _spaceEditInfos.length; i++) {
            if (_spaceEditInfos[i].id == id) {
                address owner = erc721Address.ownerOf(_spaces[i].tokenId);
                require(msg.sender == owner, "No permission");
                _spaceEditInfos[i].name = name;
                _spaceEditInfos[i].coverImage = coverImage;
                _spaceEditInfos[i].file = file;
                _spaceEditInfos[i].fileHash = fileHash;
                emit eveSave(id);
                return;
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
