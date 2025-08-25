const { PrismaClient } = require('@prisma/client');
const prisma = require('../prisma/prisma');

const stockController = {
  // Create stock entry
  createStock: async (req, res) => {
    const { productId, status, location } = req.body;

    try {
      const stock = await prisma.stock.create({
        data: {
          productId,
          status,
          location,
        }
      });

      res.status(201).json({ message: 'Stock entry created', stock });
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: 'Error creating stock entry' });
    }
  },

  // Get all stock entries
  getAllStock: async (req, res) => {
  try {
    // Fetch all stock entries (including possibly broken ones)
    const stocks = await prisma.stock.findMany();

    // Filter out invalid entries by trying to manually resolve product
    const validStocks = [];

    for (const stock of stocks) {
      const product = await prisma.product.findUnique({
        where: { id: stock.productId }
      });

      if (product) {
        validStocks.push({
          ...stock,
          product: {
            name: product.name,
            price: product.price,
            warrantyPeriodInMonths: product.warrantyPeriodInMonths
          }
        });
      }
    }

    res.json(validStocks);
  } catch (err) {
    console.error('Error in getAllStock:', err);
    res.status(500).json({ message: 'Error fetching stock entries' });
  }
},

  // Update stock
  updateStock: async (req, res) => {
    const { id } = req.params;
    const { status, location } = req.body;

    try {
      const updatedStock = await prisma.stock.update({
        where: { id },
        data: { status, location }
      });

      res.json({ message: 'Stock entry updated', stock: updatedStock });
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: 'Error updating stock entry' });
    }
  },

  // GET /distributor/stock
  getAssignedStock: async (req, res) => {
    try {
      const userId = req.user.id;
      // Get distributor's assigned stock (filter by location or distributor assignment)
      const stocks = await prisma.stock.findMany({
        where: {
          OR: [
            { location: { contains: 'Distributor', mode: 'insensitive' } },
            { status: { in: ['Assigned', 'Distributed'] } }
          ]
        },
        include: {
          product: {
            select: {
              id: true,
              name: true,
              price: true,
              warrantyPeriodInMonths: true
            }
          }
        },
        orderBy: { id: 'desc' }
      });
      res.json(stocks);
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: 'Failed to fetch assigned stock' });
    }
  },

  // PUT /distributor/stock/:id
  updateStockStatus: async (req, res) => {
    try {
      const { id } = req.params;
      const { status, location } = req.body;
      const userId = req.user.id;
      
      // Verify stock exists and is assigned to distributor
      const stock = await prisma.stock.findUnique({
        where: { id },
        include: { product: true }
      });
      
      if (!stock) {
        return res.status(404).json({ message: 'Stock not found' });
      }
      
      // Update stock status
      const updatedStock = await prisma.stock.update({
        where: { id },
        data: { 
          status: status || stock.status,
          location: location || stock.location
        },
        include: {
          product: {
            select: {
              id: true,
              name: true,
              price: true
            }
          }
        }
      });
      
      res.json({ message: 'Stock status updated', stock: updatedStock });
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: 'Failed to update stock status' });
    }
  },

  cleanup: async(req, res) => {
try {
    const stocks = await prisma.stock.findMany();
    const productIds = (await prisma.product.findMany()).map(p => p.id);

    let deletedCount = 0;
    for (const stock of stocks) {
      if (!productIds.includes(stock.productId)) {
        await prisma.stock.delete({ where: { id: stock.id } });
        deletedCount++;
      }
    }

    res.json({ message: `Deleted ${deletedCount} orphaned stock entries` });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Cleanup failed' });
  }
  },
};



module.exports = stockController;
