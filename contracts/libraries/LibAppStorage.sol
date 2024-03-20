pragma solidity ^0.8.9;

library LibAppStorage {
    struct Layout {
        mapping(address => uint256)  _balances;
        mapping(address => mapping(address => uint256))  _allowances;
        uint256  _totalSupply;
        string  _name;
        string  _symbol;
        uint8 _decimal;
        address _owner;
    }
    struct LayoutS {
        uint256 stakedBalance;
        address stakingTokenAdress;
        address rewardTokenAddress;
        uint256 stakingPeriod;
        uint256 stakingStartTime;
        uint256 APY;
        address stakingToken;
        address rewardToken;
        mapping(address=>uint256) staked;
        mapping(address=>uint256) reward;
    }
}
