import React from 'react'
import "./howitworks.css"

const Howitworks = () => {
  return (
    <div id = "howitworks"className='howitworks'>
    <div className='heading headd'>How It Works</div>
    <div>
    <div className='step'>
    Fill out a form with your name and project details to create a new deal.
    </div>
    <div className='step'>
    Employers can view available deals and choose the one that they want to work on.
    </div>
    <div className='step'>
    Once an employer picks a project, they will pay the project price to the contract.
    </div>
    
    <div className='step'>
    The employer can then review the completed project and close it using the closeProject function.
    </div>
    <div className='step'>
    If the project is successfully closed, you will receive the project price as payment.
    </div>
    </div>
    </div>
  )
}

export default Howitworks