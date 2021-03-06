pragma solidity ^0.4.23;

contract GovermentGasDivision {

address govermentAccout;
 
struct Vendor {
    string vendorShopName;
    uint vendorId;
    string vendorShopAddress;
    uint registrationDate;
    string vendorLicensHolderName;
    uint amoutPaidForLicens;
    uint vendorPincode;
    address vendorAddress;
}

struct Customer {
    string customerName;
    uint customerMobileNumber;
    string customerEmailId;
    string customerHomeAddress;
    uint customerConnectionFees;
    uint vendorId;
    uint noOfGasRefilling;
}

Vendor[] vendorsArray;
mapping(uint => Customer) customerInfo;
mapping(address => uint) balanceOf;
mapping(uint => uint) amountPaidByCustomer;
mapping(address => bool) isCustomerRegistered;
mapping(uint => bool) isVendorRegistered;
mapping(address => uint) noOfGasFilledInYear;

uint public fundToBeTransferedToVendor;
uint public fundToBeTransferedTogovt;
uint public fundToBeTransferedToCust;

  constructor() public {
      govermentAccout = msg.sender;   
  }
  function registerVendor(uint _vid,
                          string _vendorShopName,
                          string  _vendorShopAddress,
                          uint  _regDate, 
                          string  _vendorLicensHolderName,
                          uint _amoutPaidForLicens, 
                          uint  _vendorPincode) public returns(uint) {
    vendorsArray.push(Vendor({
        vendorShopName: _vendorShopName,
        vendorId: _vid,
        vendorShopAddress: _vendorShopAddress,
        registrationDate: _regDate,
        vendorLicensHolderName: _vendorLicensHolderName,
        amoutPaidForLicens: _amoutPaidForLicens,
        vendorPincode: _vendorPincode,
        vendorAddress: msg.sender}));
        
    isVendorRegistered[_vid] = true;
    return _vid;
  }
  
function registerCustomerToVendor(string _customerName, 
                                    uint _customerMobileNumber, 
                                    string _customerEmailId, 
                                    string _customerHomeAddress, 
                                    uint _customerConnectionFees, 
                                    uint _vendorId,
                                    uint _noOfGasRefilling,
                                    uint _custId) payable public returns(uint) {
                                        
    Customer memory a = customerInfo[_custId];
          a.customerName = _customerName;
          a.customerMobileNumber = _customerMobileNumber;
          a.customerEmailId = _customerEmailId;
          a.customerHomeAddress = _customerHomeAddress;
          a.customerConnectionFees = _customerConnectionFees;
          a.vendorId = _vendorId;
          a.noOfGasRefilling = _noOfGasRefilling;
        
        isCustomerRegistered[msg.sender] = true;
        
        //take the reg date  with 365 days addition
        
        return _custId;
}    
function gasFilling(address _vendorAddress, uint _vid, uint _amountToBePaid) public returns (bool) {
      require(isCustomerRegistered[msg.sender] == true && isVendorRegistered[_vid] == true );
      
      balanceOf[msg.sender] -= _amountToBePaid;
      
      fundToBeTransferedToVendor = _amountToBePaid/100 * 20;
      balanceOf[_vendorAddress] += fundToBeTransferedToVendor;
      
      fundToBeTransferedTogovt = _amountToBePaid/100 * 60;
      balanceOf[govermentAccout] += fundToBeTransferedTogovt;
      
      fundToBeTransferedToCust = _amountToBePaid/100 * 20;
      balanceOf[msg.sender] += fundToBeTransferedToCust;
      
      _amountToBePaid = 0;
      noOfGasFilledInYear[msg.sender] ++;
      return true;
}

// //write a function to view the vendor details
// function getVendorDetails() public view returns(Vendor[]) {
//     return vendorsArray();
// }


//write a function to view to return customer details.
function getCustomerDetails(uint _custId) public view returns(string, uint, string, string, uint, uint, uint) {
    Customer memory a = customerInfo[_custId];
    return(a.customerName,
           a.customerMobileNumber,
           a.customerEmailId,
           a.customerHomeAddress,
           a.customerConnectionFees,
           a.vendorId,
           a.noOfGasRefilling);
}
}
