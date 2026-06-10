function Sidebar({ activeTab, setActiveTab }) {
  const menuItems = [
    { id: 'dashboard', label: 'Dashboard Overview', icon: '📊' },
    { id: 'inventory', label: 'Inventory Management', icon: '👔' },
    { id: 'orders', label: 'Order Tracking', icon: '📦' },
    { id: 'users', label: 'Users & Deposits', icon: '👥' },
  ];

  return (
    <aside className="sidebar">
      <div className="sidebar-header">
        <h2>RentMyShirt Admin</h2>
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
    </aside>
  );
}

export default Sidebar;
