import React from 'react';
import NewInThisWeek from '../components/NewInThisWeek';
import './CollectionsPage.css';

const CollectionsPage = () => {
  return (
    <div className="collections-page">
      <div className="collections-header bg-light section-space">
        <div className="container text-center">
          <h1 className="about-title" style={{ fontSize: '3.5rem', marginBottom: '20px' }}>Our <span className="text-red">Collections</span></h1>
          <p className="about-subtitle" style={{ fontSize: '1.25rem', color: 'var(--text-grey)', maxWidth: '600px', margin: '0 auto' }}>Curated styles for every professional occasion.</p>
        </div>
      </div>
      
      <div className="container section-space categories-section">
        <h2 className="section-title" style={{ textAlign: 'center' }}>Shop by Category</h2>
        <div className="categories-grid">
          <div className="category-card" style={{ backgroundImage: 'url(/assets/images/shirt_white_formal.png)' }}>
            <div className="category-overlay">
              <h3>Office Formals</h3>
            </div>
          </div>
          <div className="category-card" style={{ backgroundImage: 'url(/assets/images/shirt_blue.png)' }}>
            <div className="category-overlay">
              <h3>Business Casuals</h3>
            </div>
          </div>
          <div className="category-card" style={{ backgroundImage: 'url(/assets/images/shirt_black_collar.png)' }}>
            <div className="category-overlay">
              <h3>Premium Executive</h3>
            </div>
          </div>
        </div>
      </div>

      <div className="fabric-matters-section">
        <div className="container">
          <div className="fabric-grid">
            <div className="fabric-text">
              <h2>The Fabric Matters</h2>
              <p>We believe that a great shirt starts with exceptional fabric. Our collection is curated from the finest mills, ensuring every piece you wear is breathable, durable, and remarkably comfortable.</p>
              <ul>
                <li>🧵 100% Premium Egyptian Cotton</li>
                <li>🌬️ Breathable & Moisture-Wicking</li>
                <li>✨ Wrinkle-Resistant Finishes</li>
              </ul>
            </div>
            <div className="fabric-image">
              <img src="/assets/images/shirt_white_formal.png" alt="Premium Fabric Detail" />
            </div>
          </div>
        </div>
      </div>

      <div className="hiw-component-wrapper">
        <NewInThisWeek />
      </div>

      <div className="container section-space best-sellers-section">
        <h2 className="section-title" style={{ textAlign: 'center' }}>All-Time Best Sellers</h2>
        <div className="best-sellers-grid">
          <div className="best-seller-item">
            <div className="img-wrapper">
              <img src="/assets/images/shirt_pink.png" alt="Classic Pink" />
            </div>
            <h4>Classic Pink Oxford</h4>
            <p className="text-red" style={{ color: 'var(--primary-red)' }}>Highly Rated</p>
          </div>
          <div className="best-seller-item">
            <div className="img-wrapper">
              <img src="/assets/images/shirt_grey.png" alt="Steel Grey" />
            </div>
            <h4>Steel Grey Premium</h4>
            <p className="text-red" style={{ color: 'var(--primary-red)' }}>Highly Rated</p>
          </div>
          <div className="best-seller-item">
            <div className="img-wrapper">
              <img src="/assets/images/shirt_white_tee.png" alt="Essential Tee" />
            </div>
            <h4>Essential Weekend Tee</h4>
            <p className="text-red" style={{ color: 'var(--primary-red)' }}>Highly Rated</p>
          </div>
        </div>
      </div>

      <div className="style-profile-banner section-space">
        <div className="container text-center">
          <h2>Not sure what fits you?</h2>
          <p>Let our expert stylists curate your perfect weekly rotation.</p>
          <button className="btn btn-primary" style={{ marginTop: '20px', padding: '15px 40px', fontSize: '1.1rem' }}>Take the Style Quiz</button>
        </div>
      </div>
    </div>
  );
};

export default CollectionsPage;
