import { useState, useEffect } from 'react';
import { supabase } from '../supabaseClient';
import { FiEdit2 as EditIcon, FiTrash2 as TrashIcon, FiX as CloseIcon, FiPlus as PlusIcon } from 'react-icons/fi';

function Inventory() {
  const [activeTab, setActiveTab] = useState('inventory'); // 'inventory' or 'designs'
  
  // Data State
  const [inventory, setInventory] = useState([]);
  const [shirts, setShirts] = useState([]);
  const [categories, setCategories] = useState([]);
  
  const [isLoading, setIsLoading] = useState(true);
  
  // Modal State
  const [isInvModalOpen, setIsInvModalOpen] = useState(false);
  const [isDesignModalOpen, setIsDesignModalOpen] = useState(false);
  
  const [editingInvId, setEditingInvId] = useState(null);
  const [editingDesignId, setEditingDesignId] = useState(null);
  
  const [isSubmitting, setIsSubmitting] = useState(false);

  // Forms
  const [invFormData, setInvFormData] = useState({
    shirt_id: '', size: 'M', color: '', qr_code: '', status: 'AVAILABLE'
  });
  
  const [designFormData, setDesignFormData] = useState({
    name: '', category_id: '', brand: 'Wearbox', description: '', 
    price_1_day: '', price_1_week: '', price_1_month: '', image_url: ''
  });
  const [imageFile, setImageFile] = useState(null);
  const [imagePreview, setImagePreview] = useState('');

  useEffect(() => {
    fetchCategories();
    fetchShirts();
    fetchInventory();
  }, []);

  async function fetchCategories() {
    try {
      const { data, error } = await supabase.from('shirt_categories').select('*').order('name');
      if (error) throw error;
      setCategories(data || []);
    } catch (error) {
      console.error('Error fetching categories:', error);
    }
  }

  async function fetchShirts() {
    setIsLoading(true);
    try {
      const { data, error } = await supabase.from('shirts').select('*, shirt_categories(name)').order('name');
      if (error) throw error;
      setShirts(data || []);
    } catch (error) {
      console.error('Error fetching shirts:', error);
    } finally {
      setIsLoading(false);
    }
  }

  async function fetchInventory() {
    setIsLoading(true);
    try {
      const { data, error } = await supabase.from('shirt_inventory').select('*, shirts(name)');
      if (error) throw error;
      setInventory(data || []);
    } catch (error) {
      console.error('Error fetching inventory:', error);
    } finally {
      setIsLoading(false);
    }
  }

  // Inventory Handlers
  const openInvAddModal = () => {
    setEditingInvId(null);
    setInvFormData({
      shirt_id: shirts.length > 0 ? shirts[0].id : '',
      size: 'M', color: '', qr_code: `QR-${Math.random().toString(36).substring(2, 8).toUpperCase()}`, status: 'AVAILABLE'
    });
    setIsInvModalOpen(true);
  };

  const openInvEditModal = (item) => {
    setEditingInvId(item.id);
    setInvFormData({
      shirt_id: item.shirt_id, size: item.size || 'M', color: item.color || '', qr_code: item.qr_code || '', status: item.status || 'AVAILABLE'
    });
    setIsInvModalOpen(true);
  };

  const handleInvSubmit = async (e) => {
    e.preventDefault();
    setIsSubmitting(true);
    try {
      if (editingInvId) {
        const { error } = await supabase.from('shirt_inventory').update(invFormData).eq('id', editingInvId);
        if (error) throw error;
      } else {
        const { error } = await supabase.from('shirt_inventory').insert([invFormData]);
        if (error) throw error;
      }
      setIsInvModalOpen(false);
      fetchInventory();
    } catch (error) {
      alert('Failed to save item: ' + error.message);
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleInvDelete = async (id) => {
    if (!window.confirm('Are you sure you want to delete this unit?')) return;
    try {
      const { error } = await supabase.from('shirt_inventory').delete().eq('id', id);
      if (error) throw error;
      fetchInventory();
    } catch (error) {
      alert('Failed to delete item: ' + error.message);
    }
  };

  // Design Handlers
  const openDesignAddModal = () => {
    setEditingDesignId(null);
    setDesignFormData({
      name: '', category_id: categories.length > 0 ? categories[0].id : '', brand: 'Wearbox', description: '', price_1_day: '', price_1_week: '', price_1_month: '', image_url: ''
    });
    setImageFile(null);
    setImagePreview('');
    setIsDesignModalOpen(true);
  };

  const openDesignEditModal = (item) => {
    setEditingDesignId(item.id);
    setDesignFormData({
      name: item.name, category_id: item.category_id, brand: item.brand || '', description: item.description || '', 
      price_1_day: item.price_1_day || '', price_1_week: item.price_1_week || '', price_1_month: item.price_1_month || '', image_url: item.image_url || ''
    });
    setImageFile(null);
    setImagePreview(item.image_url || '');
    setIsDesignModalOpen(true);
  };

  const uploadImage = async () => {
    if (!imageFile) return designFormData.image_url;
    const fileExt = imageFile.name.split('.').pop();
    const fileName = `${Math.random().toString(36).substring(2, 15)}.${fileExt}`;
    const filePath = `${fileName}`;

    const { error: uploadError } = await supabase.storage
      .from('shirt_images')
      .upload(filePath, imageFile);

    if (uploadError) throw uploadError;

    const { data } = supabase.storage.from('shirt_images').getPublicUrl(filePath);
    return data.publicUrl;
  };

  const handleDesignSubmit = async (e) => {
    e.preventDefault();
    setIsSubmitting(true);
    try {
      const publicUrl = await uploadImage();
      const payload = { ...designFormData, image_url: publicUrl };

      if (editingDesignId) {
        const { error } = await supabase.from('shirts').update(payload).eq('id', editingDesignId);
        if (error) throw error;
      } else {
        const { error } = await supabase.from('shirts').insert([payload]);
        if (error) throw error;
      }
      setIsDesignModalOpen(false);
      fetchShirts();
    } catch (error) {
      alert('Failed to save design: ' + error.message);
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleDesignDelete = async (id) => {
    if (!window.confirm('Are you sure you want to delete this design? NOTE: You must delete all its physical units first.')) return;
    try {
      const { error } = await supabase.from('shirts').delete().eq('id', id);
      if (error) throw error;
      fetchShirts();
    } catch (error) {
      alert('Failed to delete design: ' + error.message);
    }
  };

  // Drag and Drop handlers
  const handleDragOver = (e) => {
    e.preventDefault();
  };

  const handleDrop = (e) => {
    e.preventDefault();
    if (e.dataTransfer.files && e.dataTransfer.files[0]) {
      const file = e.dataTransfer.files[0];
      setImageFile(file);
      setImagePreview(URL.createObjectURL(file));
    }
  };

  const handleImageSelect = (e) => {
    if (e.target.files && e.target.files[0]) {
      const file = e.target.files[0];
      setImageFile(file);
      setImagePreview(URL.createObjectURL(file));
    }
  };

  return (
    <div>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1.5rem' }}>
        <h1>{activeTab === 'inventory' ? 'Physical Inventory' : 'Shirt Designs'}</h1>
        
        <div style={{ display: 'flex', gap: '1rem' }}>
          <div style={{ backgroundColor: 'rgba(255,255,255,0.05)', borderRadius: '8px', padding: '4px', display: 'flex', gap: '4px' }}>
            <button 
              onClick={() => setActiveTab('inventory')}
              style={{ padding: '8px 16px', borderRadius: '6px', border: 'none', background: activeTab === 'inventory' ? 'var(--primary)' : 'transparent', color: activeTab === 'inventory' ? 'white' : 'var(--text-secondary)', cursor: 'pointer', transition: 'all 0.2s' }}
            >
              Physical Units
            </button>
            <button 
              onClick={() => setActiveTab('designs')}
              style={{ padding: '8px 16px', borderRadius: '6px', border: 'none', background: activeTab === 'designs' ? 'var(--primary)' : 'transparent', color: activeTab === 'designs' ? 'white' : 'var(--text-secondary)', cursor: 'pointer', transition: 'all 0.2s' }}
            >
              Shirt Designs
            </button>
          </div>

          {activeTab === 'inventory' ? (
            <button className="btn btn-primary" onClick={openInvAddModal}>
              <PlusIcon style={{ display: 'inline-flex', verticalAlign: 'middle', marginRight: '5px' }} /> Add Physical Unit
            </button>
          ) : (
            <button className="btn btn-primary" onClick={openDesignAddModal}>
              <PlusIcon style={{ display: 'inline-flex', verticalAlign: 'middle', marginRight: '5px' }} /> Add New Design
            </button>
          )}
        </div>
      </div>
      
      {activeTab === 'inventory' && (
        <div className="table-container fade-in">
          <table>
            <thead>
              <tr>
                <th>QR Code</th>
                <th>Shirt Name</th>
                <th>Size</th>
                <th>Color</th>
                <th>Status</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {isLoading ? (
                <tr><td colSpan="6" style={{textAlign: 'center', padding: '2rem'}}>Loading inventory...</td></tr>
              ) : inventory.length === 0 ? (
                 <tr><td colSpan="6" style={{textAlign: 'center', padding: '2rem'}}>No inventory items found. Add one!</td></tr>
              ) : inventory.map(item => (
                <tr key={item.id}>
                  <td><span style={{fontFamily: 'monospace', background: 'rgba(255,255,255,0.1)', padding: '2px 6px', borderRadius: '4px'}}>{item.qr_code || item.id.split('-')[0]}</span></td>
                  <td>{item.shirts?.name || 'Unknown Shirt'}</td>
                  <td>{item.size}</td>
                  <td>{item.color || 'N/A'}</td>
                  <td>
                    <span className={`badge ${item.status === 'AVAILABLE' ? 'available' : item.status === 'RENTED' ? 'rented' : 'laundry'}`}>
                      {item.status}
                    </span>
                  </td>
                  <td>
                    <div style={{ display: 'flex', gap: '0.5rem' }}>
                      <button className="btn" style={{ padding: '0.4rem' }} onClick={() => openInvEditModal(item)} title="Edit">
                        <EditIcon />
                      </button>
                      <button className="btn" style={{ padding: '0.4rem', color: '#ff4d4d', borderColor: '#ff4d4d' }} onClick={() => handleInvDelete(item.id)} title="Delete">
                        <TrashIcon />
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}

      {activeTab === 'designs' && (
        <div className="table-container fade-in">
          <table>
            <thead>
              <tr>
                <th>Design Name</th>
                <th>Category</th>
                <th>Brand</th>
                <th>Price / Day</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {isLoading ? (
                <tr><td colSpan="5" style={{textAlign: 'center', padding: '2rem'}}>Loading designs...</td></tr>
              ) : shirts.length === 0 ? (
                 <tr><td colSpan="5" style={{textAlign: 'center', padding: '2rem'}}>No designs found. Create one!</td></tr>
              ) : shirts.map(item => (
                <tr key={item.id}>
                  <td style={{fontWeight: 'bold'}}>{item.name}</td>
                  <td>{item.shirt_categories?.name || 'Unknown Category'}</td>
                  <td>{item.brand}</td>
                  <td>₹{item.price_1_day}</td>
                  <td>
                    <div style={{ display: 'flex', gap: '0.5rem' }}>
                      <button className="btn" style={{ padding: '0.4rem' }} onClick={() => openDesignEditModal(item)} title="Edit">
                        <EditIcon />
                      </button>
                      <button className="btn" style={{ padding: '0.4rem', color: '#ff4d4d', borderColor: '#ff4d4d' }} onClick={() => handleDesignDelete(item.id)} title="Delete">
                        <TrashIcon />
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}

      {/* Inventory Modal */}
      {isInvModalOpen && (
        <div className="modal-overlay" style={{
          position: 'fixed', top: 0, left: 0, right: 0, bottom: 0,
          backgroundColor: 'rgba(0,0,0,0.7)', backdropFilter: 'blur(5px)',
          display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 1000
        }}>
          <div className="modal-content" style={{
            backgroundColor: 'var(--surface)', padding: '2rem', borderRadius: '12px',
            width: '90%', maxWidth: '500px', border: '1px solid var(--border)', boxShadow: '0 10px 25px rgba(0,0,0,0.5)'
          }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1.5rem' }}>
              <h2 style={{ margin: 0 }}>{editingInvId ? 'Edit Physical Unit' : 'Add Physical Unit'}</h2>
              <button onClick={() => setIsInvModalOpen(false)} style={{ background: 'none', border: 'none', color: 'var(--text-secondary)', cursor: 'pointer' }}>
                <CloseIcon size={24} />
              </button>
            </div>

            <form onSubmit={handleInvSubmit} style={{ display: 'flex', flexDirection: 'column', gap: '1rem' }}>
              <div style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem' }}>
                <label>Shirt Design</label>
                <select 
                  name="shirt_id" value={invFormData.shirt_id} 
                  onChange={(e) => setInvFormData(prev => ({ ...prev, shirt_id: e.target.value }))} required
                  style={{ padding: '0.8rem', borderRadius: '8px', border: '1px solid var(--border)', backgroundColor: 'rgba(255,255,255,0.05)', color: 'var(--text-primary)' }}
                >
                  <option value="" disabled>Select a design...</option>
                  {shirts.map(shirt => <option key={shirt.id} value={shirt.id}>{shirt.name}</option>)}
                </select>
              </div>

              <div style={{ display: 'flex', gap: '1rem' }}>
                <div style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem', flex: 1 }}>
                  <label>Size</label>
                  <select name="size" value={invFormData.size} onChange={(e) => setInvFormData(prev => ({ ...prev, size: e.target.value }))} style={{ padding: '0.8rem', borderRadius: '8px', border: '1px solid var(--border)', backgroundColor: 'rgba(255,255,255,0.05)', color: 'var(--text-primary)' }}>
                    <option value="S">Small (S)</option><option value="M">Medium (M)</option><option value="L">Large (L)</option><option value="XL">Extra Large (XL)</option>
                  </select>
                </div>
                <div style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem', flex: 1 }}>
                  <label>Status</label>
                  <select name="status" value={invFormData.status} onChange={(e) => setInvFormData(prev => ({ ...prev, status: e.target.value }))} style={{ padding: '0.8rem', borderRadius: '8px', border: '1px solid var(--border)', backgroundColor: 'rgba(255,255,255,0.05)', color: 'var(--text-primary)' }}>
                    <option value="AVAILABLE">AVAILABLE</option><option value="RENTED">RENTED</option><option value="LAUNDRY">LAUNDRY</option><option value="MAINTENANCE">MAINTENANCE</option>
                  </select>
                </div>
              </div>

              <div style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem' }}>
                <label>Color</label>
                <input type="text" name="color" value={invFormData.color} onChange={(e) => setInvFormData(prev => ({ ...prev, color: e.target.value }))} placeholder="e.g. Black, Floral, White" style={{ padding: '0.8rem', borderRadius: '8px', border: '1px solid var(--border)', backgroundColor: 'rgba(255,255,255,0.05)', color: 'var(--text-primary)' }} />
              </div>

              <div style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem' }}>
                <label>QR Code</label>
                <input type="text" name="qr_code" value={invFormData.qr_code} onChange={(e) => setInvFormData(prev => ({ ...prev, qr_code: e.target.value }))} required placeholder="QR-TUX-L-01" style={{ padding: '0.8rem', borderRadius: '8px', border: '1px solid var(--border)', backgroundColor: 'rgba(255,255,255,0.05)', color: 'var(--text-primary)', fontFamily: 'monospace' }} />
              </div>

              <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '1rem', marginTop: '1rem' }}>
                <button type="button" className="btn" onClick={() => setIsInvModalOpen(false)}>Cancel</button>
                <button type="submit" className="btn btn-primary" disabled={isSubmitting}>{isSubmitting ? 'Saving...' : 'Save Unit'}</button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Design Modal */}
      {isDesignModalOpen && (
        <div className="modal-overlay" style={{
          position: 'fixed', top: 0, left: 0, right: 0, bottom: 0,
          backgroundColor: 'rgba(0,0,0,0.7)', backdropFilter: 'blur(5px)',
          display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 1000
        }}>
          <div className="modal-content" style={{
            backgroundColor: 'var(--surface)', padding: '2rem', borderRadius: '12px',
            width: '90%', maxWidth: '600px', border: '1px solid var(--border)', boxShadow: '0 10px 25px rgba(0,0,0,0.5)',
            maxHeight: '90vh', overflowY: 'auto'
          }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1.5rem' }}>
              <h2 style={{ margin: 0 }}>{editingDesignId ? 'Edit Shirt Design' : 'Create New Design'}</h2>
              <button onClick={() => setIsDesignModalOpen(false)} style={{ background: 'none', border: 'none', color: 'var(--text-secondary)', cursor: 'pointer' }}>
                <CloseIcon size={24} />
              </button>
            </div>

            <form onSubmit={handleDesignSubmit} style={{ display: 'flex', flexDirection: 'column', gap: '1rem' }}>
              
              <div style={{ display: 'flex', gap: '1rem' }}>
                <div style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem', flex: 2 }}>
                  <label>Design Name</label>
                  <input type="text" name="name" value={designFormData.name} onChange={(e) => setDesignFormData(prev => ({ ...prev, name: e.target.value }))} required placeholder="e.g. Classic White T-Shirt" style={{ padding: '0.8rem', borderRadius: '8px', border: '1px solid var(--border)', backgroundColor: 'rgba(255,255,255,0.05)', color: 'var(--text-primary)' }} />
                </div>
                <div style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem', flex: 1 }}>
                  <label>Category</label>
                  <select name="category_id" value={designFormData.category_id} onChange={(e) => setDesignFormData(prev => ({ ...prev, category_id: e.target.value }))} required style={{ padding: '0.8rem', borderRadius: '8px', border: '1px solid var(--border)', backgroundColor: 'rgba(255,255,255,0.05)', color: 'var(--text-primary)' }}>
                    <option value="" disabled>Select category...</option>
                    {categories.map(cat => <option key={cat.id} value={cat.id}>{cat.name}</option>)}
                  </select>
                </div>
              </div>

              <div style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem' }}>
                <label>Brand</label>
                <input type="text" name="brand" value={designFormData.brand} onChange={(e) => setDesignFormData(prev => ({ ...prev, brand: e.target.value }))} placeholder="e.g. Wearbox" style={{ padding: '0.8rem', borderRadius: '8px', border: '1px solid var(--border)', backgroundColor: 'rgba(255,255,255,0.05)', color: 'var(--text-primary)' }} />
              </div>

              <div style={{ display: 'flex', gap: '1rem' }}>
                <div style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem', flex: 1 }}>
                  <label>Price / Day (₹)</label>
                  <input type="number" name="price_1_day" value={designFormData.price_1_day} onChange={(e) => setDesignFormData(prev => ({ ...prev, price_1_day: e.target.value }))} required min="0" style={{ padding: '0.8rem', borderRadius: '8px', border: '1px solid var(--border)', backgroundColor: 'rgba(255,255,255,0.05)', color: 'var(--text-primary)' }} />
                </div>
                <div style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem', flex: 1 }}>
                  <label>Price / Week (₹)</label>
                  <input type="number" name="price_1_week" value={designFormData.price_1_week} onChange={(e) => setDesignFormData(prev => ({ ...prev, price_1_week: e.target.value }))} required min="0" style={{ padding: '0.8rem', borderRadius: '8px', border: '1px solid var(--border)', backgroundColor: 'rgba(255,255,255,0.05)', color: 'var(--text-primary)' }} />
                </div>
                <div style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem', flex: 1 }}>
                  <label>Price / Month (₹)</label>
                  <input type="number" name="price_1_month" value={designFormData.price_1_month} onChange={(e) => setDesignFormData(prev => ({ ...prev, price_1_month: e.target.value }))} required min="0" style={{ padding: '0.8rem', borderRadius: '8px', border: '1px solid var(--border)', backgroundColor: 'rgba(255,255,255,0.05)', color: 'var(--text-primary)' }} />
                </div>
              </div>

              <div style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem' }}>
                <label>Shirt Image</label>
                <div 
                  onDragOver={handleDragOver}
                  onDrop={handleDrop}
                  style={{
                    border: '2px dashed var(--border)', borderRadius: '12px', padding: '2rem', textAlign: 'center',
                    backgroundColor: 'rgba(255,255,255,0.02)', cursor: 'pointer', transition: 'all 0.2s',
                    position: 'relative', overflow: 'hidden', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', minHeight: '150px'
                  }}
                  onClick={() => document.getElementById('image-upload').click()}
                >
                  <input type="file" id="image-upload" accept="image/*" onChange={handleImageSelect} style={{ display: 'none' }} />
                  {imagePreview ? (
                    <img src={imagePreview} alt="Preview" style={{ maxWidth: '100%', maxHeight: '200px', objectFit: 'contain', borderRadius: '8px' }} />
                  ) : (
                    <div style={{ color: 'var(--text-secondary)' }}>
                      <p style={{ margin: '0 0 0.5rem 0', fontWeight: 'bold' }}>Drag & Drop an image here</p>
                      <p style={{ margin: 0, fontSize: '0.9rem' }}>or click to browse</p>
                    </div>
                  )}
                </div>
              </div>

              <div style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem' }}>
                <label>Description</label>
                <textarea name="description" value={designFormData.description} onChange={(e) => setDesignFormData(prev => ({ ...prev, description: e.target.value }))} rows="3" placeholder="Describe the shirt..." style={{ padding: '0.8rem', borderRadius: '8px', border: '1px solid var(--border)', backgroundColor: 'rgba(255,255,255,0.05)', color: 'var(--text-primary)', resize: 'vertical' }}></textarea>
              </div>

              <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '1rem', marginTop: '1rem' }}>
                <button type="button" className="btn" onClick={() => setIsDesignModalOpen(false)}>Cancel</button>
                <button type="submit" className="btn btn-primary" disabled={isSubmitting}>{isSubmitting ? 'Saving...' : 'Save Design'}</button>
              </div>

            </form>
          </div>
        </div>
      )}
    </div>
  );
}

export default Inventory;
