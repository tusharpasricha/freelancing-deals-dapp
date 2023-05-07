import React from 'react'
import { Link, animateScroll as scroll } from "react-scroll";
import './navbar.css'
const Afternav = () => {
  return (
    <div className='afternav'>
        {/* <div>DEALS</div> */}
        <div><Link
            activeClass="active"
            to="allfreelancers"
            spy={true}
            smooth={true}
            offset={-70}
            duration={500}
        >FREELANCERS</Link>
        </div>
        {/* <div>FEATURES</div> */}
        <div><Link
            activeClass="active"
            to="feature"
            spy={true}
            smooth={true}
            offset={-70}
            duration={500}
        >FEATURES</Link>
        </div>
        {/* <div>HOW IT WORKS</div> */}
        <div><Link
            activeClass="active"
            to="howitworks"
            spy={true}
            smooth={true}
            offset={-70}
            duration={500}
        >HOW IT WORKS</Link>
        </div>
        <div>FEEDBACK</div>
    </div>
  )
}

export default Afternav