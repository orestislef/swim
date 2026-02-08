const express = require('express');
const router = express.Router();
const swimCollegeService = require('../services/swimCollegeService');

router.get('/init-session', async (req, res) => {
  try {
    const session = await swimCollegeService.initSession();
    res.json({
      success: true,
      data: {
        message: 'Session initialized'
      }
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

router.post('/login', async (req, res) => {
  try {
    const { username, password } = req.body;
    
    if (!username || !password) {
      return res.status(400).json({
        success: false,
        error: 'Username and password are required'
      });
    }

    const result = await swimCollegeService.login(username, password);
    
    if (result.success) {
      res.cookie('authenticated', 'true', { 
        httpOnly: true, 
        maxAge: 24 * 60 * 60 * 1000 
      });
      res.cookie('cookies', JSON.stringify(result.cookies), {
        httpOnly: true,
        maxAge: 24 * 60 * 60 * 1000
      });
      
      res.json({
        success: true,
        data: {
          message: 'Login successful',
          userData: result.userData
        }
      });
    } else {
      res.status(401).json({
        success: false,
        error: result.error || 'Invalid credentials'
      });
    }
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

router.post('/logout', (req, res) => {
  res.clearCookie('authenticated');
  res.clearCookie('cookies');
  res.json({
    success: true,
    message: 'Logged out'
  });
});

router.get('/status', (req, res) => {
  const isAuthenticated = req.cookies?.authenticated === 'true';
  res.json({
    success: true,
    authenticated: isAuthenticated
  });
});

module.exports = router;
