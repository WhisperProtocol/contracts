require("@nomicfoundation/hardhat-toolbox");

const PRIVATE_KEY = vars.get('PRIVATE_KEY')
const RPC_URL = vars.get('RPC_URL')

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.20",
  networks: {
    holesky: {
      url: RPC_URL,
      accounts: [PRIVATE_KEY]
    }
  }
};
