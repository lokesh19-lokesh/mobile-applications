import React from 'react';
import { FaFacebook, FaInstagram, FaTwitter, FaYoutube } from 'react-icons/fa';
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
            <a href="#facebook" aria-label="Facebook"><FaFacebook size={24} /></a>
            <a href="#instagram" aria-label="Instagram"><FaInstagram size={24} /></a>
            <a href="#twitter" aria-label="Twitter"><FaTwitter size={24} /></a>
            <a href="#youtube" aria-label="YouTube"><FaYoutube size={24} /></a>
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
        <p>© 2026 Wearbox. All rights reserved. Powered by <a href="https://thepatternscompany.com/" target="_blank" rel="noopener noreferrer">Patterns Infotech Private Limited</a></p>
        <div className="footer-legal">
          <a href="#privacy">Privacy Policy</a>
          <a href="#terms">Terms & Conditions</a>
        </div>
      </div>
    </footer>
  );
};

export default Footer;
