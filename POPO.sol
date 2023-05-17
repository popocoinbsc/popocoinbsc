// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract POPO {
    string public name = "POPO";
    string public symbol = "POPO";
    uint8 public decimals = 18;
    uint256 public totalSupply = 210345000000000 * (10**uint256(decimals));
    address public owner;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event Burn(address indexed from, uint256 value);

    constructor() {
        owner = msg.sender;
        balanceOf[msg.sender] = totalSupply;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function transfer(address _to, uint256 _value) external returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");

        _transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "Not allowed to transfer this amount");

        _transfer(_from, _to, _value);
        _approve(_from, msg.sender, allowance[_from][msg.sender] - _value);
        return true;
    }

    function approve(address _spender, uint256 _value) external returns (bool success) {
        _approve(msg.sender, _spender, _value);
        return true;
    }

    function burn(uint256 _value) external returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");

        balanceOf[msg.sender] -= _value;
        totalSupply -= _value;
        emit Burn(msg.sender, _value);
        return true;
    }

    function increaseAllowance(address _spender, uint256 _addedValue) external returns (bool success) {
        _approve(msg.sender, _spender, allowance[msg.sender][_spender] + _addedValue);
        return true;
    }

    function decreaseAllowance(address _spender, uint256 _subtractedValue) external returns (bool success) {
        uint256 currentAllowance = allowance[msg.sender][_spender];
        require(currentAllowance >= _subtractedValue, "Allowance cannot be decreased below zero");

        _approve(msg.sender, _spender, currentAllowance - _subtractedValue);
        return true;
    }

    function renounceOwnership() external onlyOwner {
        owner = address(0);
        emit OwnershipTransferred(owner, address(0));
    }

    function transferOwnership(address _newOwner) external onlyOwner {
        require(_newOwner != address(0), "New owner cannot be zero address");

        address previousOwner = owner;
        owner = _newOwner;
        emit OwnershipTransferred(previousOwner, owner);
    }

    function _transfer(address _from, address _to, uint256 _value) internal {
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
    }

   function _approve(address _owner, address _spender, uint256 _value) internal {
        allowance[_owner][_spender] = _value;
        emit Approval(_owner, _spender, _value);
    }
}
