// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "PCD/contractS/MyToken.sol";
import "PCD/contractS/Magasin.sol";
import "PCD/contractS/SharedState.sol";
// zid l sharedstate
// i used factory design pattern where admin is tokens_factory
// also it is the factory of magasin contract
contract Admin {
    mapping (string => address) public storeToTokens; // maps store's name to their token contract
    mapping (string => address)public storeToMagasin; // maps store's name to their magasin contract
    mapping (string => address) public storeToSharedState; 
    address[] public deployedTokens;
   
    
    // *1 mints tockens for the new store
    function createToken(string memory name, string memory symbol, uint256 initialSupply) public returns(address) {
        MyToken newToken = new MyToken(name, symbol, initialSupply);
        
        deployedTokens.push(address(newToken));
        storeToTokens[name]=address(newToken);
        return address(newToken);

    }
    
    //*2
    function createSharedState (string memory store_name) public returns(address){
        SharedState newState = new SharedState(store_name);
        storeToSharedState[store_name]= address(newState);
        return address(newState);
    }

    //*3
    function createStore (string memory store_name, address sharedStateAddress) public returns(address){
        Magasin newStore= new Magasin(store_name,sharedStateAddress);
        storeToMagasin[store_name]= address(newStore);
        return address(newStore);
    }

    //4* gives the store the address of the minted tockens contract and the Magazin contract 
    //so it can interact with them
    function giveAccessRights(string memory _to) public view returns (address, address, address) {
        return (storeToMagasin[_to], storeToTokens[_to], storeToSharedState[_to]);
        }
     function getDeployedTokens() public view returns (address[] memory) {
        return deployedTokens;
    }
}
