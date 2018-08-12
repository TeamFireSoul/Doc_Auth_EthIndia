pragma solidity ^0.4.24;

import "./RBAC.sol";


/**
 * @title RBAC (Role-Based Access Control)
 * @author Matt Condon (@Shrugs)
 * @dev Stores and provides setters and getters for roles and addresses.
 * Supports unlimited numbers of roles and addresses.
 * See //contracts/mocks/RBACMock.sol for an example of usage.
 * This RBAC method uses strings to key roles. It may be beneficial
 * for you to write your own implementation of this interface using Enums or similar.
 */
contract DoctorRegistry is RBAC {

  struct DoctorInfo {
    string name,
    string info,
  }

  mapping (address => DoctorInfo) doctors;

  function editDoctorInfo(string _name, string _info) onlyRole("DOCTOR") {
    DoctorInfo memory info = (_name, _info);
    doctors[msg.sender] = info;
    DoctorEditedInfo(msg.sender, _name, _info);
  }

}
