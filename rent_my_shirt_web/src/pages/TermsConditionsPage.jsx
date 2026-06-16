import React, { useEffect } from 'react';
import './TermsConditionsPage.css';

const TermsConditionsPage = () => {
  useEffect(() => {
    window.scrollTo(0, 0);
  }, []);

  return (
    <div className="terms-page container section-space">
      <h1 className="page-title text-center" style={{ marginBottom: '40px' }}>Terms & Conditions</h1>
      <div className="page-content">
        <p>Last updated: June 2026</p>

        <h2>1. Agreement to Terms</h2>
        <p>By accessing or using our website and services, you agree to be bound by these Terms and Conditions and our Privacy Policy.</p>

        <h2>2. Subscription Services</h2>
        <p>We provide a premium workwear subscription service. By subscribing, you agree to pay the recurring subscription fees associated with your chosen plan.</p>

        <h2>3. Delivery and Returns</h2>
        <p>We will deliver fresh shirts to your designated address on a weekly basis. You are responsible for returning the used shirts in the provided packaging when the new delivery arrives.</p>

        <h2>4. Care of Items</h2>
        <p>You agree to treat our clothing with care. Excessive damage, loss, or theft of the items may result in additional charges to your account.</p>

        <h2>5. Cancellation</h2>
        <p>You may cancel your subscription at any time. Cancellations will take effect at the end of your current billing cycle.</p>
      </div>
    </div>
  );
};

export default TermsConditionsPage;
