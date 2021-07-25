const Orbs = artifacts.require("Orbs");

module.exports = function (deployer) {
  deployer.deploy(Orbs);
};
