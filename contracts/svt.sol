// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "./institute.sol";

contract Web3Resume is IERC721, ERC721URIStorage, InstituteContract {
    address private _owner;

    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    //constructor of ERC721: name and symbol
    constructor() ERC721("Web3 Resume SVT", "W3RSVT") {}

    struct SVT {
        string institute_name; // address of institute
        string experience_type; //can be enum
        string title;
        string start_date;
        string end_date;
        string description;
    }

    function SVT_to_string(SVT memory exp) private pure returns (string memory) {
        return string(
            abi.encodePacked(
                "{institute_name:",
                exp.institute_name,
                "experience_type:",
                exp.experience_type,
                ", title:",
                exp.title,
                ", start_date:",
                exp.start_date,
                ", end_date:",
                exp.end_date,
                ", description:",
                exp.description,
                "}"
            )
        );
    }

    function mint(
        address receiver,
        string memory exp_type,
        string memory title,
        string memory description,
        string memory start_date,
        string memory end_date
    ) public onlyInstitute returns (bool) {
        address inst_address = msg.sender;
        string memory inst_name = institutes[inst_address].name;
        SVT memory experience_svt = SVT(inst_name, exp_type, title, start_date, end_date, description);
        _tokenIds.increment();
        uint256 newNftTokenId = _tokenIds.current();
        _mint(receiver, newNftTokenId);
        _setTokenURI(newNftTokenId, SVT_to_string(experience_svt));
        return true;
    }
}
