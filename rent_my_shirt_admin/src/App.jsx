import { useState } from 'react';
import './index.css';
import Sidebar from './components/Sidebar';
import Dashboard from './components/Dashboard';
import Inventory from './components/Inventory';
import Orders from './components/Orders';
import Users from './components/Users';
import LandingPage from './components/LandingPage';

function App() {
  const [activeTab, setActiveTab] = useState('landing');

  if (activeTab === 'landing') {
    return <LandingPage onLogin={() => setActiveTab('dashboard')} />;
  }

  return (
    <div className="app-container">
      <Sidebar activeTab={activeTab} setActiveTab={setActiveTab} />
      <main className="main-content">
        {activeTab === 'dashboard' && <Dashboard />}
        {activeTab === 'inventory' && <Inventory />}
        {activeTab === 'orders' && <Orders />}
        {activeTab === 'users' && <Users />}
      </main>
    </div>
  );
}

export default App;
