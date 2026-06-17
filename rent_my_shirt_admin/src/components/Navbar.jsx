import React from 'react';
import { Link, useNavigate } from 'react-router-dom';
import './Navbar.css';

const Navbar = () => {
  const navigate = useNavigate();
  return (
    <nav className="navbar">
      <div className="navbar-container" style={{ width: '100%', maxWidth: 'none', padding: '0 40px', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
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
        
        <div className="nav-actions" style={{ display: 'flex', gap: '16px' }}>
          <button className="btn btn-sm" style={{ border: '1px solid #ccc', backgroundColor: 'transparent' }} onClick={() => navigate('/login')}>Admin Login</button>
          <button className="btn btn-primary btn-sm" onClick={() => navigate('/download-app')}>Get Started</button>
        </div>
      </div>
    </nav>
  );
};

export default Navbar;
