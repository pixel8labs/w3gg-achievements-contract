// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {ERC721} from "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {ReentrancyGuard} from "openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol";
import {AccessControl} from "openzeppelin-contracts/contracts/access/AccessControl.sol";
import {Strings} from "openzeppelin-contracts/contracts/utils/Strings.sol";

contract W3GGAchievement is
    ERC721("W3GG Achievement SBT", "W3GG"),
    ReentrancyGuard,
    AccessControl
{
    bytes32 public constant EDITOR_ROLE = keccak256("EDITOR");
    string internal _baseTokenURI;

    event TokenMinted(address indexed wallet, uint256 tokenId);

    constructor(string memory _URI) {
        _baseTokenURI = _URI;
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }

    function setBaseURI(
        string calldata baseURI
    ) external onlyRole(EDITOR_ROLE) {
        _baseTokenURI = baseURI;
    }

    function mint(
        address wallet,
        uint256 tokenId
    ) external nonReentrant onlyRole(EDITOR_ROLE) {
        _safeMint(wallet, tokenId);
        emit TokenMinted(wallet, tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function _update(
        address to,
        uint256 tokenId,
        address auth
    ) internal virtual override returns (address) {
        address from = _ownerOf(tokenId);
        require(
            from == address(0) || to == address(0),
            "W3GG: token is SOUL BOUND"
        );
        return super._update(to, tokenId, auth);
    }
}
