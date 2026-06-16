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
        <div className="collection-item" style={{ backgroundColor: '#f0f0f0' }}></div>
        <div className="collection-item" style={{ backgroundColor: '#f8c8dc' }}></div>
        <div className="collection-item" style={{ backgroundColor: '#bae1ff' }}></div>
        <div className="collection-item" style={{ backgroundColor: '#c0c0c0' }}></div>
        <div className="collection-item" style={{ backgroundColor: '#4a4a4a' }}></div>
        <div className="collection-item" style={{ backgroundColor: '#f0f0f0' }}></div>
      </div>
    </div>
  );
};

export default NewInThisWeek;
