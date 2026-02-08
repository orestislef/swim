const express = require('express');
const router = express.Router();

router.get('/', async (req, res) => {
  try {
    const cookies = req.cookies?.cookies ? JSON.parse(req.cookies.cookies) : null;
    const result = await req.swimCollegeService.getCourses(cookies);
    res.json(result);
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

module.exports = router;
