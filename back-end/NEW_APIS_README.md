# New Admin APIs Documentation

This document describes the three new APIs that have been added to the backend system.

## 1. Points to Cash Conversion API

**Endpoint:** `POST /admin/points/convert`

**Description:** Allows administrators to convert user points to cash at a specified conversion rate.

**Request Body:**
```json
{
  "userId": "string",
  "points": "number",
  "conversionRate": "number",
  "reason": "string (optional)"
}
```

**Response:**
```json
{
  "message": "Points converted to cash successfully",
  "pointsConverted": 100,
  "cashAmount": 1.00,
  "conversionRate": 0.01,
  "pointsTransaction": {...},
  "cashTransaction": {...}
}
```

**Features:**
- Validates user has sufficient points
- Creates two transaction records (points deduction + cash credit)
- Supports custom conversion rates
- Includes reason tracking

## 2. Invoice Posting API

**Endpoint:** `POST /admin/invoices`

**Description:** Allows administrators to manually create invoices for users with custom items and amounts.

**Request Body:**
```json
{
  "userId": "string",
  "totalAmount": "number",
  "items": [
    {
      "productName": "string",
      "quantity": "number",
      "unitPrice": "number"
    }
  ],
  "description": "string (optional)",
  "dueDate": "date (optional)"
}
```

**Response:**
```json
{
  "message": "Invoice created successfully",
  "invoice": {
    "id": "string",
    "orderId": "string",
    "invoiceDate": "date",
    "totalAmount": 150.00,
    "pdfUrl": "string",
    "order": {...},
    "user": {...}
  }
}
```

**Features:**
- Creates custom products for invoice items
- Validates total amount matches item calculations
- Generates PDF URL for invoice
- Links to user and creates order records

## 3. Individual Report API

**Endpoint:** `GET /admin/reports/individual`

**Description:** Generates comprehensive individual user reports with multiple report types and date filtering.

**Query Parameters:**
- `userId` (required): User ID for the report
- `startDate` (optional): Start date for filtering
- `endDate` (optional): End date for filtering
- `reportType` (optional): Type of report (default: "performance")
  - `sales`: Sales performance data
  - `attendance`: Attendance and work hours
  - `points`: Points and cash transactions
  - `performance`: Comprehensive overview

**Response Examples:**

**Sales Report:**
```json
{
  "userId": "string",
  "userName": "string",
  "userRole": "string",
  "reportType": "sales",
  "salesData": {
    "totalSales": 1500.00,
    "totalOrders": 15,
    "totalItems": 45,
    "orders": [...]
  }
}
```

**Attendance Report:**
```json
{
  "attendanceData": {
    "totalDays": 30,
    "presentDays": 28,
    "absentDays": 2,
    "attendanceRate": 93.33,
    "averageWorkHours": 8.5,
    "attendances": [...]
  }
}
```

**Points Report:**
```json
{
  "pointsData": {
    "totalPointsEarned": 500,
    "totalPointsClaimed": 200,
    "totalCashEarned": 50.00,
    "currentBalance": 300,
    "transactions": [...]
  }
}
```

**Performance Report:**
```json
{
  "performanceData": {
    "totalSales": 1500.00,
    "totalOrders": 15,
    "attendanceRate": 93.33,
    "totalPoints": 300
  }
}
```

## Authentication & Authorization

All three APIs require:
- Valid JWT token in Authorization header: `Bearer <token>`
- Admin role permissions
- Middleware: `authenticate` and `authorizeRoles('Admin')`

## Error Handling

The APIs include comprehensive error handling:
- **400 Bad Request**: Missing/invalid required fields
- **401 Unauthorized**: Invalid or missing token
- **403 Forbidden**: Insufficient role permissions
- **404 Not Found**: User not found
- **500 Internal Server Error**: Server-side errors

## Testing

Run the tests with:
```bash
npm test
```

Or run specific test file:
```bash
npm test tests/admin/new-apis.test.js
```

## Database Schema

These APIs work with the existing Prisma schema and create the necessary relationships:
- Points conversion creates `PointTransaction` records
- Invoice posting creates `Order`, `OrderItem`, and `Invoice` records
- Individual reports query existing data across multiple models

## Notes

- Points conversion validates sufficient balance before processing
- Invoice posting creates custom products for flexibility
- Individual reports support date filtering and multiple report types
- All APIs include comprehensive Swagger documentation
- Error messages are user-friendly and descriptive
