import React, { useState } from 'react';
import './info.css'

const ProjectDescriptionCard = () => {
  const [isCardVisible, setCardVisible] = useState(true);

  const handleCardClose = () => {
    setCardVisible(false);
  };

  if (!isCardVisible) {
    return null; // Don't render the card if it's not visible
  }

  return (
    <div className="project-description-card">
      <p>You need to set up a local blockchain and have metamask wallet with some test ethers to run this project completely.</p>
      <p>Check out GITHUB for code:</p>
      <a href='https://github.com/tusharpasricha/freelancing-deals-dapp' target='blank'> https://github.com/tusharpasricha/freelancing-deals-dapp</a>
      <p></p>
      <button onClick={handleCardClose}>Close</button>
    </div>
  );
};

export default ProjectDescriptionCard;
