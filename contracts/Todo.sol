// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract TodoEngine {
  address public owner;

  struct Todo {
    string title;
    string description;
    bool completed;
  }

  Todo[] todos;

  modifier onlyOwner() {
    require(msg.sender == owner, "not an owner!");
    _;
  }

  constructor() {
    owner = msg.sender;
  }

  function addTodo(string calldata _title, string calldata _description) external onlyOwner {
    todos.push(Todo({
      title: _title,
      description: _description,
      completed: false
    }));
  }

  function changeTodoTitle(string calldata _newTitle, uint index) external onlyOwner {
    todos[index].title = _newTitle;
  }

  function getTodo(uint index) external view onlyOwner returns(
    string memory, string memory, bool
  ) {
    Todo storage myTodo = todos[index];

    return (
      myTodo.title,
      myTodo.description,
      myTodo.completed
    );
  }

  function changeTodoStatus(uint index) external onlyOwner {
    todos[index].completed = !todos[index].completed;
  }

}