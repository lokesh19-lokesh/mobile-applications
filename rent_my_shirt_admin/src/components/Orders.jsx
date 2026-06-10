function Orders() {
  return (
    <div>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1rem' }}>
        <h1>Order Tracking</h1>
        <div style={{ display: 'flex', gap: '1rem' }}>
          <button className="btn" style={{ background: 'white', border: '1px solid var(--border)' }}>Filter by Status</button>
          <button className="btn btn-primary">Assign Driver</button>
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
            <tr>
              <td>#ORD-8921</td>
              <td>10 Jun 2026</td>
              <td>John Doe</td>
              <td>White Slim Fit (M)</td>
              <td>₹850</td>
              <td><span className="badge rented">Out for Delivery</span></td>
              <td>Michael D.</td>
              <td><button className="btn">View</button></td>
            </tr>
            <tr>
              <td>#ORD-8922</td>
              <td>11 Jun 2026</td>
              <td>Sarah Connor</td>
              <td>Black Tuxedo (L)</td>
              <td>₹1500</td>
              <td><span className="badge available">Pending Pickup</span></td>
              <td>Unassigned</td>
              <td><button className="btn btn-primary" style={{ padding: '0.25rem 0.5rem', fontSize: '0.75rem' }}>Assign</button></td>
            </tr>
            <tr>
              <td>#ORD-8923</td>
              <td>12 Jun 2026</td>
              <td>Bruce Wayne</td>
              <td>Navy Classic (S)</td>
              <td>₹1200</td>
              <td><span className="badge success">Delivered</span></td>
              <td>Alfred P.</td>
              <td><button className="btn">View</button></td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  );
}

export default Orders;
