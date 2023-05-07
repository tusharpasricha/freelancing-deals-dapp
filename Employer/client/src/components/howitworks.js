import React from 'react'
import "./howitworks.css"

const Howitworks = () => {
  return (
    <div className='howitworks'>
    <div className='heading headd'>How It Works</div>
    <div>
    <div className='step'>
    View available deals and choose the one that you want to work on.    </div>
    <div className='step'>
    Pay the project price to the contract.
    </div>
    <div className='step'>
    The freelancer will work on the project and mark it as "done" using the commitProject function.    </div>
    
    <div className='step'>
    The employer can then review the completed project and close it using the closeProject function.
    </div>
    <div className='step'>
    Review the completed project and close it using the closeProject function.    
    </div>
    <div className='step'>
    If the project is successfully closed, the freelancer will receive the project price as payment.   </div>
    </div>
    </div>
    
    
  )
}

export default Howitworks