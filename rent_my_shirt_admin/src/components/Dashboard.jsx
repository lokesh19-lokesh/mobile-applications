function Dashboard() {
  return (
    <div>
      <h1>Dashboard Overview</h1>
      <div className="grid-cards">
        <div className="card">
          <div className="card-title">Total Users</div>
          <div className="card-value">1,245</div>
        </div>
        <div className="card">
          <div className="card-title">Active Rentals</div>
          <div className="card-value">342</div>
        </div>
        <div className="card">
          <div className="card-title">Deposits Held</div>
          <div className="card-value">₹17,10,000</div>
        </div>
        <div className="card">
          <div className="card-title">Monthly Revenue</div>
          <div className="card-value">₹4,25,000</div>
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
            <tr>
              <td>#ORD-8921</td>
              <td>John Doe</td>
              <td>White Slim Fit (M)</td>
              <td><span className="badge rented">Out for Delivery</span></td>
            </tr>
            <tr>
              <td>#ORD-8920</td>
              <td>Jane Smith</td>
              <td>Navy Blue Classic (S)</td>
              <td><span className="badge available">Returned</span></td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  );
}

export default Dashboard;
