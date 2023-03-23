// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AIYYToken.sol";

contract CheckIn {
    AIYYToken private _token;
    uint256 private _checkInReward = 100000000000000000;
    uint256 private _halfRewardAfter = 10000;
    uint256 private _totalCheckIns;

    mapping(address => uint256) private _lastCheckIn;
    mapping(address => uint256) private _userCheckIns;

    constructor(address tokenAddress) {
        _token = AIYYToken(tokenAddress);
    }

    function checkIn() public {
        require(_lastCheckIn[msg.sender] < block.timestamp - 1 days, "You can only check in once a day.");
        uint256 reward = _checkInReward;
        if (_userCheckIns[msg.sender] % _halfRewardAfter == 0 && _userCheckIns[msg.sender] != 0) {
            reward = reward / 2;
        }
        require(_token.balanceOf(address(this)) >= reward, "Not enough tokens available for check-in.");
        _token.transfer(msg.sender, reward);
        _lastCheckIn[msg.sender] = block.timestamp;
        _userCheckIns[msg.sender]++;
        _totalCheckIns++;
    }

    function getUserCheckIns(address user) public view returns (uint256) {
        return _userCheckIns[user];
    }

    function getLastCheckIn(address user) public view returns (uint256) {
        return _lastCheckIn[user];
    }
}
