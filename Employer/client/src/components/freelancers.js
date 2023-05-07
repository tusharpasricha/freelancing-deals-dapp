import React from 'react'
import './freelancers.css'
import { useState ,useEffect } from 'react';
import useEth from "../contexts/EthContext/useEth";
import LoadingSpinner from "./spinner"

const Freelancer = () => {
  const { state: { contract, accounts } } = useEth();
   console.log(contract)
  const [projects, setProjects] = useState([]);
  const [associatedprojects, setassociatedProjects] = useState([]);
  const [pid,setPid] = useState();
  const [pname,setPname] = useState();
  const [pprice,setPprice] = useState();
  const [pstatus,setPstatus] = useState();
  const [pemployer,setPemployer] = useState();
  const [pfreelancer,setPfreelancer] = useState();
  const [plink,setlink] = useState();
  const [isLoading, setIsLoading] = useState(false);
  const [iserror, setIserror] = useState(false);




  const refresh =async()=>{
    fetchAssociatedProjects();
    
    const numProjects = await contract.methods.numDeal().call();
      const projects = [];
      for (let i = 0; i < numProjects; i++) {
        const project = await contract.methods.deals(i).call();
        projects.push(project);
      }
      setProjects(projects);
      console.log(projects)
  }
  async function fetchAssociatedProjects() {
    try {
      setIsLoading(true);
      const Id = await contract.methods.employerDeal(accounts[0]).call();
      console.log(Id);
      const project = await contract.methods.getDealById(Id).call();
            console.log(project);
            setPid(project[0]);
            setPname(project[1]);
            setPprice(project[2]);
            setPstatus(project[3]);
            setPemployer(project[4]);
            setPfreelancer(project[5]);
            setlink(project[6]);
            setIsLoading(false);
  } catch (error) {
    console.log("error");
    console.error(error);
    setIsLoading(false);
  }
}
  const pickproject= async(id,price)=>{
    await contract.methods
    .pickDeal(id)
    .send({ from: accounts[0], value: price })
    .then((receipt) => {
      console.log("Transaction receipt:", receipt);
    }).then(()=>{refresh()})
    .catch((error) => {
      console.error("Error picking project:", error);
    });
  }
  const closeproject= async(id)=>{
    await contract.methods
    .closeDeal(id)
    .send({ from: accounts[0]})
    .then((receipt) => {
      console.log("Transaction receipt:", receipt);
    })
    .catch((error) => {
      console.error("Error closing project:", error);
    });
  }

  const renderArray = projects
  .filter(item => item.status !== "2")
  .filter(item => item.status !== "1")
  .filter(item => item.status !== "0")

  .slice(1)
  .map(item => (
    <div className="project" key={item.id}>
      <p>ID: {item.id}</p>
      <p>Name: {item.name}</p>
      <p>Price: {item.price}</p>
      <p>
        {item.status === "0" && <p>Status: Done</p>}
        {item.status === "1" && <p>Status: Not Done</p>}
        {item.status === "3" && <p>Status: Open</p>}
      </p>
      <p>Portfolio link: <a href={item.link} target="_blank">{item.link}</a></p>
      <p>Freelancer's Address: {item.freelancer}</p>
      <p>Your Address: {accounts[0]}</p>
      <button onClick={() => pickproject(item.id, item.price)}>Contract</button>
    </div>
  ));




  return (
    <>
    <div className='allfreelancers'>
    <div className='sync'>
            <p>To get sync with the Smart Contract</p>
            <button onClick={refresh} >Sync</button>
            </div>
      {isLoading ? <LoadingSpinner /> : refresh}
      {pid > 0 && pstatus !== "2"?<div className='associateddeals'>
         <h1>ASSOCIATED DEAL</h1>
        <div>
            <p>ID: {pid}</p>
            <p>Name: {pname}</p>
            <p>Price: {pprice}</p>
            <p>
                {pstatus === "0" && <p>Status: Done</p>}
                {pstatus === "1" && <p>Status: Not Done</p>}
                {pstatus === "2" && <p>Status: Closed</p>}
                {pstatus === "3" && <p>Status: Open</p>}
                </p>
            <p>Employer: {pemployer}</p>
            <p>Freelancer: {pfreelancer}</p>
            <button onClick={() => closeproject(pid)}>Close</button>
        </div>
      </div>:null}

      {pid==0 || pstatus === "2"?<div className='alldeals'>
      <h1>FREELANCERS</h1>
     { renderArray.length>0?<div>{renderArray}</div>:<div>No registered freelancers available </div>}
      </div>:null}

    </div>
    </>
    
  )
}

export default Freelancer