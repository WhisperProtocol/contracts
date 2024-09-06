const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

// const JAN_1ST_2030 = 1893456000;
// const ONE_GWEI = 1_000_000_000n;

const amount = 10000000000000000n;

module.exports = buildModule("PoolEth2Module", (m) => {
  // const unlockTime = m.getParameter("unlockTime", JAN_1ST_2030);
  // const lockedAmount = m.getParameter("lockedAmount", ONE_GWEI);

  // const lock = m.contract("Lock", [unlockTime], {
  //   value: lockedAmount,
  // });

  const pool = m.contract("PoolETH", [amount]);
  
  return { pool };

  // return { lock };
});
