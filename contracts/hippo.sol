// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract HippoToken {
    string public name = "Hippo";           // 代币名称
    string public symbol = "HP";             // 代币符号
    uint8 public decimals = 12;               // 代币精度，12 位小数
    uint256 public totalSupply = 160000000 * 10 ** uint256(decimals);  // 总供应量 1 亿 6 千万枚，考虑精度

    mapping(address => uint256) public balanceOf;      // 地址到余额的映射
    mapping(address => mapping(address => uint256)) public allowance;  // 授权映射，允许 spender 从 owner 账户转账

    // 事件声明
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor() {
        balanceOf[msg.sender] = totalSupply;  // 初始供应量分配给合约创建者
    }

    // 转账函数
    function transfer(address to, uint256 amount) public returns (bool) {
        require(to != address(0), "Invalid address");  // 目标地址不能为零地址
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");  // 检查发送者余额

        balanceOf[msg.sender] -= amount;      // 扣除发送者余额
        balanceOf[to] += amount;              // 增加接收者余额

        emit Transfer(msg.sender, to, amount);  // 发出转账事件
        return true;
    }

    // 授权函数
    function approve(address spender, uint256 amount) public returns (bool) {
        require(spender != address(0), "Invalid address");  // 授权者地址不能为零地址

        allowance[msg.sender][spender] = amount;  // 设置授权金额
        emit Approval(msg.sender, spender, amount);  // 发出授权事件
        return true;
    }

    // 从授权账户转账函数
    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        require(from != address(0), "Invalid address");  // 发送者地址不能为零地址
        require(to != address(0), "Invalid address");    // 目标地址不能为零地址
        require(balanceOf[from] >= amount, "Insufficient balance");  // 检查发送者余额
        require(allowance[from][msg.sender] >= amount, "Allowance exceeded");  // 检查是否有足够的授权余额

        balanceOf[from] -= amount;                      // 扣除发送者余额
        balanceOf[to] += amount;                        // 增加接收者余额
        allowance[from][msg.sender] -= amount;          // 扣除授权额度

        emit Transfer(from, to, amount);                // 发出转账事件
        return true;
    }
}
