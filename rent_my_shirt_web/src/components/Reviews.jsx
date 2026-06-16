import React from 'react';
import './Reviews.css';

const reviews = [
  { rating: '★★★★★', text: '"Wearbox has completely changed the way I dress for work. Super convenient!"', author: '- Rohit, Software Engineer' },
  { rating: '★★★★★', text: '"Premium shirts, always fresh and perfect fit."', author: '- Ankit, Product Manager' },
  { rating: '★★★★★', text: '"No more laundry or last-minute ironing. Love it!"', author: '- Vivek, Consultant' },
  { rating: '★★★★★', text: '"Best subscription I\'ve ever had."', author: '- Arjun, Financial Analyst' },
];

const Reviews = () => {
  return (
    <div className="container section-space">
      <div className="reviews-section">
        <div className="reviews-header">
          <h2 className="reviews-title">Loved by 10,000+ Professionals</h2>
          <a href="#view-all-reviews" className="view-all-reviews">View all reviews</a>
        </div>
        <div className="reviews-grid">
          {reviews.map((review, idx) => (
            <div key={idx} className="review-card">
              <div className="review-rating">{review.rating}</div>
              <p className="review-text">{review.text}</p>
              <p className="review-author">{review.author}</p>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default Reviews;
