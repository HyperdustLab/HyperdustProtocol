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
    mapping(bytes32 => address) public bytes32AddressStorage;
    mapping(bytes32 => bytes32) public bytes32Bytes32Storage;
    mapping(bytes32 => bool) public bytes32BoolStorage;
    mapping(bytes32 => bytes) public bytes32BytesStorage;

    mapping(bytes32 => uint256[]) public bytes32UintArrayStorage;
    mapping(bytes32 => address[]) public bytes32AddressArrayStorage;
    mapping(bytes32 => string[]) public bytes32StringArrayStorage;
    mapping(bytes32 => bytes32[]) public bytes32Bytes32ArrayStorage;
    mapping(bytes32 => bool[]) public bytes32BoolArrayStorage;
    mapping(bytes32 => bytes[]) public bytes32BytesArrayStorage;

    uint256 public _id;

    address public _serviceAddress;

    function setBytes32UintArray(bytes32 key, uint256[] memory value) public {
        require(msg.sender == _serviceAddress, "only service can set");
        bytes32UintArrayStorage[key] = value;
    }

    function getBytes32UintArray(bytes32 key) public view returns (uint256[] memory) {
        return bytes32UintArrayStorage[key];
    }

    function addToBytes32UintArray(bytes32 key, uint256 value) public {
        require(msg.sender == _serviceAddress, "only service can set");
        bytes32UintArrayStorage[key].push(value);
    }

    function removeFromBytes32UintArray(bytes32 key, uint256 index) public {
        require(msg.sender == _serviceAddress, "only service can set");
        require(index < bytes32UintArrayStorage[key].length, "Index out of bounds");
        bytes32UintArrayStorage[key][index] = bytes32UintArrayStorage[key][bytes32UintArrayStorage[key].length - 1];
        bytes32UintArrayStorage[key].pop();
    }

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

    function getUintArray(string memory key, uint256 index) public view returns (uint256) {
        return uintArrayStorage[key][index];
    }

    function setAddressArray(string memory key, address[] memory addressArray) public {
        require(msg.sender == _serviceAddress, "only service can set");
        addressArrayStorage[key] = addressArray;
    }

    function setAddressArray(string memory key, address value) public returns (uint256) {
        require(msg.sender == _serviceAddress, "only service can set");
        addressArrayStorage[key].push(value);
        return addressArrayStorage[key].length;
    }

    function setAddressArray(string memory key, uint256 index, address value) public returns (uint256) {
        require(msg.sender == _serviceAddress, "only service can set");

        require(index < addressArrayStorage[key].length, "Index out of bounds");
        addressArrayStorage[key][index] = value;
        return addressArrayStorage[key].length;
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

    function getAddressArray(string memory key, uint256 index) public view returns (address) {
        return addressArrayStorage[key][index];
    }

    function getAddressArrayLen(string memory key) public view returns (uint256) {
        return addressArrayStorage[key].length;
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

    function getStringArray(string memory key, uint256 index) public view returns (string memory) {
        return stringArrayStorage[key][index];
    }

    function getStringArrayLen(string memory key) public view returns (uint256) {
        return stringArrayStorage[key].length;
    }

    function setBytesArray(string memory key, bytes[] memory bytesArray) public {
        require(msg.sender == _serviceAddress, "only service can set");
        bytesArrayStorage[key] = bytesArray;
    }

    function setBytesArray(string memory key, bytes memory value) public {
        require(msg.sender == _serviceAddress, "only service can set");
        bytesArrayStorage[key].push(value);
    }

    function setBytesArray(string memory key, uint256 index, bytes memory value) public returns (uint256) {
        require(msg.sender == _serviceAddress, "only service can set");
        require(index < bytesArrayStorage[key].length, "Index out of bounds");
        bytesArrayStorage[key][index] = value;
        return bytesArrayStorage[key].length;
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

    function getBytesArray(string memory key, uint256 index) public view returns (bytes memory) {
        return bytesArrayStorage[key][index];
    }

    function getBytesArrayLen(string memory key, uint256 index) public view returns (uint256) {
        return bytesArrayStorage[key].length;
    }

    function setBoolArray(string memory key, bool[] memory boolArray) public {
        require(msg.sender == _serviceAddress, "only service can set");
        boolArrayStorage[key] = boolArray;
    }

    function setBoolArray(string memory key, bool value) public returns (uint256) {
        require(msg.sender == _serviceAddress, "only service can set");
        boolArrayStorage[key].push(value);
        return boolArrayStorage[key].length;
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

    function getBoolArray(string memory key, uint256 index) public view returns (bool) {
        return boolArrayStorage[key][index];
    }

    function getBoolArrayLen(string memory key) public view returns (uint256) {
        return boolArrayStorage[key].length;
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

    function setBytes32Address(bytes32 key, address value) public {
        require(msg.sender == _serviceAddress, "only service can set");
        bytes32AddressStorage[key] = value;
    }

    function getBytes32Address(bytes32 key) public view returns (address) {
        return bytes32AddressStorage[key];
    }

    function setBytes32Bytes(bytes32 key, bytes memory value) public {
        require(msg.sender == _serviceAddress, "only service can set");
        bytes32BytesStorage[key] = value;
    }

    function getBytes32Bytes(bytes32 key) public view returns (bytes memory) {
        return bytes32BytesStorage[key];
    }

    function setBytes32Bool(bytes32 key, bool value) public {
        require(msg.sender == _serviceAddress, "only service can set");
        bytes32BoolStorage[key] = value;
    }

    function getBytes32Bool(bytes32 key) public view returns (bool) {
        return bytes32BoolStorage[key];
    }

    function setBytes32AddressArray(bytes32 key, address[] memory value) public {
        require(msg.sender == _serviceAddress, "only service can set");
        bytes32AddressArrayStorage[key] = value;
    }

    function getBytes32AddressArray(bytes32 key) public view returns (address[] memory) {
        return bytes32AddressArrayStorage[key];
    }

    function addToBytes32AddressArray(bytes32 key, address value) public returns (uint256) {
        require(msg.sender == _serviceAddress, "only service can set");
        bytes32AddressArrayStorage[key].push(value);
        return bytes32AddressArrayStorage[key].length;
    }

    function removeFromBytes32AddressArray(bytes32 key, uint256 index) public {
        require(msg.sender == _serviceAddress, "only service can set");
        require(index < bytes32AddressArrayStorage[key].length, "Index out of bounds");
        bytes32AddressArrayStorage[key][index] = bytes32AddressArrayStorage[key][bytes32AddressArrayStorage[key].length - 1];
        bytes32AddressArrayStorage[key].pop();
    }

    function setBytes32StringArray(bytes32 key, string[] memory value) public {
        require(msg.sender == _serviceAddress, "only service can set");
        bytes32StringArrayStorage[key] = value;
    }

    function getBytes32StringArray(bytes32 key) public view returns (string[] memory) {
        return bytes32StringArrayStorage[key];
    }

    function addToBytes32StringArray(bytes32 key, string memory value) public returns (uint256) {
        require(msg.sender == _serviceAddress, "only service can set");
        bytes32StringArrayStorage[key].push(value);
        return bytes32StringArrayStorage[key].length;
    }

    function removeFromBytes32StringArray(bytes32 key, uint256 index) public {
        require(msg.sender == _serviceAddress, "only service can set");
        require(index < bytes32StringArrayStorage[key].length, "Index out of bounds");
        bytes32StringArrayStorage[key][index] = bytes32StringArrayStorage[key][bytes32StringArrayStorage[key].length - 1];
        bytes32StringArrayStorage[key].pop();
    }

    function setBytes32BytesArray(bytes32 key, bytes32[] memory value) public {
        require(msg.sender == _serviceAddress, "only service can set");
        bytes32Bytes32ArrayStorage[key] = value;
    }

    function addToBytes32BytesArray(bytes32 key, bytes32 value) public returns (uint256) {
        require(msg.sender == _serviceAddress, "only service can set");
        bytes32Bytes32ArrayStorage[key].push(value);
        return bytes32Bytes32ArrayStorage[key].length;
    }

    function setBytes32BoolArray(bytes32 key, bool[] memory value) public {
        require(msg.sender == _serviceAddress, "only service can set");
        bytes32BoolArrayStorage[key] = value;
    }

    function getBytes32BoolArray(bytes32 key) public view returns (bool[] memory) {
        return bytes32BoolArrayStorage[key];
    }

    function addToBytes32BoolArray(bytes32 key, bool value) public returns (uint256) {
        require(msg.sender == _serviceAddress, "only service can set");
        bytes32BoolArrayStorage[key].push(value);
        return bytes32BoolArrayStorage[key].length;
    }

    function removeFromBytes32BoolArray(bytes32 key, uint256 index) public {
        require(msg.sender == _serviceAddress, "only service can set");
        require(index < bytes32BoolArrayStorage[key].length, "Index out of bounds");
        bytes32BoolArrayStorage[key][index] = bytes32BoolArrayStorage[key][bytes32BoolArrayStorage[key].length - 1];
        bytes32BoolArrayStorage[key].pop();
    }

    function setBytes32BytesArray(bytes32 key, bytes[] memory value) public {
        require(msg.sender == _serviceAddress, "only service can set");
        bytes32BytesArrayStorage[key] = value;
    }

    function getBytes32BytesArray(bytes32 key) public view returns (bytes[] memory) {
        return bytes32BytesArrayStorage[key];
    }

    function addToBytes32BytesArray(bytes32 key, bytes memory value) public returns (uint256) {
        require(msg.sender == _serviceAddress, "only service can set");
        bytes32BytesArrayStorage[key].push(value);
        return bytes32BytesArrayStorage[key].length;
    }

    function removeFromBytes32BytesArray(bytes32 key, uint256 index) public {
        require(msg.sender == _serviceAddress, "only service can set");
        require(index < bytes32BytesArrayStorage[key].length, "Index out of bounds");
        bytes32BytesArrayStorage[key][index] = bytes32BytesArrayStorage[key][bytes32BytesArrayStorage[key].length - 1];
        bytes32BytesArrayStorage[key].pop();
    }

    function setBytes32Bytes32Array(bytes32 key, uint256 index, bytes32 value) public {
        require(msg.sender == _serviceAddress, "only service can set");
        require(index < bytes32Bytes32ArrayStorage[key].length, "Index out of bounds");
        bytes32Bytes32ArrayStorage[key][index] = value;
    }

    function getBytes32Bytes32Array(bytes32 key, uint256 index) public view returns (bytes32) {
        require(index < bytes32Bytes32ArrayStorage[key].length, "Index out of bounds");
        return bytes32Bytes32ArrayStorage[key][index];
    }

    function setBytes32BoolArray(bytes32 key, uint256 index, bool value) public {
        require(msg.sender == _serviceAddress, "only service can set");
        require(index < bytes32BoolArrayStorage[key].length, "Index out of bounds");
        bytes32BoolArrayStorage[key][index] = value;
    }

    function setBytes32BytesArray(bytes32 key, uint256 index, bytes memory value) public {
        require(msg.sender == _serviceAddress, "only service can set");
        require(index < bytes32BytesArrayStorage[key].length, "Index out of bounds");
        bytes32BytesArrayStorage[key][index] = value;
    }

    function getBytes32BytesArray(bytes32 key, uint256 index) public view returns (bytes memory) {
        require(index < bytes32BytesArrayStorage[key].length, "Index out of bounds");
        return bytes32BytesArrayStorage[key][index];
    }

    function setBytes32Bytes32(bytes32 key, bytes32 value) public {
        require(msg.sender == _serviceAddress, "only service can set");
        bytes32Bytes32Storage[key] = value;
    }

    function getBytes32Bytes32(bytes32 key) public view returns (bytes32) {
        return bytes32Bytes32Storage[key];
    }
}
