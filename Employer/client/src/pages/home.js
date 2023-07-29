import React from 'react'
import Afternav from '../components/afternav'
import Footer from '../components/footer'
import Freelancer from '../components/freelancers'
import Navbar from '../components/navbar'
import Front from '../components/front'
import Howitworks from '../components/howitworks'
import Feature from '../components/feature'
import ProjectDescriptionCard from '../components/info'


const Home = () => {
  return (
    <>
    <div>
        <Navbar/>
        <Afternav/>
        <Front/>
        <Freelancer/>
        <Howitworks/>
        <Feature/>
        <Footer/>
    </div>
    <ProjectDescriptionCard/>

    </>
  )
}

export default Home