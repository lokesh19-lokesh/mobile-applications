import React from 'react';
import './FeaturesBanner.css';

const features = [
  { icon: '✓', title: 'Premium Quality', desc: 'Finest fabrics' },
  { icon: '🚚', title: 'Weekly Fresh Box', desc: 'Handpicked for you' },
  { icon: '🔄', title: 'Easy Returns', desc: 'Hassle-free pickup' },
  { icon: '🧺', title: 'No Laundry', desc: 'We handle it' },
];

const FeaturesBanner = () => {
  return (
    <div className="features-banner">
      <div className="container features-container">
        {features.map((feature, index) => (
          <div key={index} className="feature-item">
            <div className="feature-icon">{feature.icon}</div>
            <div>
              <div className="feature-title">{feature.title}</div>
              <div className="feature-desc">{feature.desc}</div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default FeaturesBanner;
