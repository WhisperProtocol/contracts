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
    },
    rootstockTestnet : {
      url: "https://public-node.testnet.rsk.co",
      chainId: 31,
      accounts: [PRIVATE_KEY]
    },
    morphHolesky: {
      url: "https://rpc-holesky.morphl2.io",
      chainId: 2810,
      accounts: [PRIVATE_KEY]
    }
  }
};
