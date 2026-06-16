import React from 'react';

const FAQPage = () => {
  return (
    <div style={{ paddingTop: '120px', minHeight: '80vh', textAlign: 'center', fontFamily: 'var(--font-body)' }}>
      <div className="container">
        <h2 style={{ fontSize: '32px', marginBottom: '20px' }}>FAQ & Support</h2>
        <p style={{ color: 'var(--text-grey)', maxWidth: '600px', margin: '0 auto', lineHeight: '1.6' }}>
          Have questions? We're here to help. Contact us at support@wearbox.com or call us at +91 94937 02966.
        </p>
      </div>
    </div>
  );
};

export default FAQPage;
