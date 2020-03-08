pragma solidity ^0.5.0;

import "node_modules/@openzeppelin/contracts/access/Roles.sol";

contract YCAdminRole  {
    using Roles for Roles.Role;

    event YCAdminAdded(address indexed account);
    event YCAdminRemoved(address indexed account);

    Roles.Role private _YCAdmins;

    constructor () public {
        _addYCAdmin(msg.sender);
    }

    modifier onlyYCAdmin() {
        require(isYCAdmin(msg.sender), "YCAdminRole: caller does not have the YCAdmin role");
        _;
    }

    function isYCAdmin(address account) public view returns (bool) {
        return _YCAdmins.has(account);
    }

    function addYCAdmin(address account) public onlyYCAdmin {
        _addYCAdmin(account);
    }

    function renounceYCAdmin() public {
        _removeYCAdmin(msg.sender);
    }

    function _addYCAdmin(address account) internal {
        _YCAdmins.add(account);
        emit YCAdminAdded(account);
    }

    function _removeYCAdmin(address account) internal {
        _YCAdmins.remove(account);
        emit YCAdminRemoved(account);
    }
}
