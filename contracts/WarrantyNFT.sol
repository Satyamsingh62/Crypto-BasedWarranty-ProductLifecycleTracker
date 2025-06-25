// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.8.0/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.8.0/contracts/access/Ownable.sol";

contract WarrantyNFT is ERC721URIStorage, Ownable {
    uint256 public tokenIdCounter;

    struct WarrantyDetails {
        uint256 expiryTimestamp;
        string productSerial;
    }

    mapping(uint256 => WarrantyDetails) public warranties;

    event WarrantyMinted(address indexed to, uint256 tokenId, string serial, uint256 expiry);

    constructor() ERC721("ProductWarrantyNFT", "PWNFT") {}

    function mintWarranty(
        address recipient,
        string memory uri,
        string memory serial,
        uint256 expiryTimestamp
    ) public onlyOwner returns (uint256) {
        require(expiryTimestamp > block.timestamp, "Expiry must be in future");

        tokenIdCounter += 1;
        uint256 newTokenId = tokenIdCounter;

        _mint(recipient, newTokenId);
        _setTokenURI(newTokenId, uri);

        warranties[newTokenId] = WarrantyDetails({
            expiryTimestamp: expiryTimestamp,
            productSerial: serial
        });

        emit WarrantyMinted(recipient, newTokenId, serial, expiryTimestamp);
        return newTokenId;
    }

    function isWarrantyValid(uint256 tokenId) public view returns (bool) {
        require(_exists(tokenId), "Invalid token ID");
        return block.timestamp <= warranties[tokenId].expiryTimestamp;
    }
}
