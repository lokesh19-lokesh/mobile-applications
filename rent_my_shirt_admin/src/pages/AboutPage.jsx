import React from 'react';
import './AboutPage.css';

const AboutPage = () => {
  return (
    <div className="about-page">
      <div className="about-hero container section-space">
        <h1 className="about-title">The <span className="text-red">Wearbox</span> Story</h1>
        <p className="about-subtitle">We believe professionals shouldn't waste their weekends doing laundry.</p>
      </div>
      
      <div className="stats-banner">
        <div className="container">
          <div className="stats-grid">
            <div className="stat-item">
              <h3>1M+</h3>
              <p>Shirts Delivered</p>
            </div>
            <div className="stat-item">
              <h3>10,000+</h3>
              <p>Active Members</p>
            </div>
            <div className="stat-item">
              <h3>0 Hours</h3>
              <p>Wasted on Laundry</p>
            </div>
          </div>
        </div>
      </div>
      
      <div className="container about-content section-space">
        <div className="about-grid">
          <div className="about-text-card">
            <h2>Our Mission</h2>
            <p>Our mission is simple: to ensure every professional in India steps out looking sharp, feeling confident, and without the hassle of ironing or washing.</p>
          </div>
          <div className="about-text-card">
            <h2>Why We Started</h2>
            <p>Wearbox was born out of personal frustration. After working 60-hour weeks, the last thing we wanted was to spend our Sunday evening ironing shirts for the week. We knew there had to be a better way.</p>
          </div>
        </div>
      </div>
      
      <div className="about-values section-space bg-light">
        <div className="container">
          <h2 className="section-title" style={{ textAlign: 'center' }}>Our Core Values</h2>
          <div className="values-grid">
            <div className="value-card">
              <div className="value-icon">⭐</div>
              <h3>Uncompromising Quality</h3>
              <p>We source only premium cottons and partner with top-tier dry cleaners to guarantee a perfect finish every time.</p>
            </div>
            <div className="value-card">
              <div className="value-icon">⏱️</div>
              <h3>Ultimate Convenience</h3>
              <p>Your time is valuable. Our seamless pickup and delivery schedules are built around your life, not ours.</p>
            </div>
            <div className="value-card">
              <div className="value-icon">🌱</div>
              <h3>Sustainable Fashion</h3>
              <p>By shifting to a rental model, we maximize the lifecycle of high-quality garments and reduce textile waste.</p>
            </div>
          </div>
        </div>
      </div>

      <div className="quality-promise container section-space">
        <div className="quality-grid">
          <div className="quality-image">
            <img src="/assets/images/we_deliver_box.png" alt="Premium Packaging" />
          </div>
          <div className="quality-text">
            <h2>Our Quality Promise</h2>
            <p>Every single shirt goes through a rigorous 7-step inspection process before it ever reaches your door. We partner exclusively with certified, eco-friendly dry cleaners to ensure your garments aren't just clean—they're pristine.</p>
            <p>If you're ever unhappy with the fit or finish of a shirt, we replace it instantly. No questions asked.</p>
            <button className="btn btn-primary" style={{ marginTop: '20px' }}>Join the Club</button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default AboutPage;
