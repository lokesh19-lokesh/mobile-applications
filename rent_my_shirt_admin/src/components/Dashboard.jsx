import { useState, useEffect } from 'react';
import { supabase } from '../supabaseClient';

function Dashboard() {
  const [orders, setOrders] = useState([]);
  const [stats, setStats] = useState({ users: 0, rentals: 0, deposits: 0, revenue: 0 });

  useEffect(() => {
    fetchData();
  }, []);

  async function fetchData() {
    try {
      const { data: ordersData } = await supabase.from('orders').select('*, shirt_inventory(shirts(name)), customer_profiles!orders_user_id_fkey(first_name, last_name)').order('created_at', { ascending: false }).limit(5);
      const { count: usersCount } = await supabase.from('customer_profiles').select('*', { count: 'exact', head: true });
      const { count: activeRentals } = await supabase.from('orders').select('*', { count: 'exact', head: true }).in('status', ['OUT_FOR_DELIVERY', 'DELIVERED', 'RETURN_REQUESTED']);
      
      // Calculate Monthly Revenue dynamically
      const startOfMonth = new Date();
      startOfMonth.setDate(1);
      startOfMonth.setHours(0, 0, 0, 0);
      
      const { data: revenueData } = await supabase
        .from('orders')
        .select('total_price')
        .gte('created_at', startOfMonth.toISOString())
        .in('status', ['COMPLETED', 'DELIVERED', 'RETURNED']);
        
      let totalRevenue = 0;
      if (revenueData && revenueData.length > 0) {
        totalRevenue = revenueData.reduce((sum, order) => sum + (Number(order.total_price) || 0), 0);
      }
      
      setOrders(ordersData || []);
      setStats({
        users: usersCount || 0,
        rentals: activeRentals || 0,
        deposits: (usersCount || 0) * 5000,
        revenue: totalRevenue,
      });
    } catch (e) {
      console.error(e);
    }
  }

  return (
    <div>
      <h1>Dashboard Overview</h1>
      <div className="grid-cards">
        <div className="card">
          <div className="card-title">Total Users</div>
          <div className="card-value">{stats.users}</div>
        </div>
        <div className="card">
          <div className="card-title">Active Rentals</div>
          <div className="card-value">{stats.rentals}</div>
        </div>
        <div className="card">
          <div className="card-title">Deposits Held</div>
          <div className="card-value">₹{stats.deposits.toLocaleString('en-IN')}</div>
        </div>
        <div className="card">
          <div className="card-title">Monthly Revenue</div>
          <div className="card-value">₹{stats.revenue.toLocaleString('en-IN')}</div>
        </div>
      </div>
      
      <h3>Recent Orders</h3>
      <div className="table-container">
        <table>
          <thead>
            <tr>
              <th>Order ID</th>
              <th>Customer</th>
              <th>Item</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody>
            {orders.map(order => (
              <tr key={order.id}>
                <td>{order.id.split('-')[0]}</td>
                <td>{order.customer_profiles ? `${order.customer_profiles.first_name} ${order.customer_profiles.last_name || ''}` : 'Unknown'}</td>
                <td>{order.shirt_inventory?.shirts?.name || 'Unknown Shirt'}</td>
                <td>
                  <span className={`badge ${['DELIVERED', 'COMPLETED'].includes(order.status) ? 'available' : 'rented'}`}>
                    {order.status.replace('_', ' ').toUpperCase()}
                  </span>
                </td>
              </tr>
            ))}
            {orders.length === 0 && (
              <tr><td colSpan="4">No recent orders found. The list will update automatically when a customer places an order.</td></tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
}

export default Dashboard;
