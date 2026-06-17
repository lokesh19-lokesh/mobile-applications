import { useNavigate } from 'react-router-dom';
import { supabase } from '../supabaseClient';
import { FiLogOut } from 'react-icons/fi';

function Sidebar({ activeTab, setActiveTab }) {
  const navigate = useNavigate();
  
  const menuItems = [
    { id: 'dashboard', label: 'Dashboard Overview', icon: '📊' },
    { id: 'inventory', label: 'Inventory Management', icon: '👔' },
    { id: 'orders', label: 'Order Tracking', icon: '📦' },
    { id: 'users', label: 'Users & Deposits', icon: '👥' },
  ];

  const handleLogout = async () => {
    await supabase.auth.signOut();
    navigate('/login');
  };

  return (
    <aside className="sidebar flex flex-col justify-between">
      <div>
        <div className="sidebar-header">
          <h2>Wearbox Admin</h2>
        </div>
        <ul className="sidebar-nav">
          {menuItems.map((item) => (
            <li
              key={item.id}
              className={activeTab === item.id ? 'active' : ''}
              onClick={() => setActiveTab(item.id)}
            >
              <span>{item.icon}</span>
              {item.label}
            </li>
          ))}
        </ul>
      </div>
      
      <div className="p-4 mt-auto border-t border-gray-100">
        <button 
          onClick={handleLogout}
          className="w-full flex items-center justify-center gap-2 px-4 py-3 text-red-500 hover:bg-red-50 hover:text-red-600 rounded-lg transition-colors cursor-pointer font-medium"
        >
          <FiLogOut size={18} />
          <span>Logout</span>
        </button>
      </div>
    </aside>
  );
}

export default Sidebar;
