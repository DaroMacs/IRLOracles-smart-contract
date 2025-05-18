import hre from "hardhat";
import { keccak256, stringToBytes } from "viem";

const alumno1 = "0x70997970C51812dc3A010C7d01b50e0d17dc79C8";
const alumno2 = "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC";
const palabraSecreta = "solidity";
const duracionSesion = 3;

async function main() {
  const [profesor] = await hre.viem.getWalletClients();
  const publicClient = await hre.viem.getPublicClient();

  //Deployar el contrato
  const contratoAsistencia = await hre.viem.deployContract("Asistencia", [
    "AsistenciaToken",
    "AST",
    profesor.account.address,
  ]);
  console.log(`Contrato deployado en ${contratoAsistencia.address}`);

  //Verificar el Contrato
  await new Promise((resolve) => setTimeout(resolve, 5000));
  try {
    await hre.run("verify:verify", {
      address: contratoAsistencia.address,
      constructorArguments: [
        "AsistenciaToken",
        "AST",
        profesor.account.address,
      ],
    });
    console.log("Contrato Verificado");
  } catch (error) {
    console.log("Error verificando contrato:", error);
  }

  //Insertar los addresses de los alumnos
  const tx1 = await contratoAsistencia.write.registrarAlumno([alumno1], {
    account: profesor.account.address,
  });
  const receipt1 = await publicClient.waitForTransactionReceipt({ hash: tx1 });

  const tx2 = await contratoAsistencia.write.registrarAlumno([alumno2], {
    account: profesor.account.address,
  });
  const receipt2 = await publicClient.waitForTransactionReceipt({ hash: tx2 });

  console.log(
    `Alumno 1 registrado: ${receipt1.status === "success" ? "OK" : "Failed"}`,
  );
  console.log(
    `Alumno 2 registrado: ${receipt2.status === "success" ? "OK" : "Failed"}`,
  );

  //Insertar primera sesión
  const hashPalabra = keccak256(stringToBytes(palabraSecreta));
  const tx = await contratoAsistencia.write.crearSesion(
    [hashPalabra, BigInt(duracionSesion)],
    {
      account: profesor.account.address,
    },
  );
  const receipt = await publicClient.waitForTransactionReceipt({ hash: tx });
  console.log(
    `Sesión creada: ${receipt.status === "success" ? "OK" : "Failed"}`,
  );
}

main().catch((err) => {
  console.error(err);
  process.exitCode = 1;
});
