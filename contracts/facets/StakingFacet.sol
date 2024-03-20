// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "../interfaces/IERC20.sol";
import {LibAppStorage} from "../libraries/LibAppStorage.sol";

contract StakingFacet {
    LibAppStorage.LayoutS appStorage;

    event Staked(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);

    error ZERO_ACCOUNT_DETECTED();
    error NO_CONTRIBUTION();
    error ZERO_STAKING_DETECTED();
    error CLAIM_FAILED();
    error STAKING_FAILED();
    error UNSTAKING_FAILED();
    error ALREADY_STAKED();
    error STAKING_PERIOD_STILL_ON();

    constructor(address _tokenAddress, address _rewardAddress){
        appStorage.stakingTokenAdress= _tokenAddress;
        appStorage.rewardTokenAddress= _rewardAddress;
        appStorage.stakingStartTime = block.timestamp;
    }

    function stake(uint256 _amount) external returns(bool){
        if(msg.sender == address(0)){revert ZERO_ACCOUNT_DETECTED();}
        if(_amount <= 0){revert ZERO_STAKING_DETECTED();}
        if(appStorage.staked[msg.sender]!=0){revert ALREADY_STAKED();}
        if(!IERC20(appStorage.stakingTokenAdress).transferFrom(msg.sender, address(this), _amount)){revert STAKING_FAILED();}
        appStorage.stakedBalance= appStorage.stakedBalance + _amount;
        appStorage.staked[msg.sender]= appStorage.staked[msg.sender] + _amount;

        return true;
    }

    function unstake() external returns(bool){
        if (block.timestamp < appStorage.stakingPeriod){revert STAKING_PERIOD_STILL_ON();}

        uint256 _stakedAmount = appStorage.staked[msg.sender];
        if (_stakedAmount==0){revert NO_CONTRIBUTION();}

        appStorage.staked[msg.sender] = appStorage.staked[msg.sender] - _stakedAmount;
        appStorage.stakedBalance = appStorage.stakedBalance - _stakedAmount;
        
        if (!IERC20(appStorage.stakingTokenAdress).transfer(msg.sender, _stakedAmount)){revert UNSTAKING_FAILED();}
        return true;
    }


    function claimReward() external returns(bool){
        uint256 _stakedAmount = appStorage.staked[msg.sender];
        if (_stakedAmount==0){revert NO_CONTRIBUTION();}

        uint256 userStakedAmount = appStorage.staked[msg.sender];
        uint256 calculatedReward= calculateRewards(userStakedAmount);
        if (!IERC20(appStorage.rewardTokenAddress).transfer(msg.sender, calculatedReward)){revert CLAIM_FAILED();}

        return true;
    }

    function checkUserStakedBalance(address _user) external view returns(uint256){
        return appStorage.staked[_user];
    }

    function totalStakedBalance() external view returns(uint256){
        return appStorage.stakedBalance;
    }

    function calculateRewards(uint256 stakedAmount) public view returns (uint256) {
        uint256 timeStaked = block.timestamp - appStorage.stakingStartTime;
        uint256 rewardPerYear = stakedAmount * appStorage.APY / 100; 
        uint256 rewards = rewardPerYear * timeStaked / 365 days;
        return rewards;
    }
}