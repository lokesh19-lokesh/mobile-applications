import React from 'react';
import Navbar from './components/Navbar';
import Hero from './components/Hero';
import FeaturesBanner from './components/FeaturesBanner';
import HowItWorks from './components/HowItWorks';
import Plans from './components/Plans';
import NewInThisWeek from './components/NewInThisWeek';
import Reviews from './components/Reviews';
import Footer from './components/Footer';

function App() {
  return (
    <div className="app">
      <Navbar />
      <Hero />
      <FeaturesBanner />
      <HowItWorks />
      <Plans />
      <NewInThisWeek />
      <Reviews />
      <Footer />
    </div>
  );
}

export default App;
