// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattles is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;

    enum NFTAttributes {
        LEVEL,
        SPEED,
        STRENGTH,
        LIFE
    }
    struct NFTLevels {
        uint256 level;
        uint256 speed;
        uint256 strength;
        uint256 life;
    }

    Counters.Counter private _tokenIds;
    mapping(uint256 => NFTLevels) public nftLevels;

    constructor() ERC721("Chain Battles", "CBTLS") {}

    function generateCharacter(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            "<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>",
            '<rect width="100%" height="100%" fill="black" />',
            '<circle cx="50%" cy="50%" r="70" stroke="white" stroke-width="3" fill="red" />',
            '<text x="10%" y="5%" class="base" dominant-baseline="middle" text-anchor="middle">Warrior</text>',
            '<text x="5%" y="80%" class="base" dominant-baseline="middle" text-anchor="left">Level: ',
            getLevel(tokenId, NFTAttributes.LEVEL),
            "</text>",
            '<text x="5%" y="85%" class="base" dominant-baseline="middle" text-anchor="left">Speed: ',
            getLevel(tokenId, NFTAttributes.SPEED),
            "</text>",
            '<text x="5%" y="90%" class="base" dominant-baseline="middle" text-anchor="left">Strength: ',
            getLevel(tokenId, NFTAttributes.STRENGTH),
            "</text>",
            '<text x="5%" y="95%" class="base" dominant-baseline="middle" text-anchor="left">Life: ',
            getLevel(tokenId, NFTAttributes.LIFE),
            "</text>",
            "</svg>"
        );

        return
            string(
                abi.encodePacked(
                    "data:image/svg+xml;base64,",
                    Base64.encode(svg)
                )
            );
    }

    function getLevel(uint256 tokenId, NFTAttributes attribute)
        public
        view
        returns (string memory)
    {
        require(_exists(tokenId), "Not found");
        NFTLevels memory levels = nftLevels[tokenId];

        if (attribute == NFTAttributes.LEVEL) return levels.level.toString();
        if (attribute == NFTAttributes.SPEED) return levels.speed.toString();
        if (attribute == NFTAttributes.STRENGTH)
            return levels.strength.toString();
        if (attribute == NFTAttributes.LIFE) return levels.life.toString();
        return "-1";
    }

    function getTokenURI(uint256 tokenId) public view returns (string memory) {
        bytes memory dataURI = abi.encodePacked(
            "{",
            '"name": "Chain Battles #',
            tokenId.toString(),
            '",',
            '"description": "Battles on chain",',
            '"image": "',
            generateCharacter(tokenId),
            '"',
            "}"
        );

        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(dataURI)
                )
            );
    }

    function mint() public {
        _tokenIds.increment();
        uint256 nftId = _tokenIds.current();
        _safeMint(msg.sender, nftId);

        nftLevels[nftId] = NFTLevels(0, 0, 0, 0);

        _setTokenURI(nftId, getTokenURI(nftId));
    }

    function train(uint256 tokenId) public {
        require(_exists(tokenId), "Not found");
        require(ownerOf(tokenId) == msg.sender, "You do not own this NFT");

        NFTLevels memory currentLevels = nftLevels[tokenId];
        nftLevels[tokenId].level = currentLevels.level + 1;
        nftLevels[tokenId].speed = currentLevels.speed + 1;
        nftLevels[tokenId].strength = currentLevels.strength + 1;
        nftLevels[tokenId].life = currentLevels.life + 1;

        _setTokenURI(tokenId, getTokenURI(tokenId));
    }
}
