
pragma solidity >=0.5.0 <0.8.0; 


contract Quize { 

string public question="What is the name of Ethereum coin?";
mapping(address=>string) public answers;

function toAnswer(string memory answer) public returns (bool){
    
    answers[msg.sender] = answer;
   if (keccak256(abi.encodePacked(answer)) == keccak256(abi.encodePacked("ETHER")))
        return true;
        else
        return false;
}

function getAnswer(address add) public view returns (string memory) {
    return answers[add];
}

}
