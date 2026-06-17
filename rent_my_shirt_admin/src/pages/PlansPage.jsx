import React from 'react';
import Plans from '../components/Plans';
import './PlansPage.css';

const PlansPage = () => {
  return (
    <div className="plans-page">
      <div className="plans-header bg-light section-space">
        <div className="container text-center">
          <h1 className="about-title" style={{ fontSize: '3.5rem', marginBottom: '20px' }}>Simple. <span className="text-red">Transparent.</span></h1>
          <p className="about-subtitle" style={{ fontSize: '1.25rem', color: 'var(--text-grey)', maxWidth: '600px', margin: '0 auto' }}>Choose a subscription that fits your lifestyle. Cancel anytime.</p>
        </div>
      </div>

      <div className="plans-component-wrapper">
        <Plans />
      </div>

      <div className="container section-space features-comparison">
        <h2 className="section-title" style={{ textAlign: 'center' }}>Every Plan Includes</h2>
        <div className="features-grid">
          <div className="plan-feature-item">
            <div className="feature-icon">✔️</div>
            <h4>Free Weekly Delivery</h4>
            <p>We pick up and drop off at your door.</p>
          </div>
          <div className="plan-feature-item">
            <div className="feature-icon">✔️</div>
            <h4>Premium Dry Cleaning</h4>
            <p>Professional eco-friendly cleaning.</p>
          </div>
          <div className="plan-feature-item">
            <div className="feature-icon">✔️</div>
            <h4>Crisp Ironing</h4>
            <p>Ready to wear out of the box.</p>
          </div>
          <div className="plan-feature-item">
            <div className="feature-icon">✔️</div>
            <h4>Damage Protection</h4>
            <p>Accidental spills? Covered.</p>
          </div>
        </div>
      </div>

      <div className="guarantee-banner bg-light section-space">
        <div className="container text-center">
          <div className="guarantee-icon">🛡️</div>
          <h2>100% Satisfaction Guarantee</h2>
          <p>We are absolutely confident you will love your Wearbox subscription. If you are not completely satisfied with your first delivery, we will refund your first month in full. No questions asked.</p>
        </div>
      </div>

      <div className="corporate-banner container section-space">
        <div className="corporate-content" style={{ textAlign: 'center' }}>
          <h2>Looking for your team?</h2>
          <p>We offer special discounted rates for corporate teams of 10 or more. Give your employees the perk of looking sharp without the hassle.</p>
          <button className="btn btn-outline" style={{ marginTop: '20px' }}>Contact Enterprise Sales</button>
        </div>
      </div>

      <div className="pricing-faq container section-space" style={{ marginBottom: '60px' }}>
        <h2 className="section-title text-center">Pricing FAQ</h2>
        <div className="pricing-faq-grid">
          <div className="pricing-faq-item">
            <h4>Are there any hidden delivery fees?</h4>
            <p>No. Every plan includes free pickup and delivery every week. What you see is exactly what you pay.</p>
          </div>
          <div className="pricing-faq-item">
            <h4>When am I billed?</h4>
            <p>You are billed automatically on the same day every month from the date you started your subscription.</p>
          </div>
          <div className="pricing-faq-item">
            <h4>Can I cancel anytime?</h4>
            <p>Absolutely. There are no long-term commitments. You can cancel your subscription from your dashboard with one click.</p>
          </div>
          <div className="pricing-faq-item">
            <h4>Do I pay extra for dry cleaning?</h4>
            <p>Never. Premium dry cleaning and crisp ironing are included in the price of every single shirt.</p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default PlansPage;
