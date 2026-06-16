import React from 'react';
import './Navbar.css';

const Navbar = () => {
  return (
    <nav className="navbar">
      <div className="container navbar-container">
        <div className="logo-container">
          <img src="/assets/images/logo.png" alt="Wearbox Logo" className="logo" />
        </div>
        
        <div className="nav-links">
          <a href="#how-it-works" className="nav-link">How It Works</a>
          <a href="#collections" className="nav-link">Collections</a>
          <a href="#plans" className="nav-link">Plans</a>
          <a href="#about" className="nav-link">About Us</a>
          <a href="#reviews" className="nav-link">Reviews</a>
        </div>
        
        <div className="nav-actions">
          <button className="btn btn-primary btn-sm">Get Started</button>
        </div>
      </div>
    </nav>
  );
};

export default Navbar;
