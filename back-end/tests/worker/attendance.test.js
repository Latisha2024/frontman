const request = require('supertest');
const app = require('../../app');
const { loginAs } = require('../testUtils');
<<<<<<< HEAD

describe('Worker Attendance API', () => {
  let token;

  beforeAll(async () => {
    token = await loginAs('Worker');
  });

  it('should mark attendance', async () => {
=======
const prisma = require('../../prisma/prisma'); // Ensure this points to your Prisma client

describe('Worker Attendance API', () => {
  let token;
  let workerId;

  beforeAll(async () => {
    // Login as Worker and get token
    token = await loginAs('Worker');

    // Extract worker ID from token or fetch from DB if needed
    const decoded = JSON.parse(Buffer.from(token.split('.')[1], 'base64').toString());
    workerId = decoded.userId; // adjust according to your JWT payload
  });

  beforeEach(async () => {
    // ✅ Clear previous attendance records for this worker
    await prisma.attendance.deleteMany({
      where: { userId: workerId }
    });
  });

  afterAll(async () => {
    // ✅ Close DB connection
    await prisma.$disconnect();
  });

  it('should mark attendance (check-in)', async () => {
    const res = await request(app)
      .post('/worker/attendance')
      .set('Authorization', `Bearer ${token}`)
      .send({});

    expect([200, 201]).toContain(res.statusCode);
  });

  it('should mark attendance (check-out after check-in)', async () => {
    // First call -> check-in
    await request(app)
      .post('/worker/attendance')
      .set('Authorization', `Bearer ${token}`)
      .send({});

    // Second call -> check-out
>>>>>>> 04113530de9832f4179ec37bc2135fedf490d6b5
    const res = await request(app)
      .post('/worker/attendance')
      .set('Authorization', `Bearer ${token}`)
      .send({});

    expect([200, 201]).toContain(res.statusCode);
  });
});
