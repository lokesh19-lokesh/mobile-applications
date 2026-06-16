import React from 'react';
import Hero from '../components/Hero';
import FeaturesBanner from '../components/FeaturesBanner';
import HowItWorks from '../components/HowItWorks';
import Plans from '../components/Plans';
import NewInThisWeek from '../components/NewInThisWeek';
import Reviews from '../components/Reviews';

const Home = () => {
  return (
    <>
      <Hero />
      <div style={{ backgroundColor: '#f9f9f9', padding: '40px 0', borderBottom: '1px solid #eaeaea' }}>
        <div className="container text-center">
          <p style={{ color: 'var(--text-grey)', fontSize: '0.9rem', textTransform: 'uppercase', letterSpacing: '2px', marginBottom: '20px', fontWeight: 'bold' }}>As Featured In</p>
          <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', gap: '40px', flexWrap: 'wrap', opacity: 0.5 }}>
            <h2 style={{ fontFamily: 'Georgia, serif', margin: 0, fontSize: '1.8rem' }}>Forbes</h2>
            <h2 style={{ fontFamily: 'Arial, sans-serif', margin: 0, fontSize: '1.8rem', fontWeight: 900, letterSpacing: '-1px' }}>GQ</h2>
            <h2 style={{ fontFamily: 'Times New Roman, serif', margin: 0, fontSize: '1.8rem', fontStyle: 'italic' }}>The Economic Times</h2>
            <h2 style={{ fontFamily: 'Courier New, monospace', margin: 0, fontSize: '1.8rem', fontWeight: 'bold' }}>TechCrunch</h2>
            <h2 style={{ fontFamily: 'Impact, sans-serif', margin: 0, fontSize: '1.8rem', letterSpacing: '1px' }}>VOGUE</h2>
          </div>
        </div>
      </div>
      <FeaturesBanner />
      <HowItWorks />
      <Plans />
      <NewInThisWeek />
      <Reviews />
    </>
  );
};

export default Home;
