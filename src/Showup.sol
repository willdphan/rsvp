// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "contracts/IShowup.sol";

contract Showup is IShowup {
    
    address payable public organizer;
    uint256 public depositAmount;
    uint256 public attendanceCount;
    uint256 public RSVPFee;

    mapping (address => bool) public attendees;
    mapping (address => bool) public hasPaid;

    modifier NotRSVPd {
        if (attendees[msg.sender] != true) revert DidNotRSVP();
        _;
    }
    
    constructor() {
        organizer = payable(msg.sender);
    }

    function setRSVPFee(uint256 _RSVPFee) public {
        if (msg.sender != organizer) revert NotOrganizer();
        RSVPFee = _RSVPFee;
    }
    
    function RSVP() public payable {
        if (attendees[msg.sender]) revert AlreadyRSVP();
        if (msg.value == 0) revert ZeroAmount();
        attendees[msg.sender] = true;
        hasPaid[msg.sender] = true;
        depositAmount += msg.value;
        attendanceCount += 1;

        emit RSVPd(msg.sender);
    }
    
    function checkIn(address attendee) public payable {
        if (msg.sender != organizer) revert NotOrganizer();
        hasPaid[attendee] = true;

        emit CheckedIn(attendee);
    }
    
    function cancelRSVP() public payable NotRSVPd {
        if (hasPaid[msg.sender] != true) revert PayUpFool();
        attendees[msg.sender] = false;
        hasPaid[msg.sender] = false;
        depositAmount -= msg.value;
        attendanceCount -= 1;

        (bool sent,) = (msg.sender).call{value: msg.value}("");
        require(sent, "Failure, Ether not sent.");

        emit Canceled(msg.sender);
    }

    function withdraw() public NotRSVPd {
        if (hasPaid[msg.sender] != true) revert DidNotPay();
        hasPaid[msg.sender] = false;
        depositAmount -= RSVPFee;
        attendanceCount -= 1;
        
        (bool sent,) = (msg.sender).call{value: RSVPFee}("");
        require(sent, "Failure, Ether not sent.");
    }
}