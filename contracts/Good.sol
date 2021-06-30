// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Good {
    constructor()public {

    }

    function sayGood() public pure returns (string memory) {
        return "Good!";
    }

    function sayBad() public pure returns (string memory) {
        return "Bad!";
    }
}