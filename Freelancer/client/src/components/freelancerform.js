import React from 'react'
import { useState, useId } from 'react';
import useEth from "../contexts/EthContext/useEth";
import LoadingSpinner from "./spinner"


import "./freelancerform.css"

const Freelancerform = () => {
    const { state: { contract, accounts } } = useEth();
    const [name, setName] = useState('');
    const [category, setCategory] = useState('');
    const [desc, setDesc] = useState('');
    const [price, setPrice] = useState('')
    const options = ['Video Editor', 'Photo Editor', 'Logo Designer', 'Animators'];
    const [pid,setPid] = useState();
    const [pname,setPname] = useState();
    const [pprice,setPprice] = useState();
    const [pstatus,setPstatus] = useState();
    const [pemployer,setPemployer] = useState();
    const [pfreelancer,setPfreelancer] = useState();
    const [isLoading, setIsLoading] = useState(false);
    const [iserror, setIserror] = useState(false);
    const [link, setLink] = useState('');
    const [isLinkValid, setIsLinkValid] = useState(true);

    const urlPattern = /^(ftp|http|https):\/\/[^ "]+$/;

    const handleLinkChange = (e) => {
        const value = e.target.value;
        setLink(value);
        setIsLinkValid(urlPattern.test(value));
      };

    const submitHandler = async (e) => {
        if (!isLinkValid) {
            setIserror(true);
            return;
          }
        console.log(contract);
        e.preventDefault();
        try{
            await contract.methods.addDeal(name,price,link).send({ from: accounts[0] }).then(() => {
                console.log("Added to blockchain")
            }).then(()=>{refresh()})

        } catch(error){
            console.log("hi"+error);
            setIserror(true);
        }
        
    }
    const refresh =async()=>{
        
        
        fetchAssociatedDeals();
      }
    async function fetchAssociatedDeals() {
        try {
            setIsLoading(true);
            const freelancerId = await contract.methods.freelancerDeal(accounts[0]).call();
            console.log("id"+freelancerId);
            const project = await contract.methods.getDealById(freelancerId).call();
            console.log(project);
            setPid(project[0]);
            setPname(project[1]);
            setPprice(project[2]);
            setPstatus(project[3]);
            setPemployer(project[4]);
            setPfreelancer(project[5]);
            setIsLoading(false);
        } catch (error) {
          console.log("error");
          console.error(error);
          setIsLoading(false);
        }
      }
      const commitproject= async(id)=>{
        await contract.methods
        .commitDeal(id)
        .send({ from: accounts[0]})
        .then((receipt) => {
          console.log("Transaction receipt:", receipt);
        })
        .catch((error) => {
          console.error("Error closing project:", error);
        });
      }
    return (
        <div id="deals"  className='dealplusform'>
            <div className='sync'>
            <p>To get sync with the Smart Contract</p>
            <button onClick={refresh} disabled={isLoading}>Sync</button>
            </div>
            {isLoading ? <LoadingSpinner /> : refresh}
            {pid>0 && pstatus !== "2"?<div className="associateddeals">
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
        { pstatus==="1"? <button onClick={() => commitproject(pid)}>Commit</button> :null}
            </div>
            </div>:null}
         
        {pid==0 || pstatus ==="2"?<div className='freelancerform'>
            <h1>Freelancer Form</h1>
        <form className='form' onSubmit={submitHandler}>
            <input placeholder='Name' type="text" value={name} onChange={e => setName(e.target.value)} />
            <select onChange={e => setCategory(e.target.value)}>
                <option>Please choose one category</option>
                {options.map((option, index) => {
                    return <option key={index} >
                        {option}
                    </option>
                })}
            </select>
            <input
                placeholder='Portfolio Link'
                type="text"
                value={link}
                onChange={handleLinkChange}
                />    
                            {!isLinkValid && <div>Please enter a valid URL</div>}
 
               <input placeholder='Description' type="text" value={desc} onChange={e => setDesc(e.target.value)} />
            <input placeholder='Price' type="number" value={price} onChange={e => setPrice(e.target.value)} />
            {iserror?<div>Invalid Input</div>:null}
            <button type='submit'>Add</button>
        </form>
        </div>:null}
        </div>
    )
}

export default Freelancerform
