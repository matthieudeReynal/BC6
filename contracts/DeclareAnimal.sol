pragma solidity ^0.5.2;

import "./Ownable.sol";
import "./ERC721.sol";
import "./safemath.sol";


contract DeclareAnimal is Ownable{
    
    using SafeMath for uint256;
    address[] public whitelist;
    string public myAdress = "";
    
  constructor() public{}

    function registerBreeder(address _adress) private{
        require(keccak256(abi.encode(msg.sender)) == keccak256(abi.encode(myAdress)));
        whitelist.push(_adress);
    }
    
    function inWhiteList(address _adress) public view returns(bool){
        bool presence = false;
        for(uint i = 0; i < whitelist.length; i++){
    
            if(_adress == whitelist[i])
            {
                presence = true;
            }
        }
    return presence;
    }
    
    struct Animal{
        string name;
        string species;
        uint dna;
        string color;
        uint size;
    }
    
    Animal[] public animals;
    
    mapping (uint => address) public animalToOwner;
    mapping (address => uint) ownerAnimalCount;
    
    function _createAnimal(string memory _name, string memory _species, uint _dna, string memory _color, uint _size) public {
        require(inWhiteList(msg.sender) == true);
        uint id  = animals.push(Animal(_name, _species, _dna, _color, _size)) - 1;
        animalToOwner[id] = msg.sender;
        ownerAnimalCount[msg.sender]++;
    }
    
    function deadAnimal(uint _id) public {
        require(inWhiteList(msg.sender) == true);
        require(animalToOwner[_id] == msg.sender);
        delete animalToOwner[_id];
        ownerAnimalCount[msg.sender] --;
        delete animals[_id];
    }
    
    function breadAnimal(uint _id1, uint _id2) public{
        require(animalToOwner[_id1] == msg.sender);
        require(animalToOwner[_id2] == msg.sender);
        require(keccak256(abi.encode(animals[_id1].species)) == keccak256(abi.encode(animals[_id2].species)));
        string memory newName = "";
        string memory newSpecies = animals[_id1].species;
        uint newDna = (animals[_id1].dna + animals[_id2].dna) / 2;
        string memory newColor = "blue";
        uint newSize = animals[_id2].size;
        uint id  = animals.push(Animal(newName, newSpecies, newDna, newColor, newSize)) - 1;
        animalToOwner[id] = msg.sender;
        ownerAnimalCount[msg.sender]++;
    }
    
    struct Auction{
        uint animalId;
        address payable owner;
        uint currentPrice;
        address payable lastBidder;
        uint256 startTime; 
    }
    
    uint256 constant days_2 = 2*24*60*60;
    
    Auction[] public auctions;
    
    function createAuction(uint _animalId, uint depPrice) public {
        require(animalToOwner[_animalId] == msg.sender);
        uint256 _startTime = now;
        uint id  = auctions.push(Auction(_animalId, msg.sender, depPrice, msg.sender, _startTime)) - 1;
    }
    
    function bidOnAuction(uint bid, uint auctionId) public{
        require(inWhiteList(msg.sender) == true);
        uint256 endsTime = auctions[auctionId].startTime.add(days_2) ;
        require(endsTime < now);
        require(bid > auctions[auctionId].currentPrice);
        auctions[auctionId].currentPrice = bid;
        auctions[auctionId].lastBidder = msg.sender; 
    }
    
    function claimAuction(uint auctionId) public {
        require(auctions[auctionId].lastBidder == msg.sender);
        uint256 endsTime = auctions[auctionId].startTime.add(days_2) ;
        //require(endsTime‬ > now);
        //require(msg.value == auctions[auctionId].currentPrice);
        animalToOwner[auctions[auctionId].animalId] = msg.sender;
        ownerAnimalCount[msg.sender] ++;
        ownerAnimalCount[auctions[auctionId].owner] --;
        auctions[auctionId].owner.send(auctions[auctionId].currentPrice);
    }
    
    modifier onlyOwnerOf(uint _animalId) {
    require(msg.sender == animalToOwner[_animalId]);
    _;
  }
    
}