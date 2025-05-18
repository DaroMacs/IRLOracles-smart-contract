import hre from "hardhat";

const devices = ["Device1", "Device2", "Device3", "Device4", "Device5"];

async function main() {
  const [deployer] = await hre.viem.getWalletClients();
  const publicClient = await hre.viem.getPublicClient();

  // Deploy the IoTDeviceOracle contract
  const contratoIoTDeviceOracle = await hre.viem.deployContract(
    "IoTDeviceOracle",
    [],
  );
  console.log(
    `Contrato IoTDeviceOracle desplegado en ${contratoIoTDeviceOracle.address}`,
  );

  // Wait for the contract to be deployed
  await new Promise((resolve) => setTimeout(resolve, 5000));

  // Contract verification after deployment
  try {
    await hre.run("verify:verify", {
      address: contratoIoTDeviceOracle.address,
      constructorArguments: [],
    });
    console.log("Contrato verificado");
  } catch (error) {
    console.log("Error verificando contrato:", error);
  }

  // Create 5 devices by calling createDevice for each device name
  for (const device of devices) {
    const tx = await contratoIoTDeviceOracle.write.createDevice([device], {
      account: deployer.account.address,
    });

    // Wait for the transaction to be mined
    const receipt = await publicClient.waitForTransactionReceipt({ hash: tx });
    if (receipt.status === "success") {
      console.log(`Dispositivo ${device} creado exitosamente`);
    } else {
      console.log(`Falló la creación del dispositivo ${device}`);
    }
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
