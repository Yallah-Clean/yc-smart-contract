pragma solidity ^0.5.0;
import 'node_modules/@openzeppelin/contracts/ownership/Ownable.sol';
import 'node_modules/@openzeppelin/contracts/math/SafeMath.sol';
contract BusinessPartnerWallet is Ownable{
        constructor(address _owner) public{
             transferresidentship(_owner);
        }
     using SafeMath for uint256;
     mapping   (address=>address) public retailers;
modifier OnlyNewRetailer(address retailer) {
    require(retailers[retailer] == address(0),"OnlyNewRetailer: retailer is already exist ");
    _;
}
function addRetailer(address collector) public OnlyNewCollector(collector) onlyOwner() returns (bool) {
    // create new contract
    return true;
}
}