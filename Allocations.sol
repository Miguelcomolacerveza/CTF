// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.11;

import "forge-std/console.sol";
import "forge-std/Test.sol";
import "../src/Allocations.sol";

contract Attacker {
    constructor() payable {
    }
     receive() external payable {} // added for the contract to directly receive funds
}

contract AllocationsTest is Test {
    Allocations public allocations;
    Attacker public attacker;
    address public bob;

    function setUp() public {
        bob = makeAddr("bob");
        vm.startPrank(bob);
        vm.deal(bob, 10 ether);
        
        allocations = new Allocations{value: 1 ether}();
        (bool sent1, ) = address(attacker).call{value: 3 ether}("");
        require(sent1, "Fail ether transfer");   
    }

    function testAllocation() public {
        allocations.allocate{value: 1 ether}();
        allocations.sendAllocation(payable(attacker));
        allocations.takeMasterRole();
        allocations.collectAllocations();        
    }
}
