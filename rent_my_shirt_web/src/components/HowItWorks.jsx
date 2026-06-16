import React from 'react';
import './HowItWorks.css';

const steps = [
  { num: '01', title: 'We Deliver', desc: 'Fresh box at your doorstep every Monday.', image: '/assets/images/we_deliver_box.png' },
  { num: '02', title: 'You Wear', desc: 'Rock your week, stress-free.', image: '/assets/images/you_wear_man.png' },
  { num: '03', title: 'We Pickup', desc: 'We pickup every weekend. Easy returns.', image: '/assets/images/we_pickup_bag.png' },
];

const HowItWorks = () => {
  return (
    <div className="how-it-works container section-space">
      <div className="section-header">
        <h2 className="section-title">How It Works</h2>
        <a href="#view-all" className="view-all">View all</a>
      </div>
      <div className="steps-container">
        {steps.map((step, idx) => (
          <div key={idx} className="step-card">
            <div className="step-content">
              <div className="step-num">{step.num}</div>
              <div className="step-title">{step.title}</div>
              <div className="step-desc">{step.desc}</div>
            </div>
            <div className="step-image-wrapper">
              <img src={step.image} alt={step.title} className="step-image" />
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default HowItWorks;
