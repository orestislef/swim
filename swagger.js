const swaggerJsdoc = require('swagger-jsdoc');

const swaggerDefinition = {
  openapi: '3.0.0',
  info: {
    title: 'Swim College API',
    version: '1.0.0',
    description: `Node.js API wrapper for the Swim College ASP.NET booking system.

## Authentication Flow

This API uses **cookie-based authentication**. Here's how it works:

1. **POST \`/api/auth/login\`** with \`{ "username": "...", "password": "..." }\`
2. On success, the server sets two **httpOnly cookies** in the response:
   - \`authenticated=true\` — session flag (24h TTL)
   - \`cookies=[...]}\` — upstream ASP.NET session cookies (24h TTL)
3. **All subsequent requests** must include these cookies (browsers do this automatically with \`credentials: 'include'\`)
4. For mobile apps: capture the \`Set-Cookie\` headers from the login response and include them in all subsequent requests via the \`Cookie\` header

### Mobile App Integration

For a mobile app (React Native, Flutter, Swift, Kotlin, etc.):

\`\`\`
// 1. Login - capture cookies from response headers
POST /swim/api/auth/login
Content-Type: application/json
Body: { "username": "6979753028", "password": "12449" }

// Response includes Set-Cookie headers:
// Set-Cookie: authenticated=true; HttpOnly; Max-Age=86400
// Set-Cookie: cookies=["ASP.NET_SessionId=...", ...]; HttpOnly; Max-Age=86400

// 2. Use cookies in subsequent requests
GET /swim/api/dashboard
Cookie: authenticated=true; cookies=["ASP.NET_SessionId=..."]

// 3. Logout
POST /swim/api/auth/logout
Cookie: authenticated=true; cookies=[...]
\`\`\`

### Important Notes
- All protected endpoints return **401** if not authenticated
- Cookies expire after **24 hours** — re-login required
- The base URL is \`https://orestislef.gr/swim\`
- All API paths are prefixed with \`/api/\`
`,
    contact: {
      name: 'Swim College'
    }
  },
  servers: [
    {
      url: '/swim',
      description: 'Production (behind reverse proxy)'
    },
    {
      url: '/',
      description: 'Direct (development)'
    }
  ],
  tags: [
    { name: 'Health', description: 'API health and info' },
    { name: 'Auth', description: 'Authentication endpoints' },
    { name: 'Dashboard', description: 'Dashboard data' },
    { name: 'Bookings', description: 'View existing bookings' },
    { name: 'Booking', description: 'Book, cancel, and manage class reservations' },
    { name: 'Courses', description: 'Available course types' },
    { name: 'Subscriptions', description: 'User subscriptions' },
    { name: 'Attendances', description: 'Attendance history' },
    { name: 'Waitlist', description: 'Waitlist entries' },
    { name: 'Cancellations', description: 'Cancellation history' },
    { name: 'Barcode', description: 'Member barcode' },
    { name: 'Users', description: 'User profile' }
  ],
  paths: {
    '/api/health': {
      get: {
        tags: ['Health'],
        summary: 'Health check',
        description: 'Returns API health status and timestamp.',
        responses: {
          200: {
            description: 'API is running',
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    success: { type: 'boolean', example: true },
                    message: { type: 'string', example: 'Swim College API is running' },
                    timestamp: { type: 'string', format: 'date-time' }
                  }
                }
              }
            }
          }
        }
      }
    },
    '/api': {
      get: {
        tags: ['Health'],
        summary: 'API info',
        description: 'Returns API version and available endpoints.',
        responses: {
          200: {
            description: 'API information',
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    success: { type: 'boolean', example: true },
                    message: { type: 'string', example: 'Swim College API' },
                    version: { type: 'string', example: '1.0.0' },
                    endpoints: { type: 'object' }
                  }
                }
              }
            }
          }
        }
      }
    },
    '/api/auth/init-session': {
      get: {
        tags: ['Auth'],
        summary: 'Initialize session',
        description: 'Initializes a new session with the upstream ASP.NET system.',
        responses: {
          200: {
            description: 'Session initialized',
            content: {
              'application/json': {
                schema: { $ref: '#/components/schemas/SuccessMessage' }
              }
            }
          },
          500: {
            description: 'Server error',
            content: {
              'application/json': {
                schema: { $ref: '#/components/schemas/Error' }
              }
            }
          }
        }
      }
    },
    '/api/auth/login': {
      post: {
        tags: ['Auth'],
        summary: 'Login',
        description: 'Authenticates the user against the upstream ASP.NET system. On success, sets `authenticated` and `cookies` HTTP-only cookies for subsequent requests.',
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: {
                type: 'object',
                required: ['username', 'password'],
                properties: {
                  username: { type: 'string', description: 'User phone number or username', example: '6979753028' },
                  password: { type: 'string', description: 'User password', example: '12449' }
                }
              }
            }
          }
        },
        responses: {
          200: {
            description: 'Login successful. Sets httpOnly cookies for session.',
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    success: { type: 'boolean', example: true },
                    data: {
                      type: 'object',
                      properties: {
                        message: { type: 'string', example: 'Login successful' },
                        userData: {
                          type: 'object',
                          properties: {
                            name: { type: 'string', example: 'John Doe' },
                            expiry: { type: 'string', example: '31/03/2026' },
                            balance: { type: 'string', example: '0.00' }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          },
          400: {
            description: 'Missing username or password',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } }
          },
          401: {
            description: 'Invalid credentials',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } }
          }
        }
      }
    },
    '/api/auth/logout': {
      post: {
        tags: ['Auth'],
        summary: 'Logout',
        description: 'Clears authentication cookies and ends the session.',
        responses: {
          200: {
            description: 'Logged out successfully',
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    success: { type: 'boolean', example: true },
                    message: { type: 'string', example: 'Logged out' }
                  }
                }
              }
            }
          }
        }
      }
    },
    '/api/auth/status': {
      get: {
        tags: ['Auth'],
        summary: 'Check authentication status',
        description: 'Returns whether the user is currently authenticated (has valid cookies).',
        responses: {
          200: {
            description: 'Authentication status',
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    success: { type: 'boolean', example: true },
                    authenticated: { type: 'boolean', example: true }
                  }
                }
              }
            }
          }
        }
      }
    },
    '/api/dashboard': {
      get: {
        tags: ['Dashboard'],
        summary: 'Get dashboard data',
        description: 'Returns the user\'s dashboard information including name, subscription expiry, and account balance.',
        security: [{ cookieAuth: [] }],
        responses: {
          200: {
            description: 'Dashboard data',
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    success: { type: 'boolean', example: true },
                    data: {
                      type: 'object',
                      properties: {
                        name: { type: 'string', example: 'John Doe' },
                        expiry: { type: 'string', example: '31/03/2026' },
                        balance: { type: 'string', example: '0.00' }
                      }
                    }
                  }
                }
              }
            }
          },
          401: { description: 'Not authenticated', content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } } }
        }
      }
    },
    '/api/bookings': {
      get: {
        tags: ['Bookings'],
        summary: 'Get all bookings',
        description: 'Returns all bookings for the authenticated user, including past and upcoming.',
        security: [{ cookieAuth: [] }],
        responses: {
          200: {
            description: 'List of bookings',
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    success: { type: 'boolean', example: true },
                    data: {
                      type: 'object',
                      properties: {
                        total: { type: 'integer', example: 5 },
                        bookings: {
                          type: 'array',
                          items: { $ref: '#/components/schemas/Booking' }
                        }
                      }
                    }
                  }
                }
              }
            }
          },
          401: { description: 'Not authenticated', content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } } }
        }
      }
    },
    '/api/booking/calendar': {
      get: {
        tags: ['Booking'],
        summary: 'Get calendar with availability',
        description: 'Returns calendar days with availability info for a given month and course type.',
        security: [{ cookieAuth: [] }],
        parameters: [
          { name: 'month', in: 'query', schema: { type: 'integer', minimum: 1, maximum: 12 }, description: 'Month (1-12)', example: 2 },
          { name: 'year', in: 'query', schema: { type: 'integer' }, description: 'Year', example: 2026 },
          { name: 'courseType', in: 'query', schema: { type: 'string' }, description: 'Course type code', example: 'BABY' }
        ],
        responses: {
          200: {
            description: 'Calendar days with availability',
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    success: { type: 'boolean', example: true },
                    days: {
                      type: 'array',
                      items: {
                        type: 'object',
                        properties: {
                          day: { type: 'integer', example: 10 },
                          date: { type: 'string', example: '10 February 2026' },
                          hasClasses: { type: 'boolean', example: true },
                          isPast: { type: 'boolean', example: false },
                          postbackArg: { type: 'string', example: '9537' }
                        }
                      }
                    }
                  }
                }
              }
            }
          },
          401: { description: 'Not authenticated', content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } } }
        }
      }
    },
    '/api/booking/slots': {
      get: {
        tags: ['Booking'],
        summary: 'Get available time slots',
        description: 'Returns available time slots for a specific date and course type. Scrapes the upstream ASP.NET viewtmimata.aspx page.',
        security: [{ cookieAuth: [] }],
        parameters: [
          { name: 'date', in: 'query', required: true, schema: { type: 'string', format: 'date' }, description: 'Date in YYYY-MM-DD format', example: '2026-02-11' },
          { name: 'courseType', in: 'query', schema: { type: 'string' }, description: 'Course type code (defaults to BABY)', example: 'BABY' }
        ],
        responses: {
          200: {
            description: 'Available slots',
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    success: { type: 'boolean', example: true },
                    slots: {
                      type: 'array',
                      items: { $ref: '#/components/schemas/TimeSlot' }
                    }
                  }
                }
              }
            }
          },
          400: { description: 'Missing date parameter', content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } } },
          401: { description: 'Not authenticated', content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } } }
        }
      }
    },
    '/api/booking/book': {
      post: {
        tags: ['Booking'],
        summary: 'Book a class',
        description: 'Books a class slot. Navigates the upstream ASP.NET form (select date, click book button, confirm with OK).',
        security: [{ cookieAuth: [] }],
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: {
                type: 'object',
                required: ['date', 'slotId'],
                properties: {
                  date: { type: 'string', format: 'date', description: 'Date in YYYY-MM-DD format', example: '2026-02-11' },
                  courseType: { type: 'string', description: 'Course type code (defaults to BABY)', example: 'BABY' },
                  slotId: { type: 'string', description: 'Slot/Tmima ID from the slots endpoint', example: '12345' }
                }
              }
            }
          }
        },
        responses: {
          200: {
            description: 'Booking result',
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    success: { type: 'boolean', example: true },
                    message: { type: 'string', example: 'Booking confirmed!' },
                    booking: {
                      type: 'object',
                      properties: {
                        id: { type: 'string' },
                        date: { type: 'string' },
                        time: { type: 'string' },
                        course: { type: 'string' },
                        teacher: { type: 'string' },
                        status: { type: 'string', example: 'confirmed' }
                      }
                    }
                  }
                }
              }
            }
          },
          400: { description: 'Missing required fields', content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } } },
          401: { description: 'Not authenticated', content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } } }
        }
      }
    },
    '/api/booking/cancel': {
      post: {
        tags: ['Booking'],
        summary: 'Cancel a booking',
        description: 'Cancels an existing booking by ID. Navigates the upstream ASP.NET krathseis.aspx page.',
        security: [{ cookieAuth: [] }],
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: {
                type: 'object',
                required: ['bookingId'],
                properties: {
                  bookingId: { type: 'string', description: 'Booking ID to cancel', example: '67890' }
                }
              }
            }
          }
        },
        responses: {
          200: {
            description: 'Cancellation result',
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    success: { type: 'boolean', example: true },
                    message: { type: 'string', example: 'Booking cancelled successfully' }
                  }
                }
              }
            }
          },
          400: { description: 'Missing booking ID', content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } } },
          401: { description: 'Not authenticated', content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } } }
        }
      }
    },
    '/api/courses': {
      get: {
        tags: ['Courses'],
        summary: 'Get available course types',
        description: 'Returns all course types available in the system (e.g. BABY, A1, A2, E1, PERSONAL, etc.).',
        security: [{ cookieAuth: [] }],
        responses: {
          200: {
            description: 'Course types',
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    success: { type: 'boolean', example: true },
                    data: {
                      type: 'object',
                      properties: {
                        courseTypes: {
                          type: 'array',
                          items: { type: 'string' },
                          example: ['BABY', 'A1', 'A2', 'E1', 'E2', 'PERSONAL', 'REHAB', 'AEROBICS']
                        }
                      }
                    }
                  }
                }
              }
            }
          },
          401: { description: 'Not authenticated', content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } } }
        }
      }
    },
    '/api/subscriptions': {
      get: {
        tags: ['Subscriptions'],
        summary: 'Get user subscriptions',
        description: 'Returns the user\'s active subscriptions with start/end dates and attendance counts.',
        security: [{ cookieAuth: [] }],
        responses: {
          200: {
            description: 'Subscriptions list',
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    success: { type: 'boolean', example: true },
                    data: {
                      type: 'array',
                      items: { $ref: '#/components/schemas/Subscription' }
                    }
                  }
                }
              }
            }
          },
          401: { description: 'Not authenticated', content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } } }
        }
      }
    },
    '/api/attendances': {
      get: {
        tags: ['Attendances'],
        summary: 'Get attendance history',
        description: 'Returns the user\'s class attendance records with dates and times.',
        security: [{ cookieAuth: [] }],
        responses: {
          200: {
            description: 'Attendance records',
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    success: { type: 'boolean', example: true },
                    data: {
                      type: 'array',
                      items: {
                        type: 'object',
                        properties: {
                          date: { type: 'string', example: 'Δευ 10/02/2026' },
                          time: { type: 'string', example: '10:00 11:00' }
                        }
                      }
                    }
                  }
                }
              }
            }
          },
          401: { description: 'Not authenticated', content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } } }
        }
      }
    },
    '/api/waitlist': {
      get: {
        tags: ['Waitlist'],
        summary: 'Get waitlist entries',
        description: 'Returns classes the user is currently on the waitlist for.',
        security: [{ cookieAuth: [] }],
        responses: {
          200: {
            description: 'Waitlist entries',
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    success: { type: 'boolean', example: true },
                    data: {
                      type: 'array',
                      items: {
                        type: 'object',
                        properties: {
                          details: { type: 'string' }
                        }
                      }
                    }
                  }
                }
              }
            }
          },
          401: { description: 'Not authenticated', content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } } }
        }
      }
    },
    '/api/cancellations': {
      get: {
        tags: ['Cancellations'],
        summary: 'Get cancellation history',
        description: 'Returns the user\'s cancelled classes history.',
        security: [{ cookieAuth: [] }],
        responses: {
          200: {
            description: 'Cancellation records',
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    success: { type: 'boolean', example: true },
                    data: {
                      type: 'array',
                      items: {
                        type: 'object',
                        properties: {
                          details: { type: 'string' }
                        }
                      }
                    }
                  }
                }
              }
            }
          },
          401: { description: 'Not authenticated', content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } } }
        }
      }
    },
    '/api/barcode': {
      get: {
        tags: ['Barcode'],
        summary: 'Get member barcode',
        description: 'Returns the user\'s member barcode number and SVG image for facility entry.',
        security: [{ cookieAuth: [] }],
        responses: {
          200: {
            description: 'Barcode data',
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    success: { type: 'boolean', example: true },
                    data: {
                      type: 'object',
                      properties: {
                        code: { type: 'string', example: '123456789' },
                        svg: { type: 'string', description: 'SVG markup of the barcode' }
                      }
                    }
                  }
                }
              }
            }
          },
          401: { description: 'Not authenticated', content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } } }
        }
      }
    },
    '/api/users': {
      get: {
        tags: ['Users'],
        summary: 'Get user profile',
        description: 'Returns the authenticated user\'s profile information.',
        security: [{ cookieAuth: [] }],
        responses: {
          200: {
            description: 'User profile',
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    success: { type: 'boolean', example: true },
                    data: {
                      type: 'object',
                      properties: {
                        name: { type: 'string', example: 'John Doe' },
                        expiry: { type: 'string', example: '31/03/2026' },
                        balance: { type: 'string', example: '0.00' }
                      }
                    }
                  }
                }
              }
            }
          },
          401: { description: 'Not authenticated', content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } } }
        }
      }
    }
  },
  components: {
    securitySchemes: {
      cookieAuth: {
        type: 'apiKey',
        in: 'cookie',
        name: 'authenticated',
        description: 'Set automatically by the login endpoint. Cookie value must be "true".'
      }
    },
    schemas: {
      Error: {
        type: 'object',
        properties: {
          success: { type: 'boolean', example: false },
          error: { type: 'string', example: 'Error description' }
        }
      },
      SuccessMessage: {
        type: 'object',
        properties: {
          success: { type: 'boolean', example: true },
          data: {
            type: 'object',
            properties: {
              message: { type: 'string' }
            }
          }
        }
      },
      Booking: {
        type: 'object',
        properties: {
          id: { type: 'string', description: 'Booking ID', example: '12345' },
          course: { type: 'string', description: 'Course name', example: 'BABY SWIMMING' },
          date: { type: 'string', description: 'Date in "Day DD/MM/YYYY" format', example: 'Δευ 10/02/2026' },
          time: { type: 'string', description: 'Time range', example: '10:00 11:00' },
          status: { type: 'string', description: 'Booking status', example: 'pending' },
          statusText: { type: 'string', description: 'Localized status text', example: 'Εκκρεμεί' }
        }
      },
      TimeSlot: {
        type: 'object',
        properties: {
          id: { type: 'string', description: 'Tmima (class section) ID', example: '5678' },
          course: { type: 'string', description: 'Course name', example: 'BABY SWIMMING' },
          date: { type: 'string', description: 'Date in DD/MM/YYYY format', example: '11/02/2026' },
          time: { type: 'string', description: 'Time range', example: '10:00 - 11:00' },
          teacher: { type: 'string', description: 'Teacher name', example: 'Maria K.' },
          persons: { type: 'integer', description: 'Number of people enrolled', example: 3 },
          canBook: { type: 'boolean', description: 'Whether slot can be booked', example: true },
          status: { type: 'string', enum: ['available', 'past', 'cancelled'], description: 'Slot status' },
          bookButtonName: { type: 'string', description: 'Internal ASP.NET button name (used by book endpoint)', example: 'repeater1$ctl00$btn1' }
        }
      },
      Subscription: {
        type: 'object',
        properties: {
          name: { type: 'string', description: 'Subscription name', example: 'Monthly Pass' },
          start: { type: 'string', description: 'Start date', example: '01/01/2026' },
          end: { type: 'string', description: 'End date', example: '31/03/2026' },
          attendances: { type: 'string', description: 'Attendance count', example: '12' },
          remaining: { type: 'string', description: 'Remaining info', example: '8 remaining' }
        }
      }
    }
  }
};

module.exports = swaggerDefinition;
