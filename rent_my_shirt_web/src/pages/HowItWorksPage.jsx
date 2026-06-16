import React from 'react';
import HowItWorks from '../components/HowItWorks';
import './HowItWorksPage.css';

const HowItWorksPage = () => {
  return (
    <div className="how-it-works-page">
      <div className="hiw-banner bg-light section-space">
        <div className="container text-center">
          <h1 className="about-title" style={{ fontSize: '3.5rem', marginBottom: '20px' }}>Simple. <span className="text-red">Seamless.</span> Smart.</h1>
          <p className="about-subtitle" style={{ fontSize: '1.25rem', color: 'var(--text-grey)', maxWidth: '600px', margin: '0 auto' }}>Discover how Wearbox transforms your weekly wardrobe routine into an effortless experience.</p>
        </div>
      </div>
      
      <div className="hiw-component-wrapper">
        <HowItWorks />
      </div>

      <div className="sustainability-section">
        <div className="container">
          <div className="sustain-content">
            <h2 style={{ color: 'white' }}>The Sustainable Choice</h2>
            <p>Did you know? Renting your workwear reduces your carbon footprint significantly. By participating in a circular economy, we save thousands of liters of water and prevent massive amounts of fast-fashion textile waste from ending up in landfills.</p>
            <div className="sustain-badges">
              <div className="sbadge">💧 Saves Water</div>
              <div className="sbadge">♻️ Reduces Waste</div>
              <div className="sbadge">🌍 Circular Economy</div>
            </div>
          </div>
        </div>
      </div>

      <div className="container section-space unboxing-section">
        <div className="unboxing-grid">
          <div className="unboxing-text">
            <h2>The Unboxing Experience</h2>
            <p>Every Monday morning, your customized Wearbox arrives. Inside, you'll find your selected shirts precisely folded, perfectly pressed, and individually wrapped to preserve their crispness during transit.</p>
            <p>It's not just a delivery; it's the feeling of a brand new wardrobe, every single week.</p>
          </div>
          <div className="unboxing-image">
            <img src="/assets/images/we_pickup_bag.png" alt="Unboxing Experience" />
          </div>
        </div>
      </div>
      
      <div className="hiw-why-section container section-space">
        <div className="hiw-why-content">
          <h2>Why Choose a Subscription?</h2>
          <div className="hiw-benefits">
            <div className="hiw-benefit">
              <h4>Zero Laundry</h4>
              <p>Reclaim your weekends. We handle all washing, dry cleaning, and ironing.</p>
            </div>
            <div className="hiw-benefit">
              <h4>Always Fresh</h4>
              <p>Every shirt is delivered crisp, clean, and ready to wear straight out of the box.</p>
            </div>
            <div className="hiw-benefit">
              <h4>Endless Variety</h4>
              <p>Rotate your style without cluttering your closet. Enjoy premium shirts without the premium price tag.</p>
            </div>
            <div className="hiw-benefit">
              <h4>Damage Protection</h4>
              <p>Spilled coffee? Don't worry. Normal wear and tear is fully covered under your plan.</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default HowItWorksPage;
