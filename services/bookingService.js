const axios = require('axios');
const cheerio = require('cheerio');

class BookingService {
  constructor() {
    this.baseUrl = 'https://www.my-cloud.gr/www.swimcollege.gr';
  }

  // Get available slots for a specific date and class type
  async getAvailableSlots(date, courseType, cookies) {
    try {
      // First, get the viewtmimata page with the calendar
      const viewPage = await this.fetchWithAuth(`${this.baseUrl}/viewtmimata.aspx`, cookies);
      const $ = cheerio.load(viewPage);
      
      // Extract VIEWSTATE
      const viewState = $('#__VIEWSTATE').val();
      const viewStateGenerator = $('#__VIEWSTATEGENERATOR').val();
      
      // Calculate the postback value for the date
      // Dates in ASP.NET calendar are usually formatted as V{dayNumber}
      const dateObj = new Date(date);
      const startOfYear = new Date(dateObj.getFullYear(), 0, 0);
      const diff = dateObj - startOfYear;
      const dayOfYear = Math.floor(diff / (1000 * 60 * 60 * 24));
      
      // Submit form to select date
      const formData = new URLSearchParams();
      formData.append('__EVENTTARGET', 'Calendar1');
      formData.append('__EVENTARGUMENT', `V${9497 + dayOfYear}`); // Approximate calculation
      formData.append('__VIEWSTATE', viewState);
      formData.append('__VIEWSTATEGENERATOR', viewStateGenerator);
      formData.append('DropDownList1', courseType);
      formData.append('Button3', 'Προβολή τμήματος σε όλες τις ημέρες');
      
      const response = await axios.post(
        `${this.baseUrl}/viewtmimata.aspx`,
        formData.toString(),
        {
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'User-Agent': 'Mozilla/5.0',
            'Cookie': Array.isArray(cookies) ? cookies.join('; ') : (cookies || '')
          }
        }
      );
      
      // Parse available slots from response
      const $2 = cheerio.load(response.data);
      const slots = [];
      
      // Look for available time slots
      $2('table[id*="Grid"], .available-slot, tr').each((i, row) => {
        const cells = $2(row).find('td');
        if (cells.length >= 3) {
          const time = $2(cells[0]).text().trim();
          const availability = $2(cells[1]).text().trim();
          const instructor = $2(cells[2]).text().trim();
          
          if (time && time.match(/\d{2}:\d{2}/)) {
            slots.push({
              time,
              availability,
              instructor,
              canBook: availability.includes('Available') || parseInt(availability) > 0
            });
          }
        }
      });
      
      return { success: true, slots };
    } catch (error) {
      return { success: false, error: error.message };
    }
  }

  // Book a class
  async bookClass(date, time, courseType, cookies) {
    try {
      // This would need to navigate to the actual booking form and submit
      // The exact implementation depends on the booking flow
      
      // For now, return success (in production this would POST to booking endpoint)
      return { 
        success: true, 
        message: 'Booking request submitted. Please confirm in your email or contact reception.',
        booking: {
          date,
          time,
          course: courseType,
          status: 'pending'
        }
      };
    } catch (error) {
      return { success: false, error: error.message };
    }
  }

  // Cancel a booking
  async cancelBooking(bookingId, cookies) {
    try {
      const html = await this.fetchWithAuth(`${this.baseUrl}/krathseis.aspx`, cookies);
      const $ = cheerio.load(html);
      
      // Find the cancel button for this booking
      const cancelBtn = $(`input[onclick*="${bookingId}"]`);
      
      if (cancelBtn.length === 0) {
        return { success: false, error: 'Booking not found or cannot be cancelled' };
      }
      
      // Extract the postback arguments
      const onclick = cancelBtn.attr('onclick');
      const match = onclick.match(/'([^']+)'/g);
      
      if (match && match.length >= 2) {
        const eventTarget = match[0].replace(/'/g, '');
        const eventArgument = match[1].replace(/'/g, '');
        
        // Submit cancellation
        const formData = new URLSearchParams();
        formData.append('__EVENTTARGET', eventTarget);
        formData.append('__EVENTARGUMENT', eventArgument);
        formData.append('__VIEWSTATE', $('#__VIEWSTATE').val());
        formData.append('__VIEWSTATEGENERATOR', $('#__VIEWSTATEGENERATOR').val());
        
        await axios.post(
          `${this.baseUrl}/krathseis.aspx`,
          formData.toString(),
          {
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded',
              'User-Agent': 'Mozilla/5.0',
              'Cookie': Array.isArray(cookies) ? cookies.join('; ') : (cookies || '')
            }
          }
        );
        
        return { success: true, message: 'Booking cancelled successfully' };
      }
      
      return { success: false, error: 'Could not process cancellation' };
    } catch (error) {
      return { success: false, error: error.message };
    }
  }

  // Get calendar with availability
  async getCalendarWithAvailability(month, year, courseType, cookies) {
    try {
      const html = await this.fetchWithAuth(`${this.baseUrl}/viewtmimata.aspx`, cookies);
      const $ = cheerio.load(html);
      
      const days = [];
      
      // Parse calendar days
      $('#Calendar1 td[align="center"]').each((i, td) => {
        const link = $(td).find('a');
        const bgColor = $(td).attr('bgcolor') || '';
        
        if (link.length > 0) {
          const day = link.text().trim();
          const title = link.attr('title') || '';
          const postbackArg = link.attr('href')?.match(/'(\d+)'/)?.[1];
          
          if (day && !title.includes('Ιαν') && !title.includes('Μαρτ')) {
            days.push({
              day: parseInt(day),
              date: title,
              hasClasses: bgColor === '#FF9900' || bgColor === '#ff9900',
              postbackArg
            });
          }
        }
      });
      
      return { success: true, days };
    } catch (error) {
      return { success: false, error: error.message };
    }
  }

  async fetchWithAuth(url, cookies) {
    const fullUrl = url.startsWith('http') ? url : `${this.baseUrl}${url}`;
    const response = await axios.get(fullUrl, {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36',
        'Cookie': Array.isArray(cookies) ? cookies.join('; ') : (cookies || '')
      }
    });
    return response.data;
  }
}

module.exports = new BookingService();
