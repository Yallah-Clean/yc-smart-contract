pragma solidity ^0.5.0;
import '../node_modules/@openzeppelin/contracts/ownership/Ownable.sol';
import '../node_modules/@openzeppelin/contracts/math/SafeMath.sol';

import './OrgRegistry.sol';

contract UserWallet is Ownable {
    using SafeMath for uint256;

    bool public isCollector;

    uint256 public raisedPoints;
    uint256 public currentPoints;
    OrgRegistry public  orgRegistry;

    event ResidentSendRequest( address indexed resident,bytes32 indexed _blockhash ,string  location,uint256 time);
    event CollectorSubmitRequest( address indexed collector,bytes32 indexed _blockhash ,string  location,uint256 time);

    constructor(address _owner, OrgRegistry _orgRegistry) public{
        orgRegistry = _orgRegistry;
        _transferOwnership(_owner);

    }
   modifier onlyCollector() {
        require(isCollector, "onlyCollector: caller does not have the Collector role");
        _;
    }
   modifier  onlyOrg() {
    require(!orgRegistry.isOwner(),"onlyOrg: caller does not have the YCOrg role");
        _;
    }



function approveCollector(bool status) public onlyOrg() returns (bool) {
        isCollector = status;

    return true;
}
    function residentSendRequest(string memory location,uint256 time)public onlyOwner() returns (bool) {
        emit  ResidentSendRequest(msg.sender,blockhash(block.number),location,time);
        return true;
    }
 
    function residentConfirm( uint256 bhash)public onlyOwner() returns (bool) {
        // redeem token based on his points; call org contract to redeem 
            uint256 points = orgRegistry.calcResidentPoints(orgRegistry.getDeliveredCode(bhash),orgRegistry.getDeliveredAmount(bhash));
            raisedPoints.add(points);
            points.add(currentPoints);
            currentPoints = points.mod(orgRegistry.rate());
            orgRegistry.confirmPickup(bhash, points.sub(currentPoints),owner());
            return true;
    }
   function collectorSubmitRequest(string memory location,uint256 time)public onlyCollector() returns (bool) {
        emit  CollectorSubmitRequest(msg.sender ,blockhash(block.number), location, time);
        return true;
    }
      function collectorAddDelivery(string memory location,uint256 time, uint256 code, uint256 amount,
      address _resident,uint256 mapHash)public onlyCollector() returns (bool) {
     require(orgRegistry.addDelivery( location, time,  code,  amount,
        _resident, mapHash ,owner()),"calling addDeliverables function has issues ");
        return true;
    }   
     function OrgConfirm( uint256 bhash)public onlyOrg() returns (bool) {
        // redeem token based on his points; call org contract to redeem 
            uint256 points = orgRegistry.calcCollectorPoints(orgRegistry.getDeliveredCode(bhash),orgRegistry.getDeliveredAmount(bhash));
            raisedPoints.add(points);
            points.add(currentPoints);
            currentPoints = points.mod(orgRegistry.rate());
            orgRegistry.validateDeliverables(bhash, points.sub(currentPoints),owner());
            return true;
    }
}