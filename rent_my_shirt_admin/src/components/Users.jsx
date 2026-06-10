function Users() {
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
          <div className="card-value">1,245</div>
        </div>
        <div className="card">
          <div className="card-title">Deposits Collected</div>
          <div className="card-value">₹62,25,000</div>
        </div>
        <div className="card">
          <div className="card-title">Refunds Pending</div>
          <div className="card-value">₹25,000</div>
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
            <tr>
              <td>#USR-104</td>
              <td>John Doe</td>
              <td>+91 9876543210</td>
              <td>1</td>
              <td><span className="badge available">Paid (₹5000)</span></td>
              <td><span className="badge available">Active</span></td>
              <td><button className="btn">Manage</button></td>
            </tr>
            <tr>
              <td>#USR-105</td>
              <td>Sarah Connor</td>
              <td>+91 9876543211</td>
              <td>0</td>
              <td><span className="badge rented">Refund Requested</span></td>
              <td><span className="badge rented">Closing</span></td>
              <td><button className="btn btn-primary" style={{ padding: '0.25rem 0.5rem', fontSize: '0.75rem', backgroundColor: 'var(--danger)' }}>Process Refund</button></td>
            </tr>
            <tr>
              <td>#USR-106</td>
              <td>Bruce Wayne</td>
              <td>+91 9876543212</td>
              <td>2</td>
              <td><span className="badge available">Paid (₹5000)</span></td>
              <td><span className="badge available">Active</span></td>
              <td><button className="btn">Manage</button></td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  );
}

export default Users;
