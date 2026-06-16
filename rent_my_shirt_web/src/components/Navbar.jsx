import React from 'react';
import { Link, useNavigate } from 'react-router-dom';
import './Navbar.css';

const Navbar = () => {
  return (
    <nav className="navbar">
      <div className="container navbar-container">
        <Link to="/" className="logo-container">
          <img src="/assets/images/logo.png" alt="Wearbox Logo" className="logo" />
        </Link>
        
        <div className="nav-links">
          <Link to="/how-it-works" className="nav-link">How It Works</Link>
          <Link to="/collections" className="nav-link">Collections</Link>
          <Link to="/plans" className="nav-link">Plans</Link>
          <Link to="/about" className="nav-link">About Us</Link>
          <Link to="/reviews" className="nav-link">Reviews</Link>
        </div>
        
        <div className="nav-actions">
          <button className="btn btn-primary btn-sm" onClick={() => window.location.href='/plans'}>Get Started</button>
        </div>
      </div>
    </nav>
  );
};

export default Navbar;
