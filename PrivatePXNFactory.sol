

// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
//import "./TokenRegistry.sol";

contract VelasToken is ERC20 {
    
    string public tokenType  = "SimpleToken";
    
    uint8 custom_desimals = 18;
    
    constructor(string memory name, string memory ticker, uint8 _decimals, uint cap) ERC20(name, ticker) {
        
        require(_decimals >= 18 && _decimals > 0, "Range of deciamls is 1 - 18");
        
        custom_desimals = _decimals;
        _mint(msg.sender, cap);
    
        
    }
    
    function decimals() public view override returns (uint8) {
        return custom_desimals;
    }
}
