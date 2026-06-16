import React, { useEffect } from 'react';
import { FaApple, FaGooglePlay } from 'react-icons/fa';
import './DownloadAppPage.css';

const DownloadAppPage = () => {
  useEffect(() => {
    window.scrollTo(0, 0);

    const viewportMeta = document.querySelector('meta[name="viewport"]');
    let originalContent = 'width=1200';
    if (viewportMeta) {
      originalContent = viewportMeta.getAttribute('content');
      viewportMeta.setAttribute('content', 'width=device-width, initial-scale=1.0');
    }

    return () => {
      if (viewportMeta) {
        viewportMeta.setAttribute('content', originalContent);
      }
    };
  }, []);

  return (
    <div className="download-app-page section-space container">
      <div className="download-content">
        <h1 className="download-title">
          Take Your Wardrobe <br />
          <span className="text-red">Anywhere.</span>
        </h1>
        <p className="download-subtitle">
          The ultimate premium workwear subscription is coming soon to your pocket. Manage your plans, select your shirts, and track deliveries on the go.
        </p>
        
        <div className="store-buttons">
          <button className="store-btn coming-soon-btn">
            <FaApple className="store-icon" />
            <div className="store-text">
              <span className="store-sub">Coming Soon on the</span>
              <span className="store-main">App Store</span>
            </div>
          </button>
          
          <button className="store-btn coming-soon-btn">
            <FaGooglePlay className="store-icon" />
            <div className="store-text">
              <span className="store-sub">Coming Soon on</span>
              <span className="store-main">Google Play</span>
            </div>
          </button>
        </div>

        <div className="notification-form">
          <p>Want to be the first to know when we launch?</p>
          <div className="input-group">
            <input type="email" placeholder="Enter your email address" />
            <button className="btn btn-primary">Notify Me</button>
          </div>
        </div>
      </div>
      
      <div className="download-image-container">
        {/* Placeholder for an app mockup image */}
        <div className="phone-mockup">
          <div className="phone-screen">
            <div className="phone-logo">
              <span className="logo-w text-red">W</span><span className="logo-b">B</span>
            </div>
            <p className="phone-coming-soon">App Coming Soon</p>
            <div className="loading-dots">
              <span></span><span></span><span></span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default DownloadAppPage;
