const express = require('express');
const router = express.Router();
const prisma = require('../../prisma/prisma');
const authenticate = require('../../middlewares/auth');
const authorizeRoles = require('../../middlewares/roleCheck');

// List orders accessible to Distributor
router.use(authenticate);
router.use(authorizeRoles('Distributor'));

// GET /distributor/orders - List all orders for dropdown
router.get('/', async (req, res) => {
  try {
    const orders = await prisma.order.findMany({
      where: {
        distributorId: req.user.id, // Assuming user.id is the distributor ID
      },
      select: { 
        id: true, 
        status: true, 
        orderDate: true,
        total: true,
      },
      orderBy: { orderDate: 'desc' },
    });
    res.json(orders);
  } catch (err) {
    console.error('GET /distributor/orders error:', err);
    res.status(500).json({ message: 'Failed to fetch orders' });
  }
});

module.exports = router;
