const axios = require('axios');
const cheerio = require('cheerio');

class BookingService {
  constructor() {
    this.baseUrl = 'https://www.my-cloud.gr/www.swimcollege.gr';
  }

  // Calculate ASP.NET Calendar date serial (days since Jan 1, 2000)
  dateToSerial(dateStr) {
    const parts = dateStr.split('-'); // YYYY-MM-DD
    const year = parseInt(parts[0]);
    const month = parseInt(parts[1]) - 1;
    const day = parseInt(parts[2]);
    const target = Date.UTC(year, month, day);
    const epoch = Date.UTC(2000, 0, 1);
    return Math.floor((target - epoch) / (1000 * 60 * 60 * 24));
  }

  // Format date as DD/MM/YYYY for matching against slot dates
  formatDateForMatch(dateStr) {
    const parts = dateStr.split('-'); // YYYY-MM-DD
    return `${parts[2].padStart(2, '0')}/${parts[1].padStart(2, '0')}/${parts[0]}`;
  }

  async postForm(url, formData, cookies) {
    const response = await axios.post(url, formData.toString(), {
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36',
        'Cookie': Array.isArray(cookies) ? cookies.join('; ') : (cookies || '')
      }
    });
    return response.data;
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

  // Parse repeater1 slots from viewtmimata.aspx response HTML
  parseRepeaterSlots($) {
    const slots = [];
    let idx = 0;
    while (idx < 100) {
      const tmimaIdEl = $(`[id="repeater1_TmimaID_${idx}"]`);
      if (tmimaIdEl.length === 0) break;

      const tmimaId = tmimaIdEl.text().trim();
      const course = $(`[id="repeater1_lblTmima_${idx}"]`).text().trim();
      const dateStr = $(`[id="repeater1_lblDate_${idx}"]`).text().trim();
      const timeRange = $(`[id="repeater1_lblApo_${idx}"]`).text().trim();
      const teacher = $(`[id="repeater1_lblTeacher_${idx}"]`).text().trim();
      const personsText = $(`[id="repeater1_lblPersons_${idx}"]`).text().trim();
      const clnd = $(`[id="repeater1_clnd_${idx}"]`);
      const colorClass = clnd.attr('class') || '';
      const bookBtn = $(`[id="repeater1_btn1_${idx}"]`);

      let status = 'available';
      if (colorClass.includes('red')) status = 'past';
      else if (colorClass.includes('yellow')) status = 'cancelled';

      const personsNum = parseInt(personsText);

      slots.push({
        id: tmimaId,
        course,
        date: dateStr,
        time: timeRange,
        teacher,
        persons: isNaN(personsNum) ? 0 : personsNum,
        canBook: bookBtn.length > 0,
        status,
        bookButtonName: bookBtn.length > 0 ? bookBtn.attr('name') : null
      });

      idx++;
    }
    return slots;
  }

  // Navigate viewtmimata.aspx: select date on calendar + click Button3 to get all weekly slots
  async getViewtmimataPage(date, courseType, cookies) {
    // Step 1: GET viewtmimata.aspx for initial ViewState
    const html = await this.fetchWithAuth(`${this.baseUrl}/viewtmimata.aspx`, cookies);
    let $ = cheerio.load(html);
    let viewState = $('#__VIEWSTATE').val();
    let viewStateGenerator = $('#__VIEWSTATEGENERATOR').val();

    // Step 2: POST to select the date on Calendar1
    const dateSerial = this.dateToSerial(date);
    let formData = new URLSearchParams();
    formData.append('__EVENTTARGET', 'Calendar1');
    formData.append('__EVENTARGUMENT', String(dateSerial));
    formData.append('__VIEWSTATE', viewState);
    formData.append('__VIEWSTATEGENERATOR', viewStateGenerator);
    formData.append('DropDownList1', courseType);

    let responseHtml = await this.postForm(`${this.baseUrl}/viewtmimata.aspx`, formData, cookies);
    $ = cheerio.load(responseHtml);
    viewState = $('#__VIEWSTATE').val();
    viewStateGenerator = $('#__VIEWSTATEGENERATOR').val();

    // Step 3: POST with Button3 to show all days of the week
    formData = new URLSearchParams();
    formData.append('__EVENTTARGET', '');
    formData.append('__EVENTARGUMENT', '');
    formData.append('__VIEWSTATE', viewState);
    formData.append('__VIEWSTATEGENERATOR', viewStateGenerator);
    formData.append('DropDownList1', courseType);
    formData.append('Button3', '\u03A0\u03C1\u03BF\u03B2\u03BF\u03BB\u03AE \u03C4\u03BC\u03AE\u03BC\u03B1\u03C4\u03BF\u03C2 \u03C3\u03B5 \u03CC\u03BB\u03B5\u03C2 \u03C4\u03B9\u03C2 \u03B7\u03BC\u03AD\u03C1\u03B5\u03C2');

    responseHtml = await this.postForm(`${this.baseUrl}/viewtmimata.aspx`, formData, cookies);
    $ = cheerio.load(responseHtml);

    return {
      $,
      viewState: $('#__VIEWSTATE').val(),
      viewStateGenerator: $('#__VIEWSTATEGENERATOR').val()
    };
  }

  // Get available slots for a specific date and class type
  async getAvailableSlots(date, courseType, cookies) {
    try {
      const { $ } = await this.getViewtmimataPage(date, courseType, cookies);
      const allSlots = this.parseRepeaterSlots($);

      // Filter slots matching the requested date (DD/MM/YYYY)
      const matchDate = this.formatDateForMatch(date);
      const filteredSlots = allSlots.filter(slot => slot.date.includes(matchDate));

      return { success: true, slots: filteredSlots };
    } catch (error) {
      console.error('getAvailableSlots error:', error.message);
      return { success: false, error: error.message, slots: [] };
    }
  }

  // Book a class by slot ID
  async bookClass(date, courseType, slotId, cookies) {
    try {
      // Re-navigate to get fresh ViewState and slot data
      const { $, viewState, viewStateGenerator } = await this.getViewtmimataPage(date, courseType, cookies);
      const allSlots = this.parseRepeaterSlots($);

      // Find the slot by ID
      const slot = allSlots.find(s => s.id === String(slotId));
      if (!slot) {
        return { success: false, error: 'Slot not found' };
      }
      if (!slot.canBook || !slot.bookButtonName) {
        return { success: false, error: 'This slot cannot be booked (full or unavailable)' };
      }

      // Step 4: POST with the book button to trigger modal
      let formData = new URLSearchParams();
      formData.append('__EVENTTARGET', '');
      formData.append('__EVENTARGUMENT', '');
      formData.append('__VIEWSTATE', viewState);
      formData.append('__VIEWSTATEGENERATOR', viewStateGenerator);
      formData.append('DropDownList1', courseType);
      formData.append(slot.bookButtonName, 'Book');

      let responseHtml = await this.postForm(`${this.baseUrl}/viewtmimata.aspx`, formData, cookies);
      let $r = cheerio.load(responseHtml);

      // Step 5: Confirm with Button2 (OK) in the modal
      const newViewState = $r('#__VIEWSTATE').val();
      const newViewStateGenerator = $r('#__VIEWSTATEGENERATOR').val();

      formData = new URLSearchParams();
      formData.append('__EVENTTARGET', '');
      formData.append('__EVENTARGUMENT', '');
      formData.append('__VIEWSTATE', newViewState);
      formData.append('__VIEWSTATEGENERATOR', newViewStateGenerator);
      formData.append('DropDownList1', courseType);
      formData.append('Button2', '\u039F\u039A');

      await this.postForm(`${this.baseUrl}/viewtmimata.aspx`, formData, cookies);

      return {
        success: true,
        message: 'Booking confirmed!',
        booking: {
          id: slotId,
          date: slot.date,
          time: slot.time,
          course: courseType,
          teacher: slot.teacher,
          status: 'confirmed'
        }
      };
    } catch (error) {
      console.error('bookClass error:', error.message);
      return { success: false, error: error.message };
    }
  }

  // Cancel a booking from krathseis.aspx
  async cancelBooking(bookingId, cookies) {
    try {
      const html = await this.fetchWithAuth(`${this.baseUrl}/krathseis.aspx`, cookies);
      const $ = cheerio.load(html);

      let eventArg = null;
      let btnName = null;

      $('#GridView1 tr').each((i, row) => {
        if (i === 0) return; // skip header
        const cells = $(row).find('td');
        const id = $(cells[1]).text().trim();
        if (id === String(bookingId)) {
          const btn = $(cells[0]).find('input[value="\u0386\u03BA\u03C5\u03C1\u03BF"]');
          if (btn.length > 0) {
            // Try onclick __doPostBack pattern first
            const onclick = btn.attr('onclick') || '';
            const match = onclick.match(/__doPostBack\('([^']+)','([^']+)'\)/);
            if (match) {
              eventArg = { target: match[1], arg: match[2] };
            }
            // Fallback: use button name directly
            if (!eventArg) {
              btnName = btn.attr('name');
            }
          }
        }
      });

      if (!eventArg && !btnName) {
        return { success: false, error: 'Booking not found or cannot be cancelled' };
      }

      const viewState = $('#__VIEWSTATE').val();
      const viewStateGenerator = $('#__VIEWSTATEGENERATOR').val();
      const eventValidation = $('#__EVENTVALIDATION').val();

      const formData = new URLSearchParams();
      if (eventArg) {
        formData.append('__EVENTTARGET', eventArg.target);
        formData.append('__EVENTARGUMENT', eventArg.arg);
      } else {
        // Submit as button click
        formData.append('__EVENTTARGET', '');
        formData.append('__EVENTARGUMENT', '');
        formData.append(btnName, '\u0386\u03BA\u03C5\u03C1\u03BF');
      }
      formData.append('__VIEWSTATE', viewState);
      formData.append('__VIEWSTATEGENERATOR', viewStateGenerator);
      if (eventValidation) formData.append('__EVENTVALIDATION', eventValidation);

      await this.postForm(`${this.baseUrl}/krathseis.aspx`, formData, cookies);

      return { success: true, message: 'Booking cancelled successfully' };
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
      $('#Calendar1 td[align="center"]').each((i, td) => {
        const link = $(td).find('a');
        const bgColor = $(td).attr('bgcolor') || '';
        if (link.length > 0) {
          const day = link.text().trim();
          const title = link.attr('title') || '';
          const postbackArg = link.attr('href')?.match(/'(\d+)'/)?.[1];
          if (day) {
            days.push({
              day: parseInt(day),
              date: title,
              hasClasses: bgColor === '#FF9900' || bgColor === '#ff9900',
              isPast: bgColor === '#999999',
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
}

module.exports = new BookingService();
