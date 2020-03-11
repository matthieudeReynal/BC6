pragma solidity ^0.5.2;

import "./ERC721.sol";
import "./safemath.sol";
import "./DeclareAnimal.sol";

contract AnimalOwnership is ERC721, DeclareAnimal {

  using SafeMath for uint256;

  mapping (uint => address) animalApprovals;

  function balanceOf(address _owner) public view returns (uint256 _balance) {
    return ownerAnimalCount[_owner];
  }

  function ownerOf(uint256 _tokenId) public view returns (address _owner) {
    return animalToOwner[_tokenId];
  }

  function _transfer(address _from, address _to, uint256 _tokenId) private {
    ownerAnimalCount[_to] = ownerAnimalCount[_to].add(1);
    ownerAnimalCount[msg.sender] = ownerAnimalCount[msg.sender].sub(1);
    animalToOwner[_tokenId] = _to;
    emit Transfer(_from, _to, _tokenId);
  }

  function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
    _transfer(msg.sender, _to, _tokenId);
  }

  function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
    animalApprovals[_tokenId] = _to;
    emit Approval(msg.sender, _to, _tokenId);
  }

  function takeOwnership(uint256 _tokenId) public {
    require(animalApprovals[_tokenId] == msg.sender);
    address owner = ownerOf(_tokenId);
    _transfer(owner, msg.sender, _tokenId);
  }
}
