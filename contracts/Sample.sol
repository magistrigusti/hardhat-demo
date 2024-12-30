// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract Sample {
  uint256 a = 123;
  uint[] arr;

  mapping(address => uint) mapp;

  constructor() {
    arr.push(10);
    arr.push(20);
    mapp[address(this)] = 100;
  }
} 