pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/utils/Counters.sol";

import "./utils/StrUtil.sol";

abstract contract IRole {
    function hasAdminRole(address account) public view returns (bool) {}
}

abstract contract IERC721 {
    function safeMint(address to, string memory uri) public returns (uint256) {}

    function ownerOf(uint256 tokenId) public view virtual returns (address) {}
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

abstract contract ISpaceLocation {
    struct SpaceLocation {
        uint256 spaceTypeId; //空间分类ID
        uint256 coordinate; //场景坐标编号
        bool isMint; //是否已经铸造
    }

    function getSpaceLocation(
        uint256 id
    ) public view returns (SpaceLocation memory) {}

    function updateMintStatus(uint256 coordinate, bool isMint) public {}
}

abstract contract ISpaceType {
    struct SpaceType {
        uint256 id; //资源分类ID
        uint256 orderNum; //资源分类排序
        string name; //分类名称
        string coverImage; //封面图片
        string remark; //描述
        uint256 payPrice; //支付价格
        uint256 pledgePrice; //抵押价格
        uint256 airdropPrice; //空投价格
    }

    function getSpaceType(uint256 id) public view returns (SpaceType memory) {}
}

contract MGN_Space is Ownable {
    Counters.Counter private _index;
    address public _roleAddress;
    address public _spaceNftAddress;
    address public _spaceLocationAddress;
    address public _spaceTypeAddress;
    address public _settlementAddress;
    address public _erc20Address;

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
        uint256 id; //空间ID
        string name; //空间名称
        string coverImage; //封面图片
        string file; //空间关卡文件
        string fileHash; //空间文件哈希
    }

    struct SpacePayInfo {
        uint256 id; //空间ID
        uint8 payType; //支付类型 1：支付 2：抵押
        uint256 payPrice; //支付价格
        uint256 airdropPrice; //空投价格
    }

    struct SpaceContractAddress {
        uint256 id; //空间ID
        address erc721Address; //721 NFT地址
        address erc1155Address; //1155 NFT地址
    }

    struct Space {
        uint256 id; //空间ID
        uint256 spaceTypeId; //空间分类ID
        bytes32 sid; //空间编号
        uint256 tokenId; //NFT Token ID
        uint256 coordinate; //场景坐标位置编号
    }

    event eveAdd(
        uint256 id,
        uint256 spaceTypeId,
        bytes32 sid,
        uint256 tokenId,
        uint256 coordinate,
        uint32 payType,
        uint256 payPrice,
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

    function setRoleAddress(address roleAddress) public onlyOwner {
        _roleAddress = roleAddress;
    }

    function setSpaceNftAddress(address spaceNftAddress) public onlyOwner {
        _spaceNftAddress = spaceNftAddress;
    }

    function setSpaceLocationAddress(
        address spaceLocationAddress
    ) public onlyOwner {
        _spaceLocationAddress = spaceLocationAddress;
    }

    function setSpaceTypeAddress(address spaceTypeAddress) public onlyOwner {
        _spaceTypeAddress = spaceTypeAddress;
    }

    function settlementAddress(address settlementAddress) public onlyOwner {
        _settlementAddress = settlementAddress;
    }

    function setErc20Address(address erc20Address) public onlyOwner {
        _erc20Address = erc20Address;
    }

    function mint(
        uint256 spaceTypeId,
        uint256 coordinate,
        uint8 payType
    ) public {
        updateSpaceLocation(coordinate, spaceTypeId);

        IERC20 erc20 = IERC20(_erc20Address);

        uint256 amount = erc20.allowance(msg.sender, address(this));

        uint256[] memory spaceTypePrice = getPayPrice(spaceTypeId, payType);

        require(amount >= spaceTypePrice[0], "Insufficient authorized amount");

        erc20.transferFrom(msg.sender, _settlementAddress, spaceTypePrice[0]);
        if (spaceTypePrice[1] > 0) {
            erc20.transferFrom(
                _settlementAddress,
                msg.sender,
                spaceTypePrice[1]
            );
        }

        IERC721 erc721Address = IERC721(_spaceNftAddress);

        require(_spaceNFTTokenURI[spaceTypeId].length > 0, "No NFT Token URI");

        string memory tokenURI = _spaceNFTTokenURI[spaceTypeId][0];

        uint256 tokenId = erc721Address.safeMint(msg.sender, tokenURI);

        delSpaceNFTTokenURI(spaceTypeId, tokenURI);

        _index.increment();

        bytes32 sid = generateHash(
            (block.timestamp + _index.current()).toString()
        );

        _id.increment();

        _spaces.push(
            Space(_id.current(), spaceTypeId, sid, tokenId, coordinate)
        );

        _spacePayInfos.push(
            SpacePayInfo(
                _id.current(),
                payType,
                spaceTypePrice[0],
                spaceTypePrice[1]
            )
        );

        SpaceEditInfo memory spaceEditInfo = SpaceEditInfo(
            _id.current(),
            msg.sender.toHexString(),
            defCoverImage,
            defFile,
            fileHash
        );

        _spaceEditInfos.push(spaceEditInfo);

        _spaceContractAddresses.push(
            SpaceContractAddress(_id.current(), address(0), address(0))
        );

        emit eveAdd(
            _id.current(),
            spaceTypeId,
            sid,
            tokenId,
            coordinate,
            payType,
            spaceTypePrice[0],
            spaceTypePrice[1]
        );

        emit eveUpdate(
            spaceEditInfo.id,
            spaceEditInfo.name,
            spaceEditInfo.coverImage,
            spaceEditInfo.file,
            spaceEditInfo.fileHash
        );
    }

    function getPayPrice(
        uint256 spaceTypeId,
        uint8 payType
    ) private view returns (uint256[] memory) {
        ISpaceType spaceTypeAddress = ISpaceType(_spaceTypeAddress);

        ISpaceType.SpaceType memory spaceType = spaceTypeAddress.getSpaceType(
            spaceTypeId
        );

        require(spaceType.id > 0, "Space type does not exist");

        uint256 price;

        if (payType == 1) {
            price = spaceType.payPrice;
        } else if (payType == 2) {
            price = spaceType.pledgePrice;
        } else {
            revert("Pay type error");
        }

        uint256[] memory result = new uint256[](2);
        result[0] = price;
        result[1] = spaceType.airdropPrice;

        return result;
    }

    function updateSpaceLocation(uint256 id, uint256 spaceTypeId) private {
        ISpaceLocation spaceLocationAddress = ISpaceLocation(
            _spaceLocationAddress
        );

        ISpaceLocation.SpaceLocation memory spaceLocation = spaceLocationAddress
            .getSpaceLocation(id);

        if (spaceLocation.isMint) {
            revert("Space already exists");
        }

        require(spaceLocation.spaceTypeId == spaceTypeId, "Space type error");

        spaceLocationAddress.updateMintStatus(id, true);
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
        IRole role = IRole(_roleAddress);
        require(role.hasAdminRole(msg.sender), "not admin role");

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
        IRole role = IRole(_roleAddress);
        require(role.hasAdminRole(msg.sender), "not admin role");

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
