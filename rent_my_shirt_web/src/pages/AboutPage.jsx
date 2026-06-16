import React from 'react';

const AboutPage = () => {
  return (
    <div style={{ paddingTop: '120px', minHeight: '80vh', textAlign: 'center', fontFamily: 'var(--font-body)' }}>
      <div className="container">
        <h2 style={{ fontSize: '32px', marginBottom: '20px' }}>About Us</h2>
        <p style={{ color: 'var(--text-grey)', maxWidth: '600px', margin: '0 auto', lineHeight: '1.6' }}>
          We are Wearbox, providing premium workwear on a hassle-free subscription basis. 
          Our mission is to ensure professionals in India always have fresh, perfectly fitted shirts without the burden of laundry or ironing.
        </p>
      </div>
    </div>
  );
};

export default AboutPage;
