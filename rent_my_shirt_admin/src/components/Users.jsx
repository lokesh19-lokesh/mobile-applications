import { useState, useEffect } from 'react';
import { supabase } from '../supabaseClient';

function Users() {
  const [users, setUsers] = useState([]);
  const [stats, setStats] = useState({ total: 0, deposits: 0, refunds: 0 });
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    fetchUsers();
  }, []);

  async function fetchUsers() {
    try {
      const { data: profiles, error } = await supabase
        .from('customer_profiles')
        .select('*, users(phone), deposits(amount, status), orders(id)')
        .order('created_at', { ascending: false });
        
      if (error) throw error;
      
      let totalDeposits = 0;
      let totalRefunds = 0;
      
      const mappedUsers = profiles.map(profile => {
        const activeOrders = profile.orders?.length || 0;
        const deposit = profile.deposits?.[0]; // Assuming 1 deposit per user for demo
        
        if (deposit?.status === 'HELD') totalDeposits += parseFloat(deposit.amount || 5000);
        if (deposit?.status === 'REFUNDED') totalRefunds += parseFloat(deposit.amount || 5000);
        
        return {
          ...profile,
          phone: profile.users?.phone,
          activeOrders,
          depositStatus: deposit ? deposit.status : 'UNPAID',
          depositAmount: deposit ? deposit.amount : 0
        };
      });
      
      setUsers(mappedUsers);
      setStats({
        total: mappedUsers.length,
        deposits: totalDeposits,
        refunds: totalRefunds
      });
    } catch (error) {
      console.error('Error fetching users:', error);
    } finally {
      setIsLoading(false);
    }
  }
  return (
    <div>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1rem' }}>
        <h1>Users & Deposits</h1>
        <div style={{ display: 'flex', gap: '1rem' }}>
          <button className="btn" style={{ background: 'white', border: '1px solid var(--border)' }}>Search User</button>
          <button className="btn btn-primary">Export CSV</button>
        </div>
      </div>

      <div className="grid-cards" style={{ gridTemplateColumns: 'repeat(3, 1fr)', marginBottom: '2rem' }}>
        <div className="card">
          <div className="card-title">Total Active Users</div>
          <div className="card-value">{stats.total}</div>
        </div>
        <div className="card">
          <div className="card-title">Deposits Collected</div>
          <div className="card-value">₹{stats.deposits.toLocaleString()}</div>
        </div>
        <div className="card">
          <div className="card-title">Refunds Processed</div>
          <div className="card-value">₹{stats.refunds.toLocaleString()}</div>
        </div>
      </div>
      
      <div className="table-container">
        <table>
          <thead>
            <tr>
              <th>User ID</th>
              <th>Name</th>
              <th>Phone</th>
              <th>Active Rentals</th>
              <th>Deposit Status</th>
              <th>Account Status</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            {isLoading ? (
              <tr><td colSpan="7" style={{textAlign: 'center'}}>Loading users...</td></tr>
            ) : users.map(user => (
              <tr key={user.id}>
                <td>{user.id.split('-')[0]}</td>
                <td>{user.first_name} {user.last_name || ''}</td>
                <td>{user.phone || 'N/A'}</td>
                <td>{user.activeOrders}</td>
                <td>
                  <span className={`badge ${user.depositStatus === 'HELD' ? 'available' : 'rented'}`}>
                    {user.depositStatus === 'HELD' ? `Paid (₹${user.depositAmount})` : user.depositStatus}
                  </span>
                </td>
                <td><span className={`badge ${user.kyc_status === 'VERIFIED' ? 'available' : 'laundry'}`}>{user.kyc_status}</span></td>
                <td>
                  <button className="btn">Manage</button>
                  {user.depositStatus === 'REFUND_REQUESTED' && (
                    <button className="btn btn-primary" style={{ marginLeft: '0.5rem', padding: '0.25rem 0.5rem', fontSize: '0.75rem', backgroundColor: 'var(--danger)' }}>Process Refund</button>
                  )}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}

export default Users;
