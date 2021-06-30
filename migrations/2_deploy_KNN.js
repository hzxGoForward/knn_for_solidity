const KNN = artifacts.require("KNN");

module.exports = function (deployer) {
  deployer.deploy(KNN);
};
