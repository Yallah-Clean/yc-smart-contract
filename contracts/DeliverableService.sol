pragma solidity ^0.5.0;


contract DeliverableService  {

    struct SubmissionDetails{
        address collector;
        address residnet;
        uint256 code;
        uint256 amount;
        bool delivered;
        bool paid;
        uint256 time;
        string location;
    }
    // uint256block hash to SubmissionDetails 
    // block hash might lead to vulnerabilty , so later on we should consider using unique hash for the pacakges for example 
    mapping (uint256=>SubmissionDetails) public trashsubmission;


function getDeliveredAmount(uint256 bhash) public view returns (uint256 ) {
   return trashsubmission[bhash].amount;
}
function getDeliveredCode(uint256 bhash) public view returns (uint256 ) {
   return trashsubmission[bhash].code;
}

    function _addDelivery(uint256 mapHash,address collector,address residnet,
    string memory location,uint256 time,uint256 code,uint256 amount)internal  returns (bool) {
        trashsubmission [mapHash] = SubmissionDetails (collector,residnet,code,amount,false,false,time,location);
        return true;
    }
    function _validateDeliverables( uint256  mapHash,bool status)internal  returns (bool) {
        trashsubmission[mapHash].delivered = status;
        return true;
    }
    function _confirmPickup( uint256  mapHash,bool status)internal  returns (bool) {
        trashsubmission[mapHash].paid = status;
        return true;
    }
 

}