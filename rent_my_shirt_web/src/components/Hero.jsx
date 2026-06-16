import React from 'react';
import './Hero.css';

const Hero = () => {
  return (
    <div className="hero container section-space">
      <div className="hero-content">
        <p className="hero-subtitle">PREMIUM WORKWEAR. ZERO HASSLE.</p>
        <h1 className="hero-title">
          Your<br/>
          Wardrobe.<br/>
          <span className="text-red">On<br/>Subscription.</span>
        </h1>
        <p className="hero-desc">
          4 Fresh Shirts + 1 Premium Tee<br/>
          Delivered Every Monday.
        </p>
        <div className="hero-buttons">
          <button className="btn btn-primary">Start Subscription</button>
          <button className="btn btn-outline">Explore Plans</button>
        </div>
      </div>
      <div className="hero-image-container">
        <img src="/assets/images/hero_image.png" alt="Man wearing white shirt and grey pants" className="hero-image" />
      </div>
    </div>
  );
};

export default Hero;
