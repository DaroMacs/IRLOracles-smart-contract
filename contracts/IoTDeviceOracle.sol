// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract IoTDeviceOracle is ERC20 {

    struct DeviceData {
        string device;
        uint256 totalData;
        uint256 timestamp;
        address owner;
        bool enabled;
        uint256 recordCount; // Counter to track the number of records for the device
    }

    mapping(string => DeviceData) public deviceRecords;
    mapping(string => address) public deviceNames;

    // Event declarations
    event DeviceDataRecorded(address indexed user, uint256 totalData, uint256 timestamp, string device);
    event DeviceCreated(address indexed creator, string device);
    event DeviceStatusChanged(address indexed owner, string device, bool enabled);
    event IoTKRewardIssued(address indexed user, uint256 rewardAmount, string device);

    // Constructor for ERC20 token (IoTK)
    constructor() ERC20("IoTDeviceToken", "IoTK") {
        _mint(msg.sender, 1000000 * 10 ** decimals()); // Mint some initial tokens to the owner
    }

    // Function to create a new IoT device
    function createDevice(string memory _device) public {
        require(deviceNames[_device] == address(0), "Device name already taken");

        DeviceData memory newDeviceData = DeviceData({
            device: _device,
            totalData: 0,
            timestamp: block.timestamp,
            owner: msg.sender,
            enabled: true,
            recordCount: 0 // Initialize the record count
        });

        deviceRecords[_device] = newDeviceData;
        deviceNames[_device] = msg.sender;

        emit DeviceCreated(msg.sender, _device);
    }

    // Function to toggle the device's enabled/disabled status
    function toggleDeviceStatus(string memory _device) public {
        DeviceData storage deviceData = deviceRecords[_device];
        deviceData.enabled = !deviceData.enabled;

        emit DeviceStatusChanged(msg.sender, _device, deviceData.enabled);
    }

    // Function to record IoT device data (called by the owner of the device)
    function recordDeviceData(uint256 _totalData, string memory _device) public {
        require(_totalData > 0, "Data must be greater than 0");

        DeviceData storage deviceData = deviceRecords[_device];
        deviceData.totalData = _totalData;
        deviceData.timestamp = block.timestamp;
        deviceData.recordCount += 1; // Increment the record counter

        // Reward IoTK for every 5th record
        if (deviceData.recordCount == 5) {
            uint256 rewardAmount = 10 * 10 ** decimals(); // Reward amount (e.g., 10 IoTK)
            _mint(deviceData.owner, rewardAmount); // Mint and transfer tokens to the device owner
            emit IoTKRewardIssued(deviceData.owner, rewardAmount, _device);

            // Reset the record count after rewarding
            deviceData.recordCount = 0;
        }

        emit DeviceDataRecorded(msg.sender, _totalData, block.timestamp, _device);
    }

    // Function to get the device data by device name
    function getDeviceData(string memory _device) public view returns (string memory, uint256, uint256, address, bool, uint256) {
        DeviceData memory data = deviceRecords[_device];
        require(data.owner != address(0), "Device does not exist");

        return (data.device, data.totalData, data.timestamp, data.owner, data.enabled, data.recordCount);
    }
}
