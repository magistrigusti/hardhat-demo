// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract Sample {
  uint demo = 42;
  string public message;
  address public caller;

  function get() public view returns(uint) {
    return demo;
  }

  function pay(string memory _message) public payable {
    demo = msg.value;
    message = _message;
  }

  function callError() public pure {
    assert(false);
  }

  function callMe() public {
    caller = msg.sender;
  }
}