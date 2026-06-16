import React from 'react';
import './NewInThisWeek.css';

const NewInThisWeek = () => {
  return (
    <div className="new-in-week container section-space">
      <div className="section-header">
        <div>
          <h2 className="section-title">New In This Week</h2>
          <p className="section-subtitle">Handpicked styles. Fresh every week.</p>
        </div>
        <a href="#view-all-collection" className="view-all">View all collection</a>
      </div>
      <div className="collection-grid">
        <div className="collection-item">
          <img src="/assets/images/shirt_white_tee.png" alt="White Tee" />
        </div>
        <div className="collection-item">
          <img src="/assets/images/shirt_pink.png" alt="Pink Shirt" />
        </div>
        <div className="collection-item">
          <img src="/assets/images/shirt_blue.png" alt="Blue Shirt" />
        </div>
        <div className="collection-item">
          <img src="/assets/images/shirt_grey.png" alt="Grey Shirt" />
        </div>
        <div className="collection-item">
          <img src="/assets/images/shirt_black_collar.png" alt="Black Collar Shirt" />
        </div>
        <div className="collection-item">
          <img src="/assets/images/shirt_white_formal.png" alt="White Formal Shirt" />
        </div>
      </div>
    </div>
  );
};

export default NewInThisWeek;
