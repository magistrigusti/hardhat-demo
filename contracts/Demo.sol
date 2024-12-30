// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;
import "./Access.sol";

contract Demo is AccessControl {
  bool paused;

  function withdraw() external {
    payable(msg.sender).transfer(address(this).balance);
  }

  function pause() external {
    paused = true;
  }
}