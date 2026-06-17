import { useState, useEffect } from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { supabase } from './supabaseClient';
import './index.css';
import './web-index.css';
import './web-app.css';

// Admin Components
import Sidebar from './components/Sidebar';
import Dashboard from './components/Dashboard';
import Inventory from './components/Inventory';
import Orders from './components/Orders';
import Users from './components/Users';
import AdminLogin from './components/AdminLogin';

// Web Components
import Navbar from './components/Navbar';
import Footer from './components/Footer';
import ScrollToTop from './components/ScrollToTop';

// Web Pages
import Home from './pages/Home';
import HowItWorksPage from './pages/HowItWorksPage';
import CollectionsPage from './pages/CollectionsPage';
import PlansPage from './pages/PlansPage';
import ReviewsPage from './pages/ReviewsPage';
import AboutPage from './pages/AboutPage';
import FAQPage from './pages/FAQPage';
import PrivacyPolicyPage from './pages/PrivacyPolicyPage';
import TermsConditionsPage from './pages/TermsConditionsPage';
import DownloadAppPage from './pages/DownloadAppPage';

function AdminLayout() {
  const [activeTab, setActiveTab] = useState('dashboard');

  return (
    <div className="app-container">
      <Sidebar activeTab={activeTab} setActiveTab={setActiveTab} />
      <main className="main-content">
        {activeTab === 'dashboard' && <Dashboard />}
        {activeTab === 'inventory' && <Inventory />}
        {activeTab === 'orders' && <Orders />}
        {activeTab === 'users' && <Users />}
      </main>
    </div>
  );
}

function WebLayout({ children }) {
  return (
    <div className="app">
      <Navbar />
      {children}
      <Footer />
    </div>
  );
}

function App() {
  const [isAdminAuthenticated, setIsAdminAuthenticated] = useState(false);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Check active session
    supabase.auth.getSession().then(({ data: { session } }) => {
      if (session?.user?.email === 'yestickai@gmail.com') {
        setIsAdminAuthenticated(true);
      } else {
        setIsAdminAuthenticated(false);
      }
      setLoading(false);
    });

    // Listen for auth changes
    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
      if (session?.user?.email === 'yestickai@gmail.com') {
        setIsAdminAuthenticated(true);
      } else {
        setIsAdminAuthenticated(false);
      }
    });

    return () => subscription.unsubscribe();
  }, []);

  if (loading) {
    return <div style={{ height: '100vh', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>Loading...</div>;
  }

  return (
    <Router>
      <ScrollToTop />
      <Routes>
        {/* Public Web Routes */}
        <Route path="/" element={<WebLayout><Home /></WebLayout>} />
        <Route path="/how-it-works" element={<WebLayout><HowItWorksPage /></WebLayout>} />
        <Route path="/collections" element={<WebLayout><CollectionsPage /></WebLayout>} />
        <Route path="/plans" element={<WebLayout><PlansPage /></WebLayout>} />
        <Route path="/reviews" element={<WebLayout><ReviewsPage /></WebLayout>} />
        <Route path="/about" element={<WebLayout><AboutPage /></WebLayout>} />
        <Route path="/faq" element={<WebLayout><FAQPage /></WebLayout>} />
        <Route path="/privacy-policy" element={<WebLayout><PrivacyPolicyPage /></WebLayout>} />
        <Route path="/terms-conditions" element={<WebLayout><TermsConditionsPage /></WebLayout>} />
        <Route path="/download-app" element={<WebLayout><DownloadAppPage /></WebLayout>} />

        {/* Admin Login Route */}
        <Route 
          path="/login" 
          element={
            isAdminAuthenticated ? (
              <Navigate to="/admin" replace />
            ) : (
              <AdminLogin />
            )
          } 
        />

        {/* Admin Dashboard Route */}
        <Route 
          path="/admin/*" 
          element={
            isAdminAuthenticated ? (
              <AdminLayout />
            ) : (
              <Navigate to="/login" replace />
            )
          } 
        />
      </Routes>
    </Router>
  );
}

export default App;
