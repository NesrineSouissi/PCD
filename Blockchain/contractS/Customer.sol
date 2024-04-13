// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "PCD/contractS/SharedState.sol";
contract Customer {
    uint256 id;
    SharedState sharedstate;
    /*event transaction_history (
        uint256 indexed _from,
        uint256 indexed _to,
        uint256 indexed _amount
    );*/
     event PointsTransferred(uint256 indexed fromId, uint256 indexed toId, uint256 amount, uint256 timestamp);
    event PointsReceived(uint256 indexed fromId, uint256 indexed toId, uint256 amount, uint256 timestamp);
    event ItemPurchased(uint256 indexed customerId, uint256 itemPrice, uint256 timestamp);
    constructor (uint256 client_id, address sharedStateAddress){
        id = client_id;
        sharedstate = SharedState(sharedStateAddress);

    }
    // buys item with points
    function itemBought(uint256 item_price) public returns(bool){
        uint256 currentBalance = sharedstate.getBalance(id);
        require(currentBalance >= item_price, "Insufficient balance to purchase item");
        uint256 newBalance = currentBalance - item_price;
        sharedstate.setBalance(id, newBalance);
        emit ItemPurchased(id, item_price, block.timestamp);
        return true;
    }

    // transfer points to other customer 

    function transferPoints(uint256 _to, uint256 _amount) public returns (bool) {
        uint256 current_from = sharedstate.getBalance(id);
        require(current_from >= _amount, "Insufficient balance to transfer points");
        uint256 current_to = sharedstate.getBalance(_to);
        uint256 newBalance_from = current_from - _amount;
        uint256 newBlanace_to = current_to + _amount;
        sharedstate.setBalance(id, newBalance_from);
        sharedstate.setBalance(_to, newBlanace_to);
        emit PointsTransferred(id, _to, _amount, block.timestamp);
        emit PointsReceived(_to, id, _amount, block.timestamp);
        return true;
    }
   
     // function check_balance ()
    function checkBalance(uint256 _id) public view returns (uint256 _balance) {
        _balance = sharedstate.getBalance(_id);
        return _balance;
    }

    // track history will listen anf filter the events created throughout the contracts
}