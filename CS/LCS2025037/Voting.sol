//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting{
    struct Vote{
        address Voter;
        uint candidate_no;
    }

    Vote[] public votes;

    uint public candidate1_votes = 0;
    uint public candidate2_votes = 0;
    uint public total_votes=0;
    uint public result;
    
    address public owner;
    uint public max_votes;
    constructor(uint _max_votes){
        owner = msg.sender;
        max_votes = _max_votes;
    }

    modifier onlyOwner{
        require(msg.sender == owner, "Not Contract Owner");
        _;
    }

    string public candidate1_name;
    string public candidate2_name;
    bool public candidate_set=false;
    bool public voting_start=false;
    bool public voting_ended=false;

    function set_candidate_name(string memory _candidate1, string memory _candidate2) onlyOwner public {
        require(candidate_set==false, "Candidate names are already set");
        candidate1_name=_candidate1;
        candidate2_name=_candidate2;
        candidate_set=true;
        voting_start=true;
    }

    function put_vote(uint candidate_no) public {
        require(candidate_set==true, "Candidate names not set");
        require(voting_start==true, "voting not start");
        require(candidate_no == 1 || candidate_no == 2, "Invalid candiate no");

        votes.push(Vote((msg.sender), candidate_no));

        if(candidate_no == 1) candidate1_votes++;
        else candidate2_votes++;

        total_votes++;
    }

    function close_voting() public onlyOwner {
        require(voting_start==true, "Voting Already Closed!");
        voting_start=false;
    }

    function declare_result() public onlyOwner {
        require(voting_start==false, "Voting is still open");

        if(candidate1_votes > candidate2_votes) result = 1;
        else result = 2;

        voting_ended = true;
    }


}