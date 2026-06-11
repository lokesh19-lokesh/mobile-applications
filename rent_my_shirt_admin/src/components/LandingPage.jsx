import React from 'react';
import './LandingPage.css';

function LandingPage({ onLogin }) {
  return (
    <div className="landing-page">
      <nav className="navbar">
        <div className="logo-container">
          <div className="logo-text">
            <span className="logo-wb">WB</span> wearbox
          </div>
        </div>
        <div className="nav-links">
          <span>How It Works</span>
          <span>Collections</span>
          <span>Plans</span>
          <span>About Us</span>
          <span>Reviews</span>
        </div>
        <button className="btn-get-started" onClick={onLogin}>Admin Login</button>
      </nav>

      <header className="hero-section">
        <div className="hero-content">
          <p className="hero-subtitle">PREMIUM WORKWEAR. ZERO HASSLE.</p>
          <h1 className="hero-title">Your Wardrobe.<br/>On Subscription.</h1>
          <p className="hero-description">4 Fresh Shirts + 1 Premium Tee<br/>Delivered Every Monday.</p>
          <div className="hero-actions">
            <button className="btn-primary-large">Start Subscription</button>
            <button className="btn-secondary-large">Explore Plans</button>
          </div>
        </div>
      </header>

      <section className="plans-section">
        <h2 className="section-title">Choose Your Plan</h2>
        <p className="section-subtitle">Simple plans. Premium experience.</p>
        
        <div className="pricing-grid">
          {/* Starter Plan */}
          <div className="pricing-card">
            <h3>Starter</h3>
            <div className="price">
              <span className="currency">₹</span>
              <span className="amount">1499</span>
              <span className="period">/month</span>
            </div>
            <p className="plan-features"><strong>3 Shirts</strong></p>
            <p className="plan-desc">Perfect for getting started</p>
            <button className="btn-select-plan">Select Plan &gt;</button>
          </div>

          {/* Professional Plan (Most Popular) */}
          <div className="pricing-card popular">
            <div className="popular-badge">MOST POPULAR</div>
            <h3>Professional</h3>
            <div className="price">
              <span className="currency">₹</span>
              <span className="amount">2499</span>
              <span className="period">/month</span>
            </div>
            <p className="plan-features"><strong>4 Shirts + 1 Tee</strong></p>
            <p className="plan-desc">Our best-selling plan</p>
            <button className="btn-select-plan primary">Select Plan</button>
          </div>

          {/* Executive Plan */}
          <div className="pricing-card">
            <h3>Executive</h3>
            <div className="price">
              <span className="currency">₹</span>
              <span className="amount">3999</span>
              <span className="period">/month</span>
            </div>
            <p className="plan-features"><strong>Premium Collection</strong></p>
            <p className="plan-desc">Premium shirts. Premium you.</p>
            <button className="btn-select-plan">Select Plan &gt;</button>
          </div>
        </div>
      </section>
    </div>
  );
}

export default LandingPage;
