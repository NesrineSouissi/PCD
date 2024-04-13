// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SharedState{
   string store_name;
   mapping (uint256 => uint256) public balances;  // maps clientID to their balance
   mapping(uint256 =>address ) public customers;  // maps customer contract address to their clientID
 // later if the nb of customers grows significantly we can use struct with a flag to delete instead of mapping for customers
   event PointsAdded(uint256 indexed customerId, uint256 pointsReceived, uint256 timestamp);

  constructor(string memory _name){
   store_name= _name;
  }
   function updateBalanceAfterPurchase(uint256 clientId,uint256 pointsAdded) internal {
       require(pointsAdded > 0, "Points added must be greater than 0");
        // Optionally add points to the customer's balance after the purchase
    if (pointsAdded > 0) {
            balances[clientId] += pointsAdded;
            emit PointsAdded(clientId, pointsAdded, block.timestamp);
        }

    }
    
 function getBalance (uint256 client_id) public view returns(uint256) {
    return balances[client_id];
 }
 function setBalance (uint client_id, uint256 new_balance) public  {
    balances[client_id]= new_balance;
 }
 
 function addCustomer(address customer_address, uint256 client_id) public {
    customers[client_id]= customer_address;
 }
 function deleteCustomer(uint256 clientId) public {
    
        balances[clientId] = 0;
        delete customers[clientId];
    }
 function customerExists(uint256 clientId) public view returns (bool) {
    return customers[clientId] != address(0);
}

}
/**/