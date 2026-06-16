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
      <FeaturesBanner />
      <HowItWorks />
      <Plans />
      <NewInThisWeek />
      <Reviews />
    </>
  );
};

export default Home;
