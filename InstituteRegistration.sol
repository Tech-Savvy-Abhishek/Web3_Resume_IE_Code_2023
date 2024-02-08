// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


contract InstituteRegistration is Ownable {

    address[] public authorizedInstitutions;
    constructor(string memory _name, address _institution) Ownable(address(_institution)){
        //
    }
    event InstituteAdded(address indexed institution);
    event InstituteRemoved(address indexed institution);

    modifier onlyAuthorizedInstitution() {
        require(isAuthorizedInstitution(msg.sender), "Not an authorized institution");
        _;
    }

    function addInstitute(address _institution) external onlyOwner {
        authorizedInstitutions.push(_institution);
        emit InstituteAdded(_institution);
    }

    function removeInstitute(address _institution) external onlyOwner {
        for (uint256 i = 0; i < authorizedInstitutions.length; i++) {
            if (authorizedInstitutions[i] == _institution) {
                authorizedInstitutions[i] = authorizedInstitutions[authorizedInstitutions.length - 1];
                authorizedInstitutions.pop();
                emit InstituteRemoved(_institution);
                break;
            }
        }
    }

    function isAuthorizedInstitution(address _institution) public view returns (bool) {
        for (uint256 i = 0; i < authorizedInstitutions.length; i++) {
            if (authorizedInstitutions[i] == _institution) {
                return true;
            }
        }
        return false;
    }

    function getAllAuthorizedInstitutions() external view onlyOwner returns (address[] memory) {
        return authorizedInstitutions;
    }

    function updateInstituteAuthorization(address _institution, bool _authorized) external onlyOwner {
        // If _authorized is true and the institution is not in the list, add it
        if (_authorized && !isAuthorizedInstitution(_institution)) {
            authorizedInstitutions.push(_institution);
            emit InstituteAdded(_institution);
        }
        // If _authorized is false and the institution is in the list, remove it
        else if (!_authorized && isAuthorizedInstitution(_institution)) {
            for (uint256 i = 0; i < authorizedInstitutions.length; i++) {
                if (authorizedInstitutions[i] == _institution) {
                    authorizedInstitutions[i] = authorizedInstitutions[authorizedInstitutions.length - 1];
                    authorizedInstitutions.pop();
                    emit InstituteRemoved(_institution);
                    break;
                }
            }
        }
    }
}