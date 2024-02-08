// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./InstituteRegistration.sol"; // Import InstituteRegistration.sol
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract SelfValidatingToken is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {

    using Strings for uint256;

    address public issuer;

    mapping(uint256 => address) public credentials;
    mapping(uint256 => string) public data;

constructor(string memory _name, string memory _symbol, address _issuer) ERC721(_name, _symbol) Ownable(_issuer) {
    issuer = _issuer;
}
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable, ERC721URIStorage) returns (bool) {
    return super.supportsInterface(interfaceId);
}
   function _update(address to, uint256 tokenId, address) internal virtual override(ERC721, ERC721Enumerable) returns (address) {
    super._update(to, tokenId, address(0)); // Call the overridden function from ERC721Enumerable
    return to; // Return the updated address
}
 function _increaseBalance(address account, uint128 amount) internal virtual override(ERC721, ERC721Enumerable) {
        super._increaseBalance(account, amount); // Call the overridden function from ERC721Enumerable
        // Additional implementation specific to SelfValidatingToken
    }
    function tokenURI(uint256 tokenId) public view virtual override(ERC721, ERC721URIStorage) returns (string memory) {
    require(_exists(tokenId), "Token does not exist");
    return super.tokenURI(tokenId);
}
    event TokenDataUpdated(uint256 indexed tokenId, string tokenData);

    function _setTokenData(uint256 _tokenId, string memory _tokenData) internal {
        data[_tokenId] = _tokenData;
        emit TokenDataUpdated(_tokenId, _tokenData);
    }

    function _getTokenData(uint256 _tokenId) internal view returns (string memory) {
        return data[_tokenId];
    }

    function mint(address _recipient, uint256 _tokenId, string memory _tokenData) external onlyOwner {
        _safeMint(_recipient, _tokenId);
        _setTokenData(_tokenId, _tokenData);
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        return ownerOf(tokenId) != address(0);
    }

    function setTokenData(uint256 _tokenId, string memory _tokenData) external onlyOwner {
        require(_exists(_tokenId), "Token does not exist");
        _setTokenData(_tokenId, _tokenData);
    }

    function getTokenData(uint256 _tokenId) external view returns (string memory) {
        require(_exists(_tokenId), "Token does not exist");
        return _getTokenData(_tokenId);
    }

    function mintCredential(address _holder, string memory _credentialURI) external {
        require(msg.sender == issuer, "Only issuer can mint credentials");
        require(!_exists(totalSupply() + 1), "Token already exists");

        uint256 tokenId = totalSupply() + 1;

        _safeMint(_holder, tokenId);
        _setTokenURI(tokenId, _credentialURI);
        credentials[tokenId] = _holder;
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes memory _data
    ) public override(ERC721, IERC721) onlyOwner {
        super.safeTransferFrom(_from, _to, _tokenId, _data);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public override(ERC721, IERC721) onlyOwner {
        super.transferFrom(_from, _to, _tokenId);
    }

    function approve(address _approved, uint256 _tokenId) public override(ERC721, IERC721) onlyOwner {
        super.approve(_approved, _tokenId);
    }

    function setApprovalForAll(address _operator, bool _approved) public override(ERC721, IERC721) onlyOwner {
        super.setApprovalForAll(_operator, _approved);
    }

    function getApproved(uint256 _tokenId) public view override(ERC721, IERC721) returns (address) {
        return super.getApproved(_tokenId);
    }

    function isApprovedForAll(address _owner, address _operator) public view override(ERC721, IERC721) returns (bool) {
        return super.isApprovedForAll(_owner, _operator);
    }
}