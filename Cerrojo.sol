// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.11;

import "forge-std/console.sol";
import "forge-std/Test.sol";
import "../src/Cerrojo.sol";


contract CerrojoTest is Test {
    Cerrojo public cerrojo;
    address public bob;


    function setUp() public {
        cerrojo = new Cerrojo();
        bob = makeAddr("bob");
        vm.startPrank(bob);
        vm.deal(bob, 50 ether);
    }

    function testFindTumbler1() public {

        uint256 passphrase = uint256(420);
        console.log("Tries1", cerrojo.tries());
        cerrojo.pick1(passphrase);
        console.log("Tumbler1", cerrojo.tumbler1());

        cerrojo.pick2{value: 0.000000000000000033 ether}();
        console.log("Tries2", cerrojo.tries());
        console.log("Tumbler2", cerrojo.tumbler2());


        console.log("Tries3", cerrojo.tries());

        
        bytes16 pick3Code = bytes16(keccak256(bytes("generateQRCode(string)")));
        cerrojo.pick3(pick3Code);
        console.log("Tumbler3", cerrojo.tumbler3());

        cerrojo.recoverFunds();

    }

}
