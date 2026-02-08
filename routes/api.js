const express = require('express');
const router = express.Router();

router.get('/health', (req, res) => {
  res.json({
    success: true,
    message: 'Swim College API is running',
    timestamp: new Date().toISOString()
  });
});

router.get('/', (req, res) => {
  res.json({
    success: true,
    message: 'Swim College API',
    version: '1.0.0',
    endpoints: {
      health: '/api/health',
      auth: {
        initSession: 'POST /api/auth/init-session',
        login: 'POST /api/auth/login',
        getPage: 'GET /api/auth/page/:path',
        postForm: 'POST /api/auth/page/:path'
      }
    }
  });
});

module.exports = router;
