// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract CampaignFactory {
    address[] public deployedCampaigns;

    function createCampaign(uint minimum) public {
        Campaign newCampaign = new Campaign(minimum, msg.sender);
        deployedCampaigns.push(address(newCampaign));
    }

    function getDeployedCapmaigns() public view returns (address[] memory) {
        return deployedCampaigns;
    }
}

contract Campaign {
    struct Request {
        string desc;
        uint value;
        address payable recipient;
        bool complete;
        uint approvalCount;
        mapping(address => bool) approvals;
    }

    Request[] public requestsList;
    address public manager;
    uint public minContribution;
    mapping(address => bool) public approvers;
    uint public approversCount;

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    constructor (uint minimum, address creator) {
        manager = creator;
        minContribution = minimum;
    }

    function contribute() public payable {
        require(msg.value > minContribution);
        approvers[msg.sender] = true;
        approversCount++;
    }

    function createRequest(string memory desc, uint value, address payable recipient) restricted public {
        Request storage newRequest = requestsList.push();
        newRequest.desc = desc;
        newRequest.value = value; 
        newRequest.recipient = recipient;
        newRequest.complete = false;
        newRequest.approvalCount = 0;
    }

    function approveRequest(uint index) public {
        Request storage request = requestsList[index];

        require(approvers[msg.sender]);
        require(!request.approvals[msg.sender]);

        request.approvals[msg.sender] = true;
        request.approvalCount++;

    }

    function finalizeRequest(uint index) public restricted {
        Request storage request = requestsList[index];

        require(request.approvalCount > (approversCount / 2));
        require(!request.complete);

        request.recipient.transfer(request.value);
        request.complete = true;
    }

}