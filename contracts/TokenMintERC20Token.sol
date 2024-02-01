// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.5.0;

import "./ERC20.sol";

/**
 * @title TokenMintERC20Token
 *
 * @dev Standard ERC20 token with burning and optional functions implemented.
 * For full specification of ERC-20 standard see:
 * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
 */
contract TokenMintERC20Token is ERC20 {

    string private _name; 
    string private _symbol; 
    uint8 private _decimals;

    address public _tokenOwnerAddress;

    // Add transfer restriction for 72 hours
    uint public _launchTime;

    mapping (address => bool) whitelisted;

    modifier onlyOwner() {
      require(msg.sender == _tokenOwnerAddress, "Only owner can call this function");
      _;
    }

    /**
     * @dev Constructor.
     * @param name name of the token
     * @param symbol symbol of the token, 3-4 chars is recommended
     * @param decimals number of decimal places of one token unit, 18 is widely used
     * @param totalSupply total supply of tokens in lowest units (depending on decimals)
     * @param tokenOwnerAddress address that gets 100% of token supply
     */
    constructor(uint256 totalSupply, string memory name, string memory symbol, uint8 decimals, address payable feeReceiver, address tokenOwnerAddress, uint launchTime) public payable {

      _name = name;
      _symbol = symbol;
      _decimals = decimals;
      _tokenOwnerAddress = tokenOwnerAddress;
      _launchTime = launchTime;

      // set tokenOwnerAddress as owner of 40% of tokens
      _mint(_tokenOwnerAddress, totalSupply * 40 / 100);

      // mint 15% of tokens to each of the other wallet addresses
      _mint(0xE7f3CEcEa27bD71c4F5672fd30Bf33715ECA4142, totalSupply * 15 / 100);
      _mint(0x281c45cCB6f83f6e8D7D84c3768c8DEC72c3f0d4, totalSupply * 15 / 100);
      _mint(0xb937DaCc4D1D3c89dB4113A568F24A002d98E3fD, totalSupply * 15 / 100);
      _mint(0x35A43Bcd3d78787e7EE7B72B5a75e4AfD537a776, totalSupply * 15 / 100);

      // pay the service fee for contract deployment
      feeReceiver.transfer(msg.value);
    }

    /**
     * @dev Burns a specific amount of tokens.
     * @param value The amount of lowest token units to be burned.
     */
    function burn(uint256 value) public {
      _burn(msg.sender, value);
    }

    // TRANSFER FROM NEED to be added
    function transfer(address to, uint256 value) public returns (bool) {
      require(block.timestamp - _launchTime >= 72 hours || whitelisted[msg.sender], "Transfer restricted for 72 hours after launch");

      _transfer(msg.sender, to, value);
      return true;
    }

    function whitelistAddresses(
        address[] memory addresses
    ) public onlyOwner {
        for (uint i = 0; i < addresses.length; i++) {
            whitelisted[addresses[i]] = true;
        }
    }

    function removeWhitelistAddresses(
        address[] memory addresses
    ) public onlyOwner {
        for (uint i = 0; i < addresses.length; i++) {
            whitelisted[addresses[i]] = false;
        }
    }

    // optional functions from ERC20 standard

    /**
     * @return the name of the token.
     */
    function name() public view returns (string memory) {
      return _name; 
    }

    /**
     * @return the symbol of the token.
     */
    function symbol() public view returns (string memory) {
      return _symbol;
    }

    /**
     * @return the number of decimals of the token.
     */
    function decimals() public view returns (uint8) {
      return _decimals;
    }
}