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



//WHEN EMPLOYER GOT THE DEAL HE WILL CLOSE THE DEAL
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



function returnDeal(uint _id)public view returns(string memory name,uint id,uint price,uint status,address employer,address freelancer){
name=deals[_id].name;
id=deals[_id].id;
price=deals[_id].price;
status=uint(deals[_id].status);
employer=deals[_id].employer;
freelancer=deals[_id].freelancer;
}


function returnDeals() public view returns (Deal[] memory) {
    Deal[] memory result = new Deal[](numDeal);
    for (uint i = 0; i < numDeal; i++) {
        result[i] = deals[i];
    }
    return result;
}



function getAssociatedDealas() public view returns (Deal memory){
    // require (employerProject [msg.sender]!=0 );
    return deals[employerDeal[msg.sender]];
}

function getDeals() public view returns (Deal[] memory){
    Deal[] memory people = new Deal[](numDeal);
    for(uint i = 0; i < numDeal; i++){
        people[i] = deals[i];
    }
    return people;

}

}

// pragma solidity ^0.8.0;

// contract Freelancing {

// struct Deal{
//   uint    id;
//   string  name;
//   uint    price;
//   Status  status;
//   address employer;
//   address freelancer;
// }

// mapping(uint=>Deal) public deals;
// mapping(address=>uint) public employerDeal;
// mapping(address=>uint) public freelancerDeal;

// uint public numDeal = 0;
// enum Status{Done,NotDone,Closed,Open}

// // events
// event AddDeal(uint dealID,string name,uint price);
// event PickDeal(uint dealID,address freelancer);
// event CommitDeal(uint dealID,address freelancer);
// event CloseDeal(uint dealID,address employer,address freelancer,uint price);

// // modifiers
// modifier verifyCaller (address _address) { require (msg.sender == _address); _;}
// modifier open(uint _id){require(deals[_id].status==Status.Open); _;}
// modifier done(uint _id){require(deals[_id].status==Status.Done); _;}
 
// constructor() {
//         addDeal("Dummy DEAL", 100);
//   }


// //WHEN FREELANCER WILL FILL FORM A DEAL WITH HIS NAME WILL BE CREATED
// function addDeal(string memory _name , uint _price) public {
//   uint _id=numDeal;
//   deals[_id] = Deal({id:_id,name:_name,price:_price,status:Status.Open,employer:address(0),freelancer:msg.sender});
//   numDeal=numDeal+1;
//   freelancerDeal[msg.sender]=_id;
//   emit AddDeal(_id,_name,_price);
// }



// //WHEN EMPLOYEE IS CHOOSING FREELANCER THAT MEANS HE WILL PAY THE AMOUNT TO CONTRACT
// function pickDeal(uint _id)public open(_id) payable returns(uint){
// require(msg.value==deals[_id].price, "Insufficient Price");
// deals[_id].employer=msg.sender;
// deals[_id].status=Status.NotDone;
// employerDeal[msg.sender] = _id;
// emit PickDeal(_id,msg.sender);
// return _id;
// }



// //WHEN FREELANCER WILL DONE WITH THE DEAL HE WILL COMMIT THE WORK
// function commitDeal(uint _id)public verifyCaller(deals[_id].freelancer){
//   deals[_id].status=Status.Done;
//   emit CommitDeal(_id,msg.sender); 
// }



// //WHEN EMPLOYER GOT THE DEAL HE WILL CLOSE THE DEAL
// function closeDeal(uint _id)public done(_id) payable verifyCaller(deals[_id].employer){
//   deals[_id].status=Status.Closed;
//   (bool success, )=deals[_id].freelancer.call{value:(deals[_id].price)}("");
//   require (success);
//   emit CloseDeal(_id,deals[_id].employer,deals[_id].freelancer,deals[_id].price);
// }



// //RETURN DEAL WITH A PARTICULAR ID
// function getDealById(uint _id) public view returns (Deal memory) {
//     return deals[_id];
// }



// function returnDeal(uint _id)public view returns(string memory name,uint id,uint price,uint status,address employer,address freelancer){
// name=deals[_id].name;
// id=deals[_id].id;
// price=deals[_id].price;
// status=uint(deals[_id].status);
// employer=deals[_id].employer;
// freelancer=deals[_id].freelancer;
// }


// function returnDeals() public view returns (Deal[] memory) {
//     Deal[] memory result = new Deal[](numDeal);
//     for (uint i = 0; i < numDeal; i++) {
//         result[i] = deals[i];
//     }
//     return result;
// }



// function getAssociatedDealas() public view returns (Deal memory){
//     // require (employerProject [msg.sender]!=0 );
//     return deals[employerDeal[msg.sender]];
// }

// function getDeals() public view returns (Deal[] memory){
//     Deal[] memory people = new Deal[](numDeal);
//     for(uint i = 0; i < numDeal; i++){
//         people[i] = deals[i];
//     }
//     return people;

// }

// }


// pragma solidity ^0.8.0;

// contract Freelancing {

// struct Project{
//   uint    id;
//   string  name;
//   uint    price;
//   Status  status;
//   address employer;
//   address freelancer;
// }

// mapping(uint=>Project) public projects;
// mapping(address=>uint) public employerProject;
// mapping(address=>uint) public freelancerProject;

// uint public numProjects = 0;
// enum Status{Done,NotDone,Closed,Open}

// // events
// event AddProject(uint projectId,string name,uint price);
// event PickProject(uint projectId,address freelancer);
// event CommitProject(uint projectId,address freelancer);
// event CloseProject(uint projectId,address employer,address freelancer,uint price);

// // modifiers
// modifier verifyCaller (address _address) { require (msg.sender == _address); _;}
// modifier open(uint _id){require(projects[_id].status==Status.Open); _;}
// modifier done(uint _id){require(projects[_id].status==Status.Done); _;}
 
// constructor() {
//         addProject("Dummy Project", 100);
//   }


// //WHEN FREELANCER WILL FILL FORM A PROJECT WITH HIS NAME WILL BE CREATED
// function addProject(string memory _name , uint _price) public {
//     uint _id=numProjects;
//     projects[_id] = Project({id:_id,name:_name,price:_price,status:Status.Open,employer:address(0),freelancer:msg.sender});
//     numProjects=numProjects+1;
//     freelancerProject[msg.sender]=_id;
//     emit AddProject(_id,_name,_price);
// }



// //WHEN EMPLOYEE IS CHOOSING FREELANCER THAT MEANS HE WILL PAY THE AMOUNT TO CONTRACT
// function pickProject(uint _id)public open(_id) payable returns(uint){
// require(msg.value==projects[_id].price, "Insufficient Price");
// projects[_id].employer=msg.sender;
// projects[_id].status=Status.NotDone;
// employerProject[msg.sender] = _id;
// emit PickProject(_id,msg.sender);
// return _id;
// }



// //WHEN FREELANCER WILL DONE WITH THE PROJECT HE WILL COMMIT THE WORK
// function commitProject(uint _id)public verifyCaller(projects[_id].freelancer){
//   projects[_id].status=Status.Done;
//   emit CommitProject(_id,msg.sender); 
// }



// //WHEN EMPLOYER GOT THE PROJECT HE WILL CLOSE THE PROJECT
// function closeProject(uint _id)public done(_id) payable verifyCaller(projects[_id].employer){
//     projects[_id].status=Status.Closed;
//     (bool success, )=projects[_id].freelancer.call{value:(projects[_id].price)}("");
//     require (success);
//     emit CloseProject(_id,projects[_id].employer,projects[_id].freelancer,projects[_id].price);
// }



// //RETURN DEAL WITH A PARTICULAR ID
// function getProjectById(uint _id) public view returns (Project memory) {
//     return projects[_id];
// }



// function returnProject(uint _id)public view returns(string memory name,uint id,uint price,uint status,address employer,address freelancer){
// name=projects[_id].name;
// id=projects[_id].id;
// price=projects[_id].price;
// status=uint(projects[_id].status);
// employer=projects[_id].employer;
// freelancer=projects[_id].freelancer;
// }


// function returnProjects() public view returns (Project[] memory) {
//     Project[] memory result = new Project[](numProjects);
//     for (uint i = 0; i < numProjects; i++) {
//         result[i] = projects[i];
//     }
//     return result;
// }


// function getAssociatedProjects() public view returns (Project memory){
//     // require (employerProject [msg.sender]!=0 );
//     return projects[employerProject[msg.sender]];
// }

// function getProjects() public view returns (Project[] memory){
//     Project[] memory people = new Project[](numProjects);
//     for(uint i = 0; i < numProjects; i++){
//         people[i] = projects[i];
//     }
//     return people;

// }

// }




