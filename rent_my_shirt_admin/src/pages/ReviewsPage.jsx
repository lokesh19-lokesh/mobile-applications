import React from 'react';
import Reviews from '../components/Reviews';
import './ReviewsPage.css';

const ReviewsPage = () => {
  return (
    <div className="reviews-page">
      <div className="reviews-header section-space">
        <div className="container text-center">
          <h1 className="about-title" style={{ fontSize: '3.5rem', marginBottom: '20px' }}>Don't just take our <span className="text-red">word for it.</span></h1>
          <p className="about-subtitle" style={{ fontSize: '1.25rem', color: 'var(--text-grey)', maxWidth: '600px', margin: '0 auto' }}>Join thousands of professionals who have already upgraded their wardrobe routine.</p>
          
          <div className="trust-badges">
            <div className="trust-badge">
              <span className="trust-score">4.9/5</span>
              <span className="trust-stars">⭐⭐⭐⭐⭐</span>
              <span className="trust-source">Based on 2,000+ Reviews</span>
            </div>
          </div>
        </div>
      </div>

      <div className="reviews-component-wrapper">
        <Reviews />
      </div>

      <div className="container section-space featured-story">
        <div className="featured-story-content">
          <div className="featured-quote">
            <span className="quote-mark">"</span>
            <h2>Wearbox literally gave me my weekends back. I used to spend 3 hours every Sunday washing and ironing shirts for the week. Now, I just open a box.</h2>
            <p className="featured-author">— Vikram S., Vice President of Sales</p>
            <p className="featured-plan">Professional Plan Member since 2023</p>
          </div>
          <div className="featured-image">
            <img src="/assets/images/you_wear_man.png" alt="Happy Customer" />
          </div>
        </div>
      </div>

      <div className="container section-space more-reviews-section">
        <h2 className="section-title" style={{ textAlign: 'center' }}>More Customer Stories</h2>
        <div className="masonry-grid">
          <div className="masonry-item">
            <div className="stars">⭐⭐⭐⭐⭐</div>
            <p className="review-text">"I was skeptical about renting shirts, but the quality of Wearbox is outstanding. The shirts look brand new every single week."</p>
            <p className="reviewer">- Karan, Marketing Director</p>
          </div>
          <div className="masonry-item">
            <div className="stars">⭐⭐⭐⭐⭐</div>
            <p className="review-text">"The convenience is unmatched. I travel often for work, and having a fresh set of ironed shirts ready on Monday morning is a lifesaver."</p>
            <p className="reviewer">- Siddharth, Sales Lead</p>
          </div>
          <div className="masonry-item">
            <div className="stars">⭐⭐⭐⭐</div>
            <p className="review-text">"Great fit, great fabrics. I wish they had more casual options, but for office wear, this is the best service in the city."</p>
            <p className="reviewer">- Priya, Operations Manager</p>
          </div>
          <div className="masonry-item">
            <div className="stars">⭐⭐⭐⭐⭐</div>
            <p className="review-text">"I've saved so much money on dry cleaning. The Professional plan is totally worth it. The packaging is also very premium."</p>
            <p className="reviewer">- Rahul, Startup Founder</p>
          </div>
          <div className="masonry-item">
            <div className="stars">⭐⭐⭐⭐⭐</div>
            <p className="review-text">"No more fighting with the iron on Sunday nights! The shirts are comfortable and the customer service team is very responsive."</p>
            <p className="reviewer">- Ananya, Consultant</p>
          </div>
          <div className="masonry-item">
            <div className="stars">⭐⭐⭐⭐⭐</div>
            <p className="review-text">"If you hate doing laundry, get this subscription immediately. It is life-changing. 10/10."</p>
            <p className="reviewer">- Vikas, Developer</p>
          </div>
        </div>
      </div>

      <div className="submit-review-banner section-space bg-light">
        <div className="container text-center">
          <h2>Have you tried Wearbox?</h2>
          <p style={{ maxWidth: '500px', margin: '20px auto', color: 'var(--text-grey)' }}>We'd love to hear about your experience. Your feedback helps us improve and deliver better service every day.</p>
          <button className="btn btn-primary">Leave a Review</button>
        </div>
      </div>
    </div>
  );
};

export default ReviewsPage;
