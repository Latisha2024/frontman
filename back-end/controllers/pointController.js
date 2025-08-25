const prisma = require('../prisma/prisma');

const pointController = {
  // Admin: GET /admin/points?userId=&type=
  getAllTransactions: async (req, res) => {
    try {
      const { userId, type } = req.query;
      const filters = {};
      if (userId) filters.userId = userId;
      if (type) filters.type = type;

      const txns = await prisma.pointTransaction.findMany({
        where: filters,
        include: {
          user: {
            select: { id: true, name: true, role: true }
          }
        },
        orderBy: { date: 'desc' }
      });

      res.json(txns);
    } catch (err) {
      console.error('getAllTransactions error:', err);
      res.status(500).json({ message: 'Failed to fetch transactions' });
    }
  },

  // User: GET /user/points
  getMyTransactions: async (req, res) => {
    try {
      const userId = req.user.id;

      const txns = await prisma.pointTransaction.findMany({
        where: { userId },
        orderBy: { date: 'desc' }
      });

      res.json(txns);
    } catch (err) {
      console.error('getMyTransactions error:', err);
      res.status(500).json({ message: 'Failed to fetch your transactions' });
    }
  },

  // User: POST /user/points/claim
  claimPoints: async (req, res) => {
    try {
      const userId = req.user.id;
      const { points, reason } = req.body;

      if (!points || !reason) {
        return res.status(400).json({ message: 'Missing required fields' });
      }

      const txn = await prisma.pointTransaction.create({
        data: {
          userId,
          points: -Math.abs(points),
          creditAmount: 0,
          reason,
          type: 'Claimed',
          date: new Date()
        }
      });

      res.status(201).json({ message: 'Points claimed', transaction: txn });
    } catch (err) {
      console.error('claimPoints error:', err);
      res.status(500).json({ message: 'Failed to claim points' });
    }
  },

  // Admin: POST /admin/points/adjust
  adjustPoints: async (req, res) => {
    try {
      const { userId, points, reason } = req.body;

      if (!userId || !points || !reason) {
        return res.status(400).json({ message: 'Missing required fields' });
      }

      const txn = await prisma.pointTransaction.create({
        data: {
          userId,
          points,
          creditAmount: 0,
          reason,
          type: 'Adjusted',
          date: new Date()
        }
      });

      res.status(201).json({ message: 'Points adjusted', transaction: txn });
    } catch (err) {
      console.error('adjustPoints error:', err);
      res.status(500).json({ message: 'Failed to adjust points' });
    }
  }
};

module.exports = pointController;
