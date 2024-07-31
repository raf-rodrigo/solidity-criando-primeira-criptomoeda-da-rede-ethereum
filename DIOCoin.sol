// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0; // adicionando o compilador

interface IERC20 { // craindo a interface no padrão IERC20
    
    function totalSupply() external view returns (uint256); // suplimento total de tokens no contrato. 

    function balanceOf(address account) external view returns (uint256); // checa o saldo de um determinado endereço 

    function allowance(address owner, address spender) external view returns (uint256); // retorna allow - verificando o limite definido e qual o limite atual

    function transfer(address recipient, uint256 amount) external returns (bool); // transferencia de token

    function approve(address spender, uint256 amount) external returns (bool);  // aprovar uma transação de alguem que foi delegado uma função de gastar um determinado saldo 

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool); // é eu gastar esse allowance

    // eventos que são disparados em algumas situações
    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, int256);
    
}

contract DIOCoin is IERC20 {

    string public constant name = "DIO Coin"; // nome da moeda
    string public constant symbol = "DIO"; // símbolo da moeda
    uint8 public constant decimals = 18; // quantidade de casa decimais

    mapping (address => uint256) balances;

    mapping (address => mapping (address=>uint256)) allowed;

    uint256 totalSupply_ = 10 ether;

    constructor(){
        balances[msg.sender] = totalSupply_;
    }

    // retorna o suplimento total
    function totalSupply() public override view returns (uint256){
        return totalSupply_;
    }

    // Metódo que retrona o balance
    function balanceOf(address tokenOwner) public override view returns (uint256) {
        return balances[tokenOwner]; 
    }

    // Função de transferência de tokens
    function transfer(address receiver, uint256 numTokens) public override returns (bool){
        require (numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender] - numTokens;
        balances[receiver] = balances[receiver] + numTokens;
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    } 

    function approve(address delegate, uint256 numTokens) public override returns(bool){
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    //  Qaunto foi delegado para um determinado endereço
    function allowance(address owner, address delegate) public override view returns (uint) {
        return  allowed[owner][delegate];
    }

    function transferFrom(address owner, address buyer, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] = balances[owner] - numTokens;
        allowed[owner][msg.sender] = allowed[owner][msg.sender] - numTokens;
        balances[buyer] = balances[buyer] + numTokens;
        emit Transfer(owner, buyer, numTokens);
        return true;
    }

}
