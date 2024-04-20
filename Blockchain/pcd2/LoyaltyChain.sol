// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract LoyaltyChain {
    bytes32 [] stores;
    mapping(bytes32 => mapping(uint256 => uint256)) public Balances; // hashed store name => clientID => balance
    mapping (bytes32 =>uint256[] ) public CustomersID; // maps store to their customers
    event PointsTransferred(string indexed store,uint256 indexed fromId, uint256 indexed toId, uint256 amount, uint256 timestamp);
    event PointsReceived(string indexed store, uint256 indexed toId, uint256 indexed fromId, uint256 amount, uint256 timestamp);
    event ItemPurchased(string indexed store, uint256 indexed customerId, uint256 itemPrice, uint256 timestamp);
    event PointsAdded(string indexed store, uint256 indexed customerId, uint256 pointsReceived, uint256 timestamp);

    //admin
    
    function createStore(string memory store_name) public {
        bytes32 hashed_store = keccak256(abi.encodePacked(store_name));
        CustomersID[hashed_store] = new uint256[](0);
        Balances[hashed_store][0];
        stores.push(hashed_store);

    }
 
    //manager
    //Create a new card
    function createCard(string memory _store, uint256 _id, uint256 _initialBalance) public {
    bytes32 hashed_store = keccak256(abi.encodePacked(_store));
    // Ensure the store exists before adding a card
    require(checkStoreExists(hashed_store), "Store does not exist");
    require(Balances[hashed_store][_id] == 0, "Customer ID already exists");
    // Set the initial balance for the new card
    Balances[hashed_store][_id] = _initialBalance;
}

    function deleteCard (string memory _store, uint256 _id) public {
    bytes32 hashed_store= keccak256(abi.encodePacked(_store));  
    require(checkStoreExists(hashed_store), "Element does not exist in the array");
    delete Balances[hashed_store][_id];
    }
     // Getter for customers of a specific store
    function getBalance(string memory _store, uint256 customer_id) public view returns (uint256) {
        bytes32 storeHash= keccak256(abi.encodePacked(_store)); 
        return Balances[storeHash][customer_id];
    }
    
    function setBalance(string memory _store, uint256 customer_id,uint256 new_balance) public {
        bytes32 storeHash= keccak256(abi.encodePacked(_store)); 
        Balances[storeHash][customer_id] = new_balance;
    }
    
    // 4 transactions of customer 
    function transferPoints (string memory _store, uint256 _from, uint256 _to, uint256 _amount) public {
    bytes32 storeHash= keccak256(abi.encodePacked(_store)); 
        Balances[storeHash][_from]= Balances[storeHash][_from]- _amount;
        Balances[storeHash][_to]= Balances[storeHash][_to] + _amount;
        emit PointsTransferred(_store, _from, _to, _amount, block.timestamp);
        emit PointsReceived(_store, _to, _from, _amount, block.timestamp);
    }
    function itemBought(string memory _store, uint256 _customer,uint256 item_price) public {
        bytes32 storeHash= keccak256(abi.encodePacked(_store));   
        uint256 currentBalance =  Balances[storeHash][_customer];
        require(currentBalance >= item_price, "Insufficient balance to purchase item");
        uint256 newBalance = currentBalance - item_price;
         Balances[storeHash][_customer] = newBalance;
        emit ItemPurchased(_store,_customer, item_price, block.timestamp);
       
    }
    function rERC5b4PoR51qWEvAWuJsX6yRVRBvRVta7 (string memory _store, uint256 _customer, uint256 pointsAdded) public {
        bytes32 storeHash= keccak256(abi.encodePacked(_store));   
         require(pointsAdded > 0, "Points added must be greater than 0");
    if (pointsAdded > 0) {
            Balances[storeHash][_customer] += pointsAdded;
            emit PointsAdded(_store, _customer, pointsAdded, block.timestamp);
        }

    }
    function getHashedStore (string memory _store) pure  public returns (bytes32){
        bytes32 storeHash= keccak256(abi.encodePacked(_store));   
        return storeHash;
    }
    function checkStoreExists( bytes32 _store) public view returns (bool) {
    for (uint256 i = 0; i < stores.length; i++) {
        if (stores[i] == _store) {
            return true;
        }
    }
    return false;
    }
    function returnStores() public view returns(bytes32[] memory ) {
        return stores;
    }
    }



