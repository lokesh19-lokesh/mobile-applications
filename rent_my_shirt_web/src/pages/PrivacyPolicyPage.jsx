import React, { useEffect } from 'react';
import './PrivacyPolicyPage.css';

const PrivacyPolicyPage = () => {
  useEffect(() => {
    window.scrollTo(0, 0);
  }, []);

  return (
    <div className="privacy-page container section-space">
      <h1 className="page-title text-center" style={{ marginBottom: '40px' }}>Privacy Policy</h1>
      <div className="page-content">
        <p>Last updated: June 2026</p>
        
        <h2>1. Introduction</h2>
        <p>Welcome to Wearbox. We respect your privacy and are committed to protecting your personal data. This privacy policy will inform you about how we look after your personal data when you visit our website.</p>
        
        <h2>2. Data We Collect</h2>
        <p>We may collect, use, store and transfer different kinds of personal data about you, including your name, email address, phone number, shipping address, and payment information when you subscribe to our plans.</p>
        
        <h2>3. How We Use Your Data</h2>
        <p>We will only use your personal data for the purpose of fulfilling your subscription, processing payments, delivering products, and providing customer support.</p>
        
        <h2>4. Data Security</h2>
        <p>We have put in place appropriate security measures to prevent your personal data from being accidentally lost, used, or accessed in an unauthorized way.</p>
        
        <h2>5. Contact Us</h2>
        <p>If you have any questions about this privacy policy or our privacy practices, please contact us at contact@wearbox.com.</p>
      </div>
    </div>
  );
};

export default PrivacyPolicyPage;
