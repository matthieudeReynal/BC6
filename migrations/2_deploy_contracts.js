
var AnimalOwnership = artifacts.require("./AnimalOwnership.sol");
var DeclareAnimal = artifacts.require("./DeclareAnimal.sol");
var ERC721 = artifacts.require("./ERC721.sol");
var Ownable = artifacts.require("./Ownable.sol");
var safemath = artifacts.require("./safemath.sol");

module.exports = function(deployer) {
  deployer.deploy(AnimalOwnership);
  deployer.deploy(DeclareAnimal);
  //deployer.deploy(ERC721);
  deployer.deploy(Ownable);
  //deployer.deploy(safemath);
};