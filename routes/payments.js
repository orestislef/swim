const express = require('express');
const router = express.Router();

router.get('/', async (req, res) => {
  try {
    const result = await req.swimCollegeService.getPayments();
    res.json(result);
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

router.post('/', async (req, res) => {
  res.json({ success: false, error: 'Payment initiation requires authenticated session' });
});

module.exports = router;
