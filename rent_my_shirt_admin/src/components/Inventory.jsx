function Inventory() {
  return (
    <div>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1rem' }}>
        <h1>Inventory Management</h1>
        <button className="btn btn-primary">+ Add New Shirt</button>
      </div>
      
      <div className="table-container">
        <table>
          <thead>
            <tr>
              <th>QR Code</th>
              <th>Shirt Name</th>
              <th>Size</th>
              <th>Condition</th>
              <th>Status</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>QR-1001</td>
              <td>White Slim Fit</td>
              <td>M</td>
              <td>4.8 / 5</td>
              <td><span className="badge available">Available</span></td>
              <td><button className="btn">Edit</button></td>
            </tr>
            <tr>
              <td>QR-1002</td>
              <td>Black Tuxedo</td>
              <td>L</td>
              <td>4.9 / 5</td>
              <td><span className="badge rented">Rented</span></td>
              <td><button className="btn">Edit</button></td>
            </tr>
            <tr>
              <td>QR-1003</td>
              <td>Navy Blue Classic</td>
              <td>S</td>
              <td>3.5 / 5</td>
              <td><span className="badge laundry">Laundry</span></td>
              <td><button className="btn">Edit</button></td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  );
}

export default Inventory;
