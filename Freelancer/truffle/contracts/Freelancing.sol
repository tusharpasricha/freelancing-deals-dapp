//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Freelancing {

struct Deal{
  uint    id;
  string  name;
  uint    price;
  Status  status;
  address employer;
  address freelancer;
  string link;
}

mapping(uint=>Deal) public deals;
mapping(address=>uint) public employerDeal;
mapping(address=>uint) public freelancerDeal;

uint public numDeal = 0;
enum Status{Done,NotDone,Closed,Open}

// events
event AddDeal(uint dealID,string name,uint price);
event PickDeal(uint dealID,address freelancer);
event CommitDeal(uint dealID,address freelancer);
event CloseDeal(uint dealID,address employer,address freelancer,uint price);

// modifiers
modifier verifyCaller (address _address) { require (msg.sender == _address); _;}
modifier open(uint _id){require(deals[_id].status==Status.Open); _;}
modifier done(uint _id){require(deals[_id].status==Status.Done); _;}
 
constructor() {
        addDeal("Dummy DEAL", 100 , "tusharpasricha.vercel.app");
  }


//WHEN FREELANCER WILL FILL FORM A DEAL WITH HIS NAME WILL BE CREATED
function addDeal(string memory _name , uint _price , string memory _link) public {
  uint _id=numDeal;
  deals[_id] = Deal({id:_id,name:_name,link:_link,price:_price,status:Status.Open,employer:address(0),freelancer:msg.sender});
  numDeal=numDeal+1;
  freelancerDeal[msg.sender]=_id;
  emit AddDeal(_id,_name,_price);
}



//WHEN EMPLOYEE IS CHOOSING FREELANCER THAT MEANS HE WILL PAY THE AMOUNT TO CONTRACT
function pickDeal(uint _id)public open(_id) payable returns(uint){
require(msg.value==deals[_id].price, "Insufficient Price");
deals[_id].employer=msg.sender;
deals[_id].status=Status.NotDone;
employerDeal[msg.sender] = _id;
emit PickDeal(_id,msg.sender);
return _id;
}



//WHEN FREELANCER WILL DONE WITH THE DEAL HE WILL COMMIT THE WORK
function commitDeal(uint _id)public verifyCaller(deals[_id].freelancer){
  deals[_id].status=Status.Done;
  emit CommitDeal(_id,msg.sender); 
}



//WHEN EMPLOYER GOT THE WORK HE WILL CLOSE THE DEAL
function closeDeal(uint _id)public done(_id) payable verifyCaller(deals[_id].employer){
  deals[_id].status=Status.Closed;
  (bool success, )=deals[_id].freelancer.call{value:(deals[_id].price)}("");
  require (success);
  emit CloseDeal(_id,deals[_id].employer,deals[_id].freelancer,deals[_id].price);
}



//RETURN DEAL WITH A PARTICULAR ID
function getDealById(uint _id) public view returns (Deal memory) {
    return deals[_id];
}

}

