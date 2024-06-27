pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

import "./utils/StrUtil.sol";

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract HyperAGI_Storage is OwnableUpgradeable {
    using Strings for *;
    using StrUtil for *;

    function initialize(address ownable) public initializer {
        __Ownable_init(ownable);
    }

    mapping(string => uint256) public uintStorage;
    mapping(string => address) public addressStorage;
    mapping(string => string) public stringStorage;
    mapping(string => bytes) public bytesStorage;
    mapping(string => bytes1) public bytes1Storage;
    mapping(string => bytes32) public bytes32Storage;

    mapping(string => bool) public boolStorage;

    mapping(string => uint256[]) public uintArrayStorage;
    mapping(string => address[]) public addressArrayStorage;
    mapping(string => string[]) public stringArrayStorage;
    mapping(string => bytes[]) public bytesArrayStorage;
    mapping(string => bool[]) public boolArrayStorage;
    mapping(bytes32 => uint256) public bytes32UintStorage;
    mapping(bytes32 => string) public bytes32StringStorage;

    uint256 public _id;

    address public _serviceAddress;

    function setServiceAddress(address serviceAddress) public onlyOwner {
        _serviceAddress = serviceAddress;
    }

    function setUint(string memory key, uint256 value) public {
        require(msg.sender == _serviceAddress, "only service can set");
        uintStorage[key] = value;
    }

    function getUint(string memory key) public view returns (uint256) {
        return uintStorage[key];
    }

    function setAddress(string memory key, address value) public {
        require(msg.sender == _serviceAddress, "only service can set");
        addressStorage[key] = value;
    }

    function getAddress(string memory key) public view returns (address) {
        return addressStorage[key];
    }

    function setString(string memory key, string memory value) public {
        require(msg.sender == _serviceAddress, "only service can set");
        stringStorage[key] = value;
    }

    function getString(string memory key) public view returns (string memory) {
        return stringStorage[key];
    }

    function setBytes(string memory key, bytes memory value) public {
        require(msg.sender == _serviceAddress, "only service can set");
        bytesStorage[key] = value;
    }

    function getBytes(string memory key) public view returns (bytes memory) {
        return bytesStorage[key];
    }

    function setBool(string memory key, bool value) public {
        require(msg.sender == _serviceAddress, "only service can set");
        boolStorage[key] = value;
    }

    function getBool(string memory key) public view returns (bool) {
        return boolStorage[key];
    }

    function getNextId() public returns (uint256) {
        require(msg.sender == _serviceAddress, "only service can set");
        _id++;
        return _id;
    }

    function setUintArray(string memory key, uint256[] memory uint256Array) public {
        require(msg.sender == _serviceAddress, "only service can set");
        uintArrayStorage[key] = uint256Array;
    }

    function setUintArray(string memory key, uint256 value) public returns (uint256) {
        require(msg.sender == _serviceAddress, "only service can set");
        uintArrayStorage[key].push(value);
        return uintArrayStorage[key].length - 1;
    }

    function setUintArray(string memory key, uint256 index, uint256 value) public {
        require(msg.sender == _serviceAddress, "only service can set");
        require(index < uintArrayStorage[key].length, "Index out of bounds");
        uintArrayStorage[key][index] = value;
    }

    function removeUintArray(string memory key, uint256 index) public {
        require(msg.sender == _serviceAddress, "only service can set");

        require(index < uintArrayStorage[key].length, "Index out of bounds");

        uintArrayStorage[key][index] = uintArrayStorage[key][uintArrayStorage[key].length - 1];

        uintArrayStorage[key].pop();
    }

    function setBytes32(string memory key, bytes32 value) public {
        require(msg.sender == _serviceAddress, "only service can set");
        bytes32Storage[key] = value;
    }

    function getBytes32(string memory key) public view returns (bytes32) {
        return bytes32Storage[key];
    }

    function getUintArray(string memory key) public view returns (uint256[] memory) {
        return uintArrayStorage[key];
    }

    function setAddressArray(string memory key, address[] memory addressArray) public {
        require(msg.sender == _serviceAddress, "only service can set");
        addressArrayStorage[key] = addressArray;
    }

    function setAddressArray(string memory key, address value) public {
        require(msg.sender == _serviceAddress, "only service can set");
        addressArrayStorage[key].push(value);
    }

    function setAddressArray(string memory key, uint256 index, address value) public {
        require(msg.sender == _serviceAddress, "only service can set");

        require(index < addressArrayStorage[key].length, "Index out of bounds");
        addressArrayStorage[key][index] = value;
    }

    function removeAddressArray(string memory key, uint256 index) public {
        require(msg.sender == _serviceAddress, "only service can set");

        require(index < addressArrayStorage[key].length, "Index out of bounds");

        addressArrayStorage[key][index] = addressArrayStorage[key][addressArrayStorage[key].length - 1];

        addressArrayStorage[key].pop();
    }

    function getAddressArray(string memory key) public view returns (address[] memory) {
        return addressArrayStorage[key];
    }

    function setStringArray(string memory key, string[] memory stringArray) public {
        require(msg.sender == _serviceAddress, "only service can set");
        stringArrayStorage[key] = stringArray;
    }

    function setStringArray(string memory key, string memory value) public {
        require(msg.sender == _serviceAddress, "only service can set");
        stringArrayStorage[key].push(value);
    }

    function setStringArray(string memory key, uint256 index, string memory value) public {
        require(msg.sender == _serviceAddress, "only service can set");
        require(index < stringArrayStorage[key].length, "Index out of bounds");
        stringArrayStorage[key][index] = value;
    }

    function removeStringArray(string memory key, uint256 index) public {
        require(msg.sender == _serviceAddress, "only service can set");

        require(index < stringArrayStorage[key].length, "Index out of bounds");

        stringArrayStorage[key][index] = stringArrayStorage[key][stringArrayStorage[key].length - 1];

        stringArrayStorage[key].pop();
    }

    function getStringArray(string memory key) public view returns (string[] memory) {
        return stringArrayStorage[key];
    }

    function setBytesArray(string memory key, bytes[] memory bytesArray) public {
        require(msg.sender == _serviceAddress, "only service can set");
        bytesArrayStorage[key] = bytesArray;
    }

    function setBytesArray(string memory key, bytes memory value) public {
        require(msg.sender == _serviceAddress, "only service can set");
        bytesArrayStorage[key].push(value);
    }

    function setBytesArray(string memory key, uint256 index, bytes memory value) public {
        require(msg.sender == _serviceAddress, "only service can set");
        require(index < bytesArrayStorage[key].length, "Index out of bounds");
        bytesArrayStorage[key][index] = value;
    }

    function removeBytesArray(string memory key, uint256 index) public {
        require(msg.sender == _serviceAddress, "only service can set");

        require(index < bytesArrayStorage[key].length, "Index out of bounds");

        bytesArrayStorage[key][index] = bytesArrayStorage[key][bytesArrayStorage[key].length - 1];

        bytesArrayStorage[key].pop();
    }

    function getBytesArray(string memory key) public view returns (bytes[] memory) {
        return bytesArrayStorage[key];
    }

    function setBoolArray(string memory key, bool[] memory boolArray) public {
        require(msg.sender == _serviceAddress, "only service can set");
        boolArrayStorage[key] = boolArray;
    }

    function setBoolArray(string memory key, bool value) public {
        require(msg.sender == _serviceAddress, "only service can set");
        boolArrayStorage[key].push(value);
    }

    function setBoolArray(string memory key, uint256 index, bool value) public {
        require(msg.sender == _serviceAddress, "only service can set");
        require(index < boolArrayStorage[key].length, "Index out of bounds");
        boolArrayStorage[key][index] = value;
    }

    function removeBoolArray(string memory key, uint256 index) public {
        require(msg.sender == _serviceAddress, "only service can set");

        require(index < boolArrayStorage[key].length, "Index out of bounds");

        boolArrayStorage[key][index] = boolArrayStorage[key][boolArrayStorage[key].length - 1];

        boolArrayStorage[key].pop();
    }

    function getBoolArray(string memory key) public view returns (bool[] memory) {
        return boolArrayStorage[key];
    }

    function setBytes1(string memory key, bytes1 value) public {
        require(msg.sender == _serviceAddress, "only service can set");
        bytes1Storage[key] = value;
    }

    function getBytes1(string memory key) public view returns (bytes1) {
        return bytes1Storage[key];
    }

    function genKey(string memory key, uint256 id) public pure returns (string memory) {
        return string(abi.encodePacked(key, "_", id.toString()));
    }

    function setBytes32Uint(bytes32 key, uint256 value) public {
        require(msg.sender == _serviceAddress, "only service can set");
        bytes32UintStorage[key] = value;
    }

    function getBytes32Uint(bytes32 key) public view returns (uint256) {
        return bytes32UintStorage[key];
    }

    function setBytes32String(bytes32 key, string memory value) public {
        require(msg.sender == _serviceAddress, "only service can set");
        bytes32StringStorage[key] = value;
    }

    function getBytes32String(bytes32 key) public view returns (string memory) {
        return bytes32StringStorage[key];
    }
}
