// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Sinus is ERC20, ERC20Burnable, ERC20Pausable, Ownable {
    mapping(address => bool) public whitelisted;
    uint launchTime;
    uint8 decimals;

    constructor(string memory _name, string memory _symbol, uint8 _decimals, uint _launchTime) ERC20(_name, _symbol) {
        require(_launchTime > block.timestamp, "Launch time must be in the future");
        launchTime = _launchTime;
        decimals = _decimals;

        _mint(
            0xf642b5aB694F3D6DE82FBac53FECd1d66a67DBEb,
            (40 * 100_000_000 * 10 ** decimals) / 100
        );
        _mint(
            0xE7f3CEcEa27bD71c4F5672fd30Bf33715ECA4142,
            (15 * 100_000_000 * 10 ** decimals) / 100
        );
        _mint(
            0x281c45cCB6f83f6e8D7D84c3768c8DEC72c3f0d4,
            (15 * 100_000_000 * 10 ** decimals) / 100
        );
        _mint(
            0xb937DaCc4D1D3c89dB4113A568F24A002d98E3fD,
            (15 * 100_000_000 * 10 ** decimals) / 100
        );
        _mint(
            0x35A43Bcd3d78787e7EE7B72B5a75e4AfD537a776,
            (15 * 100_000_000 * 10 ** decimals) / 100
        );

        whitelistAddresses([
                0xf642b5aB694F3D6DE82FBac53FECd1d66a67DBEb,
                0xE7f3CEcEa27bD71c4F5672fd30Bf33715ECA4142,
                0x281c45cCB6f83f6e8D7D84c3768c8DEC72c3f0d4,
                0xb937DaCc4D1D3c89dB4113A568F24A002d98E3fD,
                0x35A43Bcd3d78787e7EE7B72B5a75e4AfD537a776
            ]);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function whitelistAddresses(
        address[] calldata addresses
    ) public onlyOwner {
        for (uint i = 0; i < addresses.length; i++) {
            whitelisted[addresses[i]] = true;
        }
    }

    function removeWhitelistAddresses(
        address[] calldata addresses
    ) public onlyOwner {
        for (uint i = 0; i < addresses.length; i++) {
            whitelisted[addresses[i]] = false;
        }
    }

    function decimals() public view virtual override returns (uint8) {
        return decimals;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20, ERC20Pausable) {
        require(
            from == address(0) ||
                whitelisted[from] ||
                block.timestamp - launchTime >= 72 hours ||
                to == address(0),
            "Transfer not allowed"
        );
        _beforeTokenTransfer(from, to, amount);
    }
}
