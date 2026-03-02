// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AuctionHouse{
    bool public ended;
    uint public auctionEndTime;
    uint private highestBid;
    address private highestBidder;
    address public owner;
    string public item;

    mapping (address => uint) public bids;
    address[] public bidders;

    constructor(string memory _item, uint _biddingTime){
        owner = msg.sender;
        item = _item;
        auctionEndTime = block.timestamp + _biddingTime;
    }

    function getWinner() external view returns (address, uint){
        require(ended, "Auction not ended.");
        return (highestBidder, highestBid);
    }

    function endAuction() external {
        require(!ended, "Auction already ended.");
        require(block.timestamp >= auctionEndTime, "Auction not yet ended.");
        require(msg.sender == owner, "Only owner can end.");
        ended = true;
    }

    function bid(uint amount) external {
        require(block.timestamp < auctionEndTime, "Auction ended.");
        require(amount > highestBid, "Bid is too low.");

        if(bids[msg.sender] == 0){
            bidders.push(msg.sender);
        }

        if(bids[msg.sender] > highestBid){
            highestBid = bids[msg.sender];
            highestBidder = msg.sender;
        }
    }

    function getAllBidders() external view returns (address[] memory){
        return bidders;
    }
}