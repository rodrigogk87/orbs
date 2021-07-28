const Orbs = artifacts.require("Orbs");

module.exports = function (deployer, _network, accounts) {
  deployer.deploy(Orbs,{from:accounts[0]});
};
