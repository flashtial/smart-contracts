// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

contract smartWallet {

address  public owner ;

mapping (address => uint) allowence;
mapping (address => bool) isAllowedToSend;
mapping (address => bool) alreadyVoted;

mapping (address=> bool) guardians;
uint public constant totatvotesGuardians = 3;
uint public counterOfVotesForGuardians = 0 ;

address payable nextOwner;
function setGuardian (address guardian) public {
     require( owner == msg.sender , "you are not allowed to set guardian . All the Best !");
     guardians[guardian] = true ;
}
function proposeNewOwner(address payable newOwner) public {
    require(guardians[msg.sender], "you are not the guardian");
    require(alreadyVoted[msg.sender] == false , "you already voted ");
        if(nextOwner!= newOwner){
            nextOwner = newOwner;
            counterOfVotesForGuardians =0;
            }
            counterOfVotesForGuardians =  counterOfVotesForGuardians +1;
            alreadyVoted[msg.sender] = true;
            if (counterOfVotesForGuardians>= totatvotesGuardians){
                owner= newOwner;
                newOwner= payable (address(0));
            }
}


constructor() {
        owner = payable (msg.sender);
    }

function setAllowence ( address _from , uint _amount  ) public {
    require( owner == msg.sender , "you are not allowed to set allowence . All the Best !");
    allowence[_from] = _amount;
    isAllowedToSend[_from] = true;
}
function transfer (address payable _to, uint _amount , bytes memory payload ) public returns (bytes memory) { 
require (_amount <=  address (this).balance , "you try to send more then you have");
if (owner != msg.sender) {
    require (isAllowedToSend[msg.sender] , "you are not allowed to send" );
    require(allowence[msg.sender] >= _amount, "you try to send more then you allowed") ;
}
allowence[msg.sender]-= _amount;
(bool success, bytes memory returnData) = _to.call{value:_amount}(payload);
require (success  , "transaction faild");
return returnData;
}
receive() external payable {}
}