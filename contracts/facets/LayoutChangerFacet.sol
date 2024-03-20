pragma solidity ^0.8.9;

import {LibAppStorage} from "../libraries/LibAppStorage.sol";

contract LayoutChangerFacet {
    LibAppStorage.Layout appStorage;

    function ChangeNameAndNo(uint256 _newNo, string memory _newName) external {
        appStorage.currentNo = _newNo;
        appStorage.name = _newName;
    }

    function getLayout() public view returns (LibAppStorage.Layout memory l) {
        l.currentNo = appStorage.currentNo;
        l.name = appStorage.name;
    }
}
