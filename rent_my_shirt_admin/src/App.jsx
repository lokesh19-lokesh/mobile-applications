import { useState } from 'react';
import './index.css';
import Sidebar from './components/Sidebar';
import Dashboard from './components/Dashboard';
import Inventory from './components/Inventory';

function App() {
  const [activeTab, setActiveTab] = useState('dashboard');

  return (
    <div className="app-container">
      <Sidebar activeTab={activeTab} setActiveTab={setActiveTab} />
      <main className="main-content">
        {activeTab === 'dashboard' && <Dashboard />}
        {activeTab === 'inventory' && <Inventory />}
        {activeTab === 'orders' && <div><h2>Orders Management</h2><p>Coming soon...</p></div>}
        {activeTab === 'users' && <div><h2>User Management</h2><p>Coming soon...</p></div>}
      </main>
    </div>
  );
}

export default App;
