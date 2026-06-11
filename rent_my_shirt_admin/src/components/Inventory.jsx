import { useState, useEffect } from 'react';
import { supabase } from '../supabaseClient';

function Inventory() {
  const [inventory, setInventory] = useState([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    fetchInventory();
  }, []);

  async function fetchInventory() {
    try {
      const { data, error } = await supabase
        .from('shirt_inventory')
        .select('*, shirts(name)')
        .order('created_at', { ascending: false });
        
      if (error) throw error;
      setInventory(data || []);
    } catch (error) {
      console.error('Error fetching inventory:', error);
    } finally {
      setIsLoading(false);
    }
  }
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
            {isLoading ? (
              <tr><td colSpan="6" style={{textAlign: 'center'}}>Loading inventory...</td></tr>
            ) : inventory.map(item => (
              <tr key={item.id}>
                <td>{item.qr_code || item.id.split('-')[0]}</td>
                <td>{item.shirts?.name || 'Unknown Shirt'}</td>
                <td>{item.size}</td>
                <td>{item.condition_rating} / 5</td>
                <td>
                  <span className={`badge ${item.status === 'AVAILABLE' ? 'available' : item.status === 'RENTED' ? 'rented' : 'laundry'}`}>
                    {item.status}
                  </span>
                </td>
                <td><button className="btn">Edit</button></td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}

export default Inventory;
