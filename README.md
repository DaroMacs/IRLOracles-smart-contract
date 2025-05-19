# IRL Oracles dApp

IRL Oracles is a decentralized platform that bridges IoT devices with blockchain technology, enabling secure and verifiable data collection from physical devices. The platform uses smart contracts to manage device registration, data recording, and automated token rewards for data providers.

## 🌟 Key Features

- **IoT Device Management**: Register and manage IoT devices on the blockchain
- **Real-time Data Recording**: Securely record device data with timestamps
- **Tokenized Rewards**: Earn IoTK tokens for consistent data provision
- **Device Status Control**: Enable/disable devices as needed
- **Transparent Ownership**: Clear device ownership tracking
- **Automated Incentives**: Receive rewards every 5 data recordings
- **Immutable Records**: All device data is permanently stored on the blockchain

## 🛠 Technical Implementation

### Smart Contract Features

- **Device Registration**: Create and register new IoT devices
- **Data Recording**: Record device data with timestamps
- **Status Management**: Toggle device enabled/disabled status
- **Reward System**: Automated IoTK token distribution
- **Data Retrieval**: Query device data and status

### Token Economics

- **Token Name**: IoTDeviceToken (IoTK)
- **Token Symbol**: IoTK
- **Initial Supply**: 1,000,000 IoTK
- **Reward Rate**: 10 IoTK per 5 data recordings

## 📝 Smart Contract Functions

- `createDevice(string _device)`: Register a new IoT device
- `recordDeviceData(uint256 _totalData, string _device)`: Record device data
- `toggleDeviceStatus(string _device)`: Enable/disable device
- `getDeviceData(string _device)`: Retrieve device information

## 🔒 Security Features

- Device name uniqueness enforcement
- Owner-only device management
- Data validation checks
- Secure token distribution

## 🚀 Getting Started

1. Deploy the IoTDeviceOracle smart contract
2. Register your IoT device using `createDevice`
3. Start recording data with `recordDeviceData`
4. Monitor and manage device status
5. Earn IoTK tokens for consistent data provision

## 🔑 Environment Variables

Create a `.env` file in the root directory with the following variables:

```env
PRIVATE_KEY: ""
RPC_PROVIDER: ""
ETHERSCAN_API_KEY: ""

```

## 📊 Data Structure

Each device record contains:

- Device identifier
- Total data recorded
- Timestamp of last update
- Owner address
- Device status (enabled/disabled)
- Record counter

## 🔄 Events

- `DeviceCreated`: Emitted when a new device is registered
- `DeviceDataRecorded`: Emitted when new data is recorded
- `DeviceStatusChanged`: Emitted when device status is toggled
- `IoTKRewardIssued`: Emitted when rewards are distributed

## 🔮 Future Enhancements

- Enhanced data validation mechanisms
- Advanced reward distribution algorithms
- Multi-device management features
- Data marketplace integration
- Cross-chain compatibility

## 📄 License

MIT License
