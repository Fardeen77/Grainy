// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Grainy{
    uint public listedItemsCount;
    uint public donatedItemsCount;

    struct details{
        address sender;
        address receiver;
        string eventName;
        string placeAddress;
        uint256 phoneNo;
        bool donated;
    }

    mapping(address=>details) public address_details;
    details[] allDetailsOfItems;

    function listItem(string memory _eventName, string memory _placeAddress, uint _phoneNo)public {
        address_details[msg.sender] = details(
            msg.sender,
            address(0),
            _eventName,
            _placeAddress,
            _phoneNo,
            false
        );  
        allDetailsOfItems.push(address_details[msg.sender]);    
        listedItemsCount++; 
    }

    function getListedItems()public view returns(details [] memory){
        uint length = allDetailsOfItems.length - donatedItemsCount;
        details[] memory listedItems = new details[](length) ;
        uint currentIndex = 0;
        for(uint i=0; i<allDetailsOfItems.length; i++){
            if(!allDetailsOfItems[i].donated){
                listedItems[currentIndex] = allDetailsOfItems[i];
                currentIndex++;
            }
        }
        return listedItems;
    }

    function removeItem(address user)public{
        for(uint256 i=0; i<allDetailsOfItems.length; i++){
            if(allDetailsOfItems[i].sender == user){
                allDetailsOfItems[i].receiver = msg.sender;
                allDetailsOfItems[i].donated = true;
            }
        }
        donatedItemsCount++;
    }

    function getDeliveredItems()public view returns(details [] memory){
        require(donatedItemsCount>0, "Nothing to display");
        details[] memory deliveredItems = new details[](donatedItemsCount) ;
        uint currentIndex = 0;
        for(uint i=0; i<allDetailsOfItems.length; i++){
            if(allDetailsOfItems[i].donated){
                deliveredItems[currentIndex] = allDetailsOfItems[i];
                currentIndex++;
            }
        }
        return deliveredItems;
    }
}