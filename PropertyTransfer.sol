pragma solidity ^0.4.25;

contract willTransfer{
    address owner;
    uint public totalPropertyInr;
    bool isDeceased;
    address public son1;
    address public son2;
    address public wife;
    uint public numOfNom;
    uint public amtPerNom;
    
    constructor(address _wife, address _son1, address _son2, uint _numOfNom) public payable{
        owner = msg.sender;
        totalPropertyInr = msg.value;
        isDeceased = false;
        wife = _wife;
        son1 = _son1;
        son2 = _son2;
        numOfNom = _numOfNom;
        
    }
    
    modifier onlyWifeCanCall{
        require (msg.sender == wife);
        _;
    }
  
    function isOwnerDead() public onlyWifeCanCall {   //Only wife can call this function when owner is deceased
        isDeceased = true;
    } 
    
    function transferWill() public {                 //This function will transfer the property
       require(isDeceased == true && (msg.sender == wife || msg.sender == son1 || msg.sender == son2));
       
       amtPerNom = totalPropertyInr/numOfNom;
       
       wife.transfer(amtPerNom);
       totalPropertyInr -= amtPerNom;
       son1.transfer(amtPerNom);
       totalPropertyInr -= amtPerNom;
       son2.transfer(amtPerNom);
       totalPropertyInr -= amtPerNom;
    }
}