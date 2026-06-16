import React from 'react';
import { Link, useNavigate } from 'react-router-dom';
import './Plans.css';

const plans = [
  { title: 'Starter', price: '1499', feature: '3 Shirts', desc: 'Perfect for getting started', popular: false },
  { title: 'Professional', price: '2499', feature: '4 Shirts + 1 Tee', desc: 'Our best-selling plan', popular: true },
  { title: 'Executive', price: '3999', feature: 'Premium Collection', desc: 'Premium shirts. Premium you.', popular: false },
];

const Plans = () => {
  const navigate = useNavigate();
  return (
    <div className="plans container section-space">
      <div className="section-header">
        <div>
          <h2 className="section-title">Choose Your Plan</h2>
          <p className="section-subtitle">Simple plans. Premium experience.</p>
        </div>
        <Link to="/plans" className="view-all">View all plans</Link>
      </div>
      
      <div className="plans-container">
        {plans.map((plan, idx) => (
          <div key={idx} className={`plan-card ${plan.popular ? 'popular' : ''}`}>
            {plan.popular && <div className="popular-badge">MOST POPULAR</div>}
            <div className="plan-title">{plan.title}</div>
            <div className="plan-price">₹{plan.price}<span className="plan-month">/month</span></div>
            <div className="plan-feature">{plan.feature}</div>
            <div className="plan-desc">{plan.desc}</div>
            <button className={`btn plan-btn ${plan.popular ? 'btn-primary' : 'btn-outline-red'}`} onClick={() => navigate('/plans')}>
              Select Plan {plan.popular ? '' : '>'}
            </button>
          </div>
        ))}
      </div>
    </div>
  );
};

export default Plans;
