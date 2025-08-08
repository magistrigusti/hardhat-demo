// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract TodoEngine {
  address public owner;

  struct Todo {
    string title;
    string descrition;
    bool completed;
  }

  Todo[] todos;
}