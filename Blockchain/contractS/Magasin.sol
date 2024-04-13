// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "PCD/contractS/SharedState.sol"; 
import "PCD/contractS/Customer.sol";

contract Magasin {
    string public name;
    SharedState sharedstate;

     constructor (string memory _name, address sharedStateAddress) {
        name= _name;
        sharedstate = SharedState(sharedStateAddress);
    }
    // add card == add customer to the store == create card 
    function createCard(uint256 id_client, uint256 initial_balance) public returns(bool) {
        require(!sharedstate.customerExists(id_client), "Customer already exists");
        Customer newCustomer = new Customer(id_client,address(sharedstate));
        sharedstate.setBalance(id_client, initial_balance); 
        sharedstate.addCustomer(address(newCustomer), id_client);
        return true;
       
       // calcul de initial balance is done outside of the blockchain
     // could be 0 or =! 0 if the customer has done a purchase (math of points % purchase done outside) 
    }
    function deleteCard(uint256 client_id) public returns (bool){
        require(sharedstate.customerExists(client_id), "Customer does not exist");
        sharedstate.deleteCustomer(client_id);
        return true;
    }
    
}