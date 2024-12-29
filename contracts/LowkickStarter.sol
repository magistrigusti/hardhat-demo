// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract LowkickStarter {
    struct LowkickCampaign {
        Campaign targetContract;
        bool claimed;
    }

    mapping(uint => LowkickCampaign) public campaigns;
    uint private currentCampaign;
    address owner;
    uint constant MAX_DURATION = 30 days;

    event CampaignStarted(uint id, uint endsAt, uint goal, address organizer);

    function start(uint _goal, uint _endsAt) external {
        require(_goal > 0, "Goal must be greater than 0");
        require(
            _endsAt <= block.timestamp + MAX_DURATION && _endsAt > block.timestamp,
            "Invalid end time"
        );

        currentCampaign = currentCampaign + 1;
        Campaign newCampaign = new Campaign(_endsAt, _goal, msg.sender, currentCampaign);

        campaigns[currentCampaign] = LowkickCampaign({
            targetContract: newCampaign,
            claimed: false
        });

        emit CampaignStarted(currentCampaign, _endsAt, _goal, msg.sender);
    }

    function onClaimed(uint id) external {
        LowkickCampaign storage targetCampaign = campaigns[id];
        require(msg.sender == address(targetCampaign.targetContract), "Unauthorized");
        targetCampaign.claimed = true;
    }
}

contract Campaign {
    uint public endsAt;
    uint public goal;
    uint public pledged;
    uint public id;
    address public organizer;
    LowkickStarter parent;
    bool public claimed;
    mapping(address => uint) public pledges;

    event Pledged(uint amount, address pledger);

    constructor(uint _endsAt, uint _goal, address _organizer, uint _id) {
        endsAt = _endsAt;
        goal = _goal;
        organizer = _organizer;
        parent = LowkickStarter(msg.sender);
        id = _id;
    }

    function pledge() external payable {
        require(block.timestamp <= endsAt, "Campaign ended");
        require(msg.value > 0, "Pledge must be greater than 0");

        pledged += msg.value;
        pledges[msg.sender] += msg.value;

        emit Pledged(msg.value, msg.sender);
    }

    function refundPledge() external {
        require(block.timestamp <= endsAt, "Cannot refund after campaign ended");

        uint amount = pledges[msg.sender];
        pledges[msg.sender] = 0;
        pledged -= amount;

        payable(msg.sender).transfer(amount);
    }

    function claim() external {
        require(block.timestamp > endsAt, "Campaign still active");
        require(msg.sender == organizer, "Only organizer can claim");
        require(pledged >= goal, "Goal not reached");
        require(!claimed, "Already claimed");

        claimed = true;
        payable(organizer).transfer(pledged);

        parent.onClaimed(id);
    }

    function fullRefund() external {
        require(block.timestamp > endsAt, "Campaign still active");
        require(pledged < goal, "Goal reached, cannot refund");

        uint refundAmount = pledges[msg.sender];
        pledges[msg.sender] = 0;
        payable(msg.sender).transfer(refundAmount);
    }
}
