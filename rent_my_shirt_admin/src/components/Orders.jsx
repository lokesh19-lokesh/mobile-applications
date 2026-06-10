import { useState, useEffect } from 'react';
import { supabase } from '../supabaseClient';

function Orders() {
  const [orders, setOrders] = useState([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    fetchOrders();
  }, []);

  async function fetchOrders() {
    try {
      const { data } = await supabase
        .from('orders')
        .select(`
          *,
          shirts(title),
          customer:profiles!orders_customer_id_fkey(full_name),
          driver:profiles!orders_driver_id_fkey(full_name)
        `)
        .order('created_at', { ascending: false });
        
      setOrders(data || []);
    } catch (e) {
      console.error(e);
    } finally {
      setIsLoading(false);
    }
  }

  return (
    <div>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1rem' }}>
        <h1>Order Tracking</h1>
        <div style={{ display: 'flex', gap: '1rem' }}>
          <button className="btn" style={{ background: 'white', border: '1px solid var(--border)' }} onClick={fetchOrders}>Refresh</button>
        </div>
      </div>
      
      <div className="table-container">
        <table>
          <thead>
            <tr>
              <th>Order ID</th>
              <th>Date</th>
              <th>Customer</th>
              <th>Items</th>
              <th>Total Amount</th>
              <th>Delivery Status</th>
              <th>Assigned Driver</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            {isLoading ? (
              <tr><td colSpan="8" style={{textAlign: 'center'}}>Loading orders...</td></tr>
            ) : orders.map(order => (
              <tr key={order.id}>
                <td>{order.id.split('-')[0]}</td>
                <td>{new Date(order.created_at).toLocaleDateString()}</td>
                <td>{order.customer?.full_name || 'Unknown'}</td>
                <td>{order.shirts?.title || 'Unknown Item'}</td>
                <td>₹{order.total_price}</td>
                <td><span className={`badge ${['delivered', 'completed'].includes(order.status) ? 'success' : 'rented'}`}>{order.status.replace('_', ' ').toUpperCase()}</span></td>
                <td>{order.driver?.full_name || 'Unassigned'}</td>
                <td><button className="btn">View</button></td>
              </tr>
            ))}
            {!isLoading && orders.length === 0 && (
              <tr><td colSpan="8" style={{textAlign: 'center'}}>No orders found.</td></tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
}

export default Orders;
