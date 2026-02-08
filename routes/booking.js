const express = require('express');
const router = express.Router();
const bookingService = require('../services/bookingService');

// Get calendar with availability
router.get('/calendar', async (req, res) => {
  try {
    const { month, year, courseType } = req.query;
    const cookies = req.cookies?.cookies ? JSON.parse(req.cookies.cookies) : null;
    
    const result = await bookingService.getCalendarWithAvailability(
      parseInt(month),
      parseInt(year),
      courseType || 'BABY',
      cookies
    );
    res.json(result);
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// Get available slots for a date
router.get('/slots', async (req, res) => {
  try {
    const { date, courseType } = req.query;
    const cookies = req.cookies?.cookies ? JSON.parse(req.cookies.cookies) : null;
    
    if (!date) {
      return res.status(400).json({ success: false, error: 'Date is required' });
    }
    
    const result = await bookingService.getAvailableSlots(date, courseType || 'BABY', cookies);
    res.json(result);
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// Book a class
router.post('/book', async (req, res) => {
  try {
    const { date, time, courseType } = req.body;
    const cookies = req.cookies?.cookies ? JSON.parse(req.cookies.cookies) : null;
    
    if (!date || !time) {
      return res.status(400).json({ success: false, error: 'Date and time are required' });
    }
    
    const result = await bookingService.bookClass(date, time, courseType || 'BABY', cookies);
    res.json(result);
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// Cancel a booking
router.post('/cancel', async (req, res) => {
  try {
    const { bookingId } = req.body;
    const cookies = req.cookies?.cookies ? JSON.parse(req.cookies.cookies) : null;
    
    if (!bookingId) {
      return res.status(400).json({ success: false, error: 'Booking ID is required' });
    }
    
    const result = await bookingService.cancelBooking(bookingId, cookies);
    res.json(result);
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

module.exports = router;
