import React, { useState } from 'react';
import './FAQPage.css';

const faqs = [
  { question: "How does the subscription work?", answer: "Choose a plan, select your sizes and preferences, and we'll deliver a box of freshly dry-cleaned, ironed shirts to your door every Monday. We'll pick up the worn shirts from the previous week at the same time." },
  { question: "Can I choose my own shirts?", answer: "Yes! You can browse our collection and select the exact styles you want for your upcoming deliveries, or you can let our stylists curate a box based on your preferences." },
  { question: "What if a shirt gets stained or damaged?", answer: "Don't worry. Minor stains and normal wear-and-tear are fully covered by your subscription. Just return it in the bag and we'll handle the rest." },
  { question: "How do I pause or cancel?", answer: "You can pause your subscription for vacations or cancel at any time directly from your dashboard with no hidden fees." },
  { question: "What sizes do you offer?", answer: "We offer sizes from S to XXL in both slim and regular fits. If a shirt doesn't fit right, you can exchange it instantly." }
];

const FAQPage = () => {
  const [openIndex, setOpenIndex] = useState(0);

  return (
    <div className="faq-page">
      <div className="faq-header bg-light section-space">
        <div className="container text-center">
          <h1 className="about-title" style={{ fontSize: '3.5rem', marginBottom: '20px' }}>Frequently Asked <span className="text-red">Questions</span></h1>
          <p className="about-subtitle" style={{ fontSize: '1.25rem', color: 'var(--text-grey)', maxWidth: '600px', margin: '0 auto' }}>Everything you need to know about the Wearbox experience.</p>
        </div>
      </div>

      <div className="container section-space">
        <div className="faq-wrapper">
          <div className="faq-accordion">
            {faqs.map((faq, index) => (
              <div 
                key={index} 
                className={`faq-item ${openIndex === index ? 'active' : ''}`}
                onClick={() => setOpenIndex(index === openIndex ? -1 : index)}
              >
                <div className="faq-question">
                  <h3>{faq.question}</h3>
                  <span className="faq-toggle">{openIndex === index ? '−' : '+'}</span>
                </div>
                {openIndex === index && (
                  <div className="faq-answer">
                    <p>{faq.answer}</p>
                  </div>
                )}
              </div>
            ))}
          </div>

          <div className="contact-box">
            <h2>Still have questions?</h2>
            <p>Our support team is here to help you.</p>
            <div className="contact-methods">
              <div className="contact-method">
                <span className="icon">📞</span>
                <div>
                  <strong>Call Us</strong>
                  <p>+91 94937 02966</p>
                </div>
              </div>
              <div className="contact-method">
                <span className="icon">✉️</span>
                <div>
                  <strong>Email Us</strong>
                  <p>support@wearbox.com</p>
                </div>
              </div>
            </div>
            <button className="btn btn-outline" style={{ width: '100%', marginTop: '20px' }}>Open Contact Form</button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default FAQPage;
