pragma solidity ^0.4.17;

contract Lottery {
    address public manager;
    address[] public players;

    function Lottery() public {
        manager = msg.sender;
    }

    function enter() public payable {     //This function is used to enter into the lottery
        require(msg.value > .01 ether);

        players.push(msg.sender);
    }

    function random() private view returns (uint) {   //Random function is used for creating the random numbers 
        return uint(keccak256(block.difficulty, now, players));
    }

    function pickWinner() public restricted {  //This function pick the winner from lottery
        uint index = random() % players.length;
        players[index].transfer(this.balance);
        players = new address[](0);
    }

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    function getPlayers() public view returns (address[]) {  //Return the list of players.
        return players;
    }
}
