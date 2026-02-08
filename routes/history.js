const express = require('express');
const router = express.Router();

router.get('/', async (req, res) => {
  try {
    const result = await req.swimCollegeService.getHistory();
    res.json(result);
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

module.exports = router;
