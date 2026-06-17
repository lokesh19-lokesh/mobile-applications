import React from 'react';
import { FiCheckCircle, FiStar, FiRefreshCw, FiXCircle } from 'react-icons/fi';
import './FeaturesBanner.css';

const FeaturesBanner = () => {
  return (
    <div className="features-banner">
      <div className="container features-container">
        <div className="feature-item">
          <FiCheckCircle size={32} color="var(--primary-red)" className="feature-icon" />
          <div className="feature-text">
            <h4>Premium Quality</h4>
            <p>Finest fabrics</p>
          </div>
        </div>
        <div className="feature-item">
          <FiStar size={32} color="var(--primary-red)" className="feature-icon" />
          <div className="feature-text">
            <h4>Weekly Fresh Box</h4>
            <p>Handpicked for you</p>
          </div>
        </div>
        <div className="feature-item">
          <FiRefreshCw size={32} color="var(--primary-red)" className="feature-icon" />
          <div className="feature-text">
            <h4>Easy Returns</h4>
            <p>Hassle-free pickup</p>
          </div>
        </div>
        <div className="feature-item">
          <FiXCircle size={32} color="var(--primary-red)" className="feature-icon" />
          <div className="feature-text">
            <h4>No Laundry</h4>
            <p>We handle it</p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default FeaturesBanner;
