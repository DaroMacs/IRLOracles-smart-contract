import hre from "hardhat";

const devices = ["Device1", "Device2", "Device3", "Device4", "Device5"];

async function main() {
  const [deployer] = await hre.viem.getWalletClients();
  const publicClient = await hre.viem.getPublicClient();

  console.log("Deploying IoTDeviceOracle contract...");
  console.log("Deployer address:", deployer.account.address);

  // Deploy the IoTDeviceOracle contract
  const iotDeviceOracle = await hre.viem.deployContract("IoTDeviceOracle", []);

  console.log(
    `IoTDeviceOracle contract deployed at ${iotDeviceOracle.address}`,
  );

  // Wait for the contract to be deployed
  await new Promise((resolve) => setTimeout(resolve, 5000));

  // Contract verification after deployment
  try {
    await hre.run("verify:verify", {
      address: iotDeviceOracle.address,
      constructorArguments: [],
    });
    console.log("Contract verified successfully");
  } catch (error) {
    console.log("Error verifying contract:", error);
  }

  // Create devices
  for (const device of devices) {
    try {
      // Create device
      const createTx = await iotDeviceOracle.write.createDevice([device], {
        account: deployer.account.address,
      });

      const createReceipt = await publicClient.waitForTransactionReceipt({
        hash: createTx,
      });

      if (createReceipt.status === "success") {
        console.log(`Device ${device} created successfully`);
      } else {
        console.log(`Failed to create device ${device}`);
      }
    } catch (error) {
      console.error(`Error processing device ${device}:`, error);
    }
  }

  // Display token information
  try {
    // @ts-ignore - Contract methods are available at runtime
    const tokenName = await iotDeviceOracle.read.name();
    // @ts-ignore - Contract methods are available at runtime
    const tokenSymbol = await iotDeviceOracle.read.symbol();
    // @ts-ignore - Contract methods are available at runtime
    const deployerBalance = await iotDeviceOracle.read.balanceOf([
      deployer.account.address,
    ]);

    console.log("\nToken Information:");
    console.log(`Name: ${tokenName}`);
    console.log(`Symbol: ${tokenSymbol}`);
    console.log(`Deployer Balance: ${deployerBalance.toString()}`);
  } catch (error) {
    console.error("Error fetching token information:", error);
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
