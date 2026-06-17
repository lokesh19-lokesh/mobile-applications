import React, { useState, useEffect, useRef } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { supabase } from '../supabaseClient';
import { FiGlobe as Globe, FiArrowRight as ArrowRight, FiInstagram as Instagram, FiTwitter as Twitter, FiArrowLeft as ArrowLeft, FiCheck as Check } from 'react-icons/fi';

function AdminLogin() {
  const [email, setEmail] = useState('');
  const [token, setToken] = useState('');
  const [otpSent, setOtpSent] = useState(false);
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState('');
  const navigate = useNavigate();
  const videoRef = useRef(null);

  // Check if admin is already logged in
  useEffect(() => {
    const checkSession = async () => {
      const { data: { session } } = await supabase.auth.getSession();
      if (session?.user?.email === 'yestickai@gmail.com') {
        navigate('/admin');
      }
    };
    checkSession();
  }, [navigate]);

  // Handle Video loop transition
  useEffect(() => {
    const video = videoRef.current;
    if (!video) return;
    
    // Auto-play the video ensuring it plays
    video.play().catch(e => console.error("Video autoplay blocked:", e));

    let fadeFrame;
    let fadingOut = false;

    // Fade-in when playback begins or loops
    const handlePlay = () => {
      fadingOut = false;
      let start = null;
      const duration = 500; // ms
      const fade = (timestamp) => {
        if (!start) start = timestamp;
        const progress = timestamp - start;
        video.style.opacity = Math.min(progress / duration, 1);
        if (progress < duration) {
          fadeFrame = requestAnimationFrame(fade);
        }
      };
      cancelAnimationFrame(fadeFrame);
      fadeFrame = requestAnimationFrame(fade);
    };

    // Trigger fade-out ~0.55s before end
    const handleTimeUpdate = () => {
      const remaining = video.duration - video.currentTime;
      if (remaining <= 0.55 && !fadingOut) {
        fadingOut = true;
        let start = null;
        const duration = 500; // ms
        const initialOpacity = parseFloat(video.style.opacity) || 1;
        const fade = (timestamp) => {
          if (!start) start = timestamp;
          const progress = timestamp - start;
          video.style.opacity = Math.max(initialOpacity - (progress / duration), 0);
          if (progress < duration) {
            fadeFrame = requestAnimationFrame(fade);
          }
        };
        cancelAnimationFrame(fadeFrame);
        fadeFrame = requestAnimationFrame(fade);
      }
    };

    // On ended, force opacity 0, delay slightly, then replay
    const handleEnded = () => {
      video.style.opacity = 0;
      setTimeout(() => {
        video.currentTime = 0;
        video.play();
      }, 100);
    };

    video.addEventListener('play', handlePlay);
    video.addEventListener('timeupdate', handleTimeUpdate);
    video.addEventListener('ended', handleEnded);

    return () => {
      video.removeEventListener('play', handlePlay);
      video.removeEventListener('timeupdate', handleTimeUpdate);
      video.removeEventListener('ended', handleEnded);
      cancelAnimationFrame(fadeFrame);
    };
  }, []);

  const handleSendOtp = async (e) => {
    e.preventDefault();
    setLoading(true);
    setMessage('');

    if (email !== 'yestickai@gmail.com') {
      setMessage('Unauthorized admin email.');
      setLoading(false);
      return;
    }

    try {
      // Use the custom edge function to match the mobile app's custom email template
      const { error } = await supabase.functions.invoke('send-otp', {
        body: { email }
      });

      if (error) throw error;
      setOtpSent(true);
      setMessage('A secure code has been sent to your email.');
    } catch (error) {
      console.error('Error sending OTP:', error.message);
      setMessage(error.message || 'Failed to send OTP. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  const handleVerifyOtp = async (e) => {
    e.preventDefault();
    setLoading(true);
    setMessage('');

    try {
      const { error, data } = await supabase.auth.verifyOtp({
        email,
        token,
        type: 'magiclink' // Match OtpType.magiclink from mobile app
      });

      if (error) throw error;
      
      if (data?.session) {
        navigate('/admin');
      }
    } catch (error) {
      console.error('Error verifying OTP:', error.message);
      setMessage('Invalid code. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <>
      <style dangerouslySetInnerHTML={{__html: `
        .liquid-glass {
          background: rgba(255, 255, 255, 0.03);
          backdrop-filter: blur(16px);
          -webkit-backdrop-filter: blur(16px);
          border: 1px solid rgba(255, 255, 255, 0.1);
          box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1);
        }
        .placeholder-white-40::placeholder {
          color: rgba(255, 255, 255, 0.4);
        }
      `}} />

      <div className="relative min-h-screen bg-black overflow-hidden flex flex-col font-sans">
        <video
          ref={videoRef}
          className="absolute top-0 left-0 w-full h-full object-cover -translate-y-[17%]"
          style={{ opacity: 0 }}
          src="https://d8j0ntlcm91z4.cloudfront.net/user_38xzZboKViGWJOttwIXH07lWA1P/hf_20260328_115001_bcdaa3b4-03de-47e7-ad63-ae3e392c32d4.mp4"
          muted
          playsInline
          autoPlay
        />
        
        {/* Back Button */}
        <div className="absolute top-8 left-8 z-20">
          <Link to="/" className="flex items-center gap-2 text-white/80 hover:text-white transition-colors bg-black/20 hover:bg-black/40 backdrop-blur-md px-5 py-3 rounded-full border border-white/10">
            <ArrowLeft size={18} />
            <span className="text-sm font-medium">Back to Home</span>
          </Link>
        </div>

        {/* Hero Content */}
        <div className="relative z-10 flex-1 flex flex-col items-center justify-center px-6 py-12 text-center">
          
          <div className="bg-black/30 backdrop-blur-xl border border-white/10 p-10 rounded-3xl max-w-md w-full shadow-2xl flex flex-col items-center">
            <h1 className="text-4xl md:text-5xl mb-4 tracking-tight whitespace-nowrap" style={{ fontFamily: "'Instrument Serif', serif", color: '#ffffff' }}>
              Admin Access
            </h1>
            
            <p className="text-white/80 text-sm leading-relaxed mb-8 px-2 text-center">
              {otpSent 
                ? 'Enter the 6-digit code sent to your email to authenticate.' 
                : 'Securely authenticate to access the Wearbox admin dashboard.'}
            </p>
            
            {message && (
              <div className="bg-white/10 backdrop-blur-md border border-white/20 text-white px-4 py-3 rounded-xl text-sm mb-6 w-full text-center">
                {message}
              </div>
            )}
            
            {!otpSent ? (
              <form onSubmit={handleSendOtp} className="w-full flex flex-col gap-4">
                <div className="relative">
                  <input 
                    type="email" 
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    placeholder="name@example.com" 
                    required
                    disabled={loading}
                    className="w-full bg-white/5 border border-white/10 rounded-xl px-5 py-4 outline-none text-white placeholder-white-40 text-base focus:border-white/30 focus:bg-white/10 transition-all text-center"
                  />
                </div>
                <button 
                  type="submit" 
                  disabled={loading} 
                  className="w-full bg-white text-black font-semibold rounded-xl px-5 py-4 hover:bg-gray-200 transition-colors cursor-pointer flex items-center justify-center gap-2 disabled:opacity-70 mt-2"
                >
                  {loading ? 'Sending...' : 'Send Code'}
                  {!loading && <ArrowRight size={18} />}
                </button>
              </form>
            ) : (
              <form onSubmit={handleVerifyOtp} className="w-full flex flex-col gap-4">
                <div className="relative">
                  <input 
                    type="text" 
                    value={token}
                    onChange={(e) => setToken(e.target.value)}
                    placeholder="Enter verification code" 
                    required
                    disabled={loading}
                    maxLength={10}
                    className="w-full bg-white/5 border border-white/10 rounded-xl px-5 py-4 outline-none text-white placeholder-white-40 focus:border-white/30 focus:bg-white/10 transition-all text-center tracking-widest text-2xl font-mono"
                  />
                </div>
                <button 
                  type="submit" 
                  disabled={loading} 
                  className="w-full bg-white text-black font-semibold rounded-xl px-5 py-4 hover:bg-gray-200 transition-colors cursor-pointer flex items-center justify-center gap-2 disabled:opacity-70 mt-2"
                >
                  {loading ? 'Verifying...' : 'Verify & Login'}
                  {!loading && <Check size={18} />}
                </button>
                <button
                  type="button"
                  onClick={() => { setOtpSent(false); setToken(''); setMessage(''); }}
                  className="text-white/60 hover:text-white text-sm mt-4 transition-colors cursor-pointer bg-transparent border-none"
                >
                  Use a different email
                </button>
              </form>
            )}
          </div>
        </div>
      </div>
    </>
  );
}

export default AdminLogin;
