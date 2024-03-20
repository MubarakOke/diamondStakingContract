pragma solidity ^0.8.9;

library LibAppStorage {
    struct Layout {
        mapping(address => uint256)  _balances;

        mapping(address => mapping(address => uint256))  _allowances;

        uint256  _totalSupply;

        string  _name;

        string  _symbol;

        uint8 _decimal;
    }
}
