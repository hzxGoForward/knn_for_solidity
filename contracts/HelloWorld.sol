// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
import "./Good.sol";

contract HelloWorld {
    Good gd;
    uint32[2][] public array;

    constructor() public {
        gd = new Good();
        // array = new uint32[2][](0);
        array.push([0,0]);
        array.push([0,0]);
        array[0][1] = 1;
        array[1][1] = 2;
    }

    function sayHi() public pure returns (string memory) {
        return "Hello!";
    }

    function sayBye() public pure returns (string memory) {
        return "Bye!";
    }

    function sayGood() public view returns(string memory){
        return gd.sayGood();
    }

    function sayBad() public view returns(string memory){
        return gd.sayBad();
    }

    function getArrayLen() public view returns(uint256){
        uint256 len = array.length;
        return len;
    }

    function getArray()public view returns(uint32[2][]memory){
        return array;
    }
}
