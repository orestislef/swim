require('dotenv').config();

const axios = require('axios');
const cheerio = require('cheerio');

class SwimCollegeService {
  constructor() {
    this.baseUrl = 'https://www.my-cloud.gr/www.swimcollege.gr';
    this.loginUrl = `${this.baseUrl}/login.aspx`;
  }

  async initSession() {
    try {
      const response = await axios.get(this.loginUrl, {
        headers: {
          'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36'
        }
      });

      const html = response.data;
      const cookies = response.headers['set-cookie'] || [];
      
      const viewStateMatch = html.match(/id="__VIEWSTATE" value="([^"]*)"/);
      const viewStateGenMatch = html.match(/id="__VIEWSTATEGENERATOR" value="([^"]*)"/);
      
      const viewState = viewStateMatch ? viewStateMatch[1] : '';
      const viewStateGenerator = viewStateGenMatch ? viewStateGenMatch[1] : '';
      
      return {
        cookies,
        viewState,
        viewStateGenerator
      };
    } catch (error) {
      throw new Error(`Failed to initialize session: ${error.message}`);
    }
  }

  async login(username, password) {
    try {
      const session = await this.initSession();
      const cookies = session.cookies;

      const formData = new URLSearchParams();
      formData.append('__EVENTTARGET', '');
      formData.append('__EVENTARGUMENT', '');
      formData.append('__VIEWSTATE', session.viewState);
      formData.append('__VIEWSTATEGENERATOR', session.viewStateGenerator);
      formData.append('TextBox1', username);
      formData.append('TextBox2', password);
      formData.append('Button1', 'Είσοδος');

      let response;
      try {
        response = await axios.post(
          this.loginUrl,
          formData.toString(),
          {
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded',
              'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36',
              'Cookie': Array.isArray(cookies) ? cookies.join('; ') : (cookies || ''),
              'Content-Length': formData.toString().length
            },
            maxRedirects: 0,
            validateStatus: (status) => status < 500
          }
        );
      } catch (err) {
        if (err.response && (err.response.status === 302 || err.response.status === 303)) {
          response = err.response;
        } else {
          throw err;
        }
      }

      if (response.status === 302 || response.status === 303) {
        const redirectLocation = response.headers['location'];
        
        if (redirectLocation && (redirectLocation.includes('login') || redirectLocation.toLowerCase().includes('error'))) {
          return {
            success: false,
            error: 'Invalid credentials'
          };
        }

        const newCookies = response.headers['set-cookie'] || cookies;
        
        const redirectUrl = redirectLocation.startsWith('http') 
          ? redirectLocation 
          : `https://www.my-cloud.gr${redirectLocation}`;
        const dashboardHtml = await this.fetchWithAuth(redirectUrl, newCookies);
        const userInfo = this.parseDashboard(dashboardHtml);

        return {
          success: true,
          redirectUrl: redirectUrl,
          cookies: newCookies,
          userData: userInfo
        };
      }

      return {
        success: true,
        cookies: cookies,
        data: response.data
      };
    } catch (error) {
      if (error.response && (error.response.status === 302 || error.response.status === 303)) {
        const redirectLocation = error.response.headers['location'];
        const newCookies = error.response.headers['set-cookie'] || [];
        
        const redirectUrl = redirectLocation.startsWith('http') 
          ? redirectLocation 
          : `https://www.my-cloud.gr${redirectLocation}`;
        const dashboardHtml = await this.fetchWithAuth(redirectUrl, newCookies);
        const userInfo = this.parseDashboard(dashboardHtml);

        return {
          success: true,
          redirectUrl: redirectUrl,
          cookies: newCookies,
          userData: userInfo
        };
      }
      throw new Error(`Login failed: ${error.message}`);
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

  parseDashboard(html) {
    const $ = cheerio.load(html);
    
    const name = $('#Label1').text().trim();
    const expiry = $('#Label2').text().trim();
    const balance = $('#Label3').text().trim();
    
    return {
      name,
      expiry,
      balance
    };
  }

  async getDashboard(cookies) {
    try {
      if (!cookies || cookies.length === 0) {
        return { success: false, error: 'Not authenticated' };
      }

      const html = await this.fetchWithAuth(`${this.baseUrl}/success.aspx`, cookies);
      const $ = cheerio.load(html);
      
      const name = $('#Label1').text().trim();
      const expiry = $('#Label2').text().trim();
      const balance = $('#Label3').text().trim();

      const userData = {
        name,
        expiry,
        balance
      };

      return { success: true, data: userData };
    } catch (error) {
      return { success: false, error: error.message };
    }
  }

  async getBookings(cookies) {
    try {
      if (!cookies || cookies.length === 0) {
        return { success: false, error: 'Not authenticated' };
      }

      const html = await this.fetchWithAuth(`${this.baseUrl}/krathseis.aspx`, cookies);
      const $ = cheerio.load(html);
      const bookings = [];

      const totalText = $('#Label1').text().trim();
      const totalMatch = totalText.match(/Σύνολο\s*:\s*(\d+)/);
      const total = totalMatch ? parseInt(totalMatch[1]) : 0;

      $('#GridView1 tr').each((i, row) => {
        if (i === 0) return;
        
        const cells = $(row).find('td');
        if (cells.length >= 5) {
          const dateText = $(cells[2]).text().trim();
          const timeText = $(cells[3]).text().trim();
          const courseText = $(cells[4]).text().trim();
          const cancelBtn = $(cells[0]).find('input[value="Άκυρο"]').length > 0;

          if (dateText) {
            bookings.push({
              id: $(cells[1]).text().trim(),
              date: dateText,
              time: timeText,
              course: courseText,
              status: cancelBtn ? 'pending' : 'confirmed',
              statusText: cancelBtn ? 'Ενεργή' : 'Ολοκληρωμένη'
            });
          }
        }
      });

      return { success: true, data: { bookings, total } };
    } catch (error) {
      return { success: false, error: error.message };
    }
  }

  async getSubscriptions(cookies) {
    try {
      if (!cookies || cookies.length === 0) {
        return { success: false, error: 'Not authenticated' };
      }

      const html = await this.fetchWithAuth(`${this.baseUrl}/mysyndromes.aspx`, cookies);
      const $ = cheerio.load(html);
      const subscriptions = [];

      $('#GridView1 tr').each((i, row) => {
        if (i === 0) return;
        
        const cells = $(row).find('td');
        if (cells.length >= 8) {
          const name = $(cells[1]).text().trim();
          const start = $(cells[2]).text().trim();
          const end = $(cells[3]).text().trim();
          const attendances = $(cells[4]).text().trim();
          const bookings = $(cells[5]).text().trim();
          const remaining = $(cells[6]).text().trim();

          if (name) {
            subscriptions.push({
              name,
              start,
              end,
              attendances,
              bookings,
              remaining
            });
          }
        }
      });

      return { success: true, data: subscriptions };
    } catch (error) {
      return { success: false, error: error.message };
    }
  }

  async getAttendances(cookies) {
    try {
      if (!cookies || cookies.length === 0) {
        return { success: false, error: 'Not authenticated' };
      }

      const html = await this.fetchWithAuth(`${this.baseUrl}/parousies.aspx`, cookies);
      const $ = cheerio.load(html);
      const attendances = [];

      $('#GridView1 tr').each((i, row) => {
        if (i === 0) return;
        
        const cells = $(row).find('td');
        if (cells.length >= 2) {
          const date = $(cells[0]).text().trim();
          const time = $(cells[1]).text().trim();

          if (date) {
            attendances.push({ date, time });
          }
        }
      });

      return { success: true, data: attendances };
    } catch (error) {
      return { success: false, error: error.message };
    }
  }

  async getCourses(cookies) {
    try {
      if (!cookies || cookies.length === 0) {
        return { success: false, error: 'Not authenticated' };
      }

      const html = await this.fetchWithAuth(`${this.baseUrl}/viewtmimata.aspx`, cookies);
      const $ = cheerio.load(html);
      const courses = [];

      const courseTypes = [];
      $('#DropDownList1 option').each((i, opt) => {
        courseTypes.push($(opt).val());
      });

      const calendarDays = [];
      $('#Calendar1 td[align="center"]').each((i, td) => {
        const link = $(td).find('a');
        if (link.length > 0) {
          const title = link.attr('title') || '';
          const day = link.text().trim();
          const bgColor = $(td).attr('bgcolor') || '';
          if (day && !title.includes('Ιανουαρίου') && !title.includes('Μαρτίου')) {
            calendarDays.push({
              day,
              date: title,
              hasClass: bgColor === '#FF9900'
            });
          }
        }
      });

      return { 
        success: true, 
        data: { 
          courseTypes,
          calendar: calendarDays
        } 
      };
    } catch (error) {
      return { success: false, error: error.message };
    }
  }

  async getWaitlist(cookies) {
    try {
      if (!cookies || cookies.length === 0) {
        return { success: false, error: 'Not authenticated' };
      }

      const html = await this.fetchWithAuth(`${this.baseUrl}/anamones.aspx`, cookies);
      const $ = cheerio.load(html);
      const waitlist = [];

      $('#GridView1 tr').each((i, row) => {
        if (i === 0) return;
        
        const cells = $(row).find('td');
        if (cells.length >= 4) {
          const text = $(row).text().trim();
          if (text && text.length > 5) {
            waitlist.push({ details: text });
          }
        }
      });

      return { success: true, data: waitlist };
    } catch (error) {
      return { success: false, error: error.message };
    }
  }

  async getCancellations(cookies) {
    try {
      if (!cookies || cookies.length === 0) {
        return { success: false, error: 'Not authenticated' };
      }

      const html = await this.fetchWithAuth(`${this.baseUrl}/cancels.aspx`, cookies);
      const $ = cheerio.load(html);
      const cancellations = [];

      $('#GridView1 tr').each((i, row) => {
        if (i === 0) return;
        
        const cells = $(row).find('td');
        if (cells.length >= 4) {
          const text = $(row).text().trim();
          if (text && text.length > 5) {
            cancellations.push({ details: text });
          }
        }
      });

      return { success: true, data: cancellations };
    } catch (error) {
      return { success: false, error: error.message };
    }
  }

  async getBarcode(cookies) {
    try {
      if (!cookies || cookies.length === 0) {
        return { success: false, error: 'Not authenticated' };
      }

      const html = await this.fetchWithAuth(`${this.baseUrl}/barcode.aspx`, cookies);
      const $ = cheerio.load(html);

      const barcodeText = $('#RadBarcode1 text').text().trim();
      const svg = $('#RadBarcode1').html() || '';

      return { 
        success: true, 
        data: { 
          code: barcodeText,
          svg
        } 
      };
    } catch (error) {
      return { success: false, error: error.message };
    }
  }

  async getProfile(cookies) {
    try {
      if (!cookies || cookies.length === 0) {
        return { success: false, error: 'Not authenticated' };
      }

      const dashboard = await this.getDashboard(cookies);
      
      return {
        success: true,
        data: {
          name: dashboard.data?.name || '',
          expiry: dashboard.data?.expiry || '',
          balance: dashboard.data?.balance || ''
        }
      };
    } catch (error) {
      return { success: false, error: error.message };
    }
  }
}

module.exports = new SwimCollegeService();
