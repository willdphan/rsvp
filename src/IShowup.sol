// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

interface IShowup {
    error AlreadyRSVP();
    error ZeroAmount();
    error DidNotRSVP();
    error PayUpFool();
    error DidNotPay();
    error DidNotAttend();
    error NotOrganizer();

    event RSVPd (
        address indexed attendee
    );

    event CheckedIn (
        address indexed attendee
    );

    event Canceled (
        address indexed attendee
    );
}