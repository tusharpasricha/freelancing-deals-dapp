import React from 'react'

import Freelancerform from '../components/freelancerform'
import Afternav from '../components/afternav'
import Footer from '../components/footer'
import Front from '../components/front'
import Navbar from '../components/navbar'
import Howitworks from '../components/howitworks'
import './become.css'
import Feature from '../components/feature'
import ProjectDescriptionCard from '../components/info'
const Become = () => {
  return (
    <>
    <div className='find'>
      <Navbar/>
      <Afternav/>
      <Front/>
      <Freelancerform/>
      <Howitworks/>
      <Feature/>
      <Footer/>
    </div>
    <ProjectDescriptionCard/>
    </>
      
  )
}

export default Become


