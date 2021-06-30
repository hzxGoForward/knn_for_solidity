const HelloWorld = artifacts.require("HelloWorld");
const Good = artifacts.require("Good");

module.exports = function (deployer) {
    deployer.deploy(Good);
    deployer.link(Good, HelloWorld);
    deployer.deploy(HelloWorld);
};