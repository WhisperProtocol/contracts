const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

// const JAN_1ST_2030 = 1893456000;
// const ONE_GWEI = 1_000_000_000n;

const amount = 1000000000000000n;

module.exports = buildModule("WhisperModule", (m) => {
  // const unlockTime = m.getParameter("unlockTime", JAN_1ST_2030);
  // const lockedAmount = m.getParameter("lockedAmount", ONE_GWEI);

  // const lock = m.contract("Lock", [unlockTime], {
  //   value: lockedAmount,
  // });

  const mimc5 = m.contract("MiMC5");

  const verifier = m.contract("Verifier");

  const whisper = m.contract("Whisper", [mimc5, verifier, amount]);
  
  return { mimc5, verifier, whisper};

  // return { lock };
});
