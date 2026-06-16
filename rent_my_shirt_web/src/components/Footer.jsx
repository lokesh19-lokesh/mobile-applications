import React from 'react';
import './Footer.css';

const Footer = () => {
  return (
    <footer className="footer section-space">
      <div className="container footer-container">
        <div className="footer-col-1">
          <img src="/assets/images/logo.png" alt="Wearbox" className="footer-logo" />
          <p className="footer-desc">
            Find the perfect premium workwear and shirts on subscription for professionals in India.
          </p>
          <div className="footer-socials">
            <span>fb</span>
            <span>ig</span>
            <span>tw</span>
            <span>yt</span>
          </div>
        </div>
        
        <div className="footer-col-2">
          <a href="#how-it-works">How It Works</a>
          <a href="#collections">Collections</a>
          <a href="#plans">Plans</a>
        </div>
        
        <div className="footer-col-3">
          <a href="#about">About Us</a>
          <a href="#reviews">Reviews</a>
          <a href="#faq">FAQ & Support</a>
        </div>
        
        <div className="footer-col-4">
          <h4 className="footer-title">Contact Us</h4>
          <div className="footer-contact-item">
            <span>📍</span> Banjara Hills, Hyderabad, India
          </div>
          <div className="footer-contact-item">
            <span>📞</span> +91 94937 02966
          </div>
          <div className="footer-contact-item">
            <span>✉️</span> contact@wearbox.com
          </div>
        </div>
      </div>
      
      <div className="container footer-bottom">
        <p>© 2026 Wearbox. All rights reserved. Powered by Wearbox Tech.</p>
        <div className="footer-legal">
          <a href="#privacy">Privacy Policy</a>
          <a href="#terms">Terms & Conditions</a>
        </div>
      </div>
    </footer>
  );
};

export default Footer;
