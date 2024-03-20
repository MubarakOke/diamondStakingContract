// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import {LibAppStorage} from "../libraries/LibAppStorage.sol";
import "../interfaces/IERC20.sol";

contract ERC20Facet is IERC20 {
    LibAppStorage.Layout appStorage;

    function name() public view returns (string memory) {
        return appStorage._name;
    }

    function symbol() public view returns (string memory) {
        return appStorage._symbol;
    }

    function decimals() public view returns (uint8) {
        return appStorage._decimal;
    }

    function totalSupply() public view override returns (uint256) {
        return appStorage._totalSupply;
    }

    function totalSupply() public view override returns (uint256) {
        return appStorage._totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return appStorage._balances[account];
    }

    function transfer(address to, uint256 amount) public override returns (bool) {
        address owner = msg.sender;
        _transfer(owner, to, amount);
        return true;
    }

     function approve(address spender, uint256 amount) public override returns (bool) {
        address owner = msg.sender;
        _approve(owner, spender, amount);
        return true;
    }

    function _approve(address owner, address spender,uint256 amount) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        appStorage._allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function mint(address to, uint256 amount) external onlyOwner {
        ajidokwu.to = to;
        ajidokwu.amount = amount;
        require(ajidokwu.totalSupply + ajidokwu.amount >= ajidokwu.totalSupply, "OverFlow detected");
        ajidokwu.balances[to] += ajidokwu.amount;
        ajidokwu.totalSupply += ajidokwu.amount;
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        appStorage._totalSupply += amount;
        unchecked {
            // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
            appStorage._balances[account] += amount;
        }
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    function transferFrom(address from,address to,uint256 amount) public override returns (bool) {
        address spender = msg.sender;
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return appStorage._allowances[owner][spender];
    }

    function _transfer(address from, address to, uint256 amount) internal {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(from, to, amount);

        uint256 fromBalance = appStorage._balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            appStorage._balances[from] = fromBalance - amount;
            // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
            // decrementing then incrementing.
            appStorage._balances[to] += amount;
        }

        emit Transfer(from, to, amount);

        _afterTokenTransfer(from, to, amount);
    }

    function _beforeTokenTransfer(address from, address to,uint256 amount) internal {}

    function _afterTokenTransfer(address from, address to,uint256 amount) internal virtual {}

    function _spendAllowance(address owner, address spender, uint256 amount) internal {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }
}