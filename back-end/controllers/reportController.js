const prisma = require('../prisma/prisma');

const reportController = {
  // GET /admin/reports/sales
  getSalesReport: async (req, res) => {
    try {
      const { startDate, endDate, productId, userId } = req.query;
      const orderWhere = {};
      if (startDate || endDate) {
        orderWhere.orderDate = {};
        if (startDate) orderWhere.orderDate.gte = new Date(startDate);
        if (endDate) orderWhere.orderDate.lte = new Date(endDate);
      }
      if (userId) orderWhere.userId = userId;
      const orders = await prisma.order.findMany({
        where: orderWhere,
        include: {
          orderItems: {
            include: {
              product: true
            }
          },
          user: true
        }
      });
      // Flatten all order items
      let allItems = [];
      orders.forEach(order => {
        order.orderItems.forEach(item => {
          if (!productId || item.productId === productId) {
            allItems.push({
              ...item,
              order,
              user: order.user,
              product: item.product
            });
          }
        });
      });
      // Total sales and count
      const totalSales = allItems.reduce((sum, item) => sum + item.unitPrice * item.quantity, 0);
      const salesCount = allItems.length;
      // Breakdown by product
      const salesByProduct = {};
      allItems.forEach(item => {
        const key = item.productId;
        if (!salesByProduct[key]) {
          salesByProduct[key] = {
            productId: key,
            productName: item.product.name,
            totalSold: 0,
            totalRevenue: 0
          };
        }
        salesByProduct[key].totalSold += item.quantity;
        salesByProduct[key].totalRevenue += item.unitPrice * item.quantity;
      });
      // Breakdown by user
      const salesByUser = {};
      allItems.forEach(item => {
        const key = item.user.id;
        if (!salesByUser[key]) {
          salesByUser[key] = {
            userId: key,
            userName: item.user.name,
            userRole: item.user.role,
            totalSold: 0,
            totalRevenue: 0
          };
        }
        salesByUser[key].totalSold += item.quantity;
        salesByUser[key].totalRevenue += item.unitPrice * item.quantity;
      });
      res.json({
        totalSales,
        salesCount,
        salesByProduct: Object.values(salesByProduct),
        salesByUser: Object.values(salesByUser)
      });
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: 'Failed to generate sales report' });
    }
  },

  // GET /admin/reports/inventory
  getInventoryReport: async (req, res) => {
    try {
      const products = await prisma.product.findMany();
      // For each product, get current stock (stockQuantity), warranty, and low stock alert
      const inventory = products.map(product => ({
        id: product.id,
        name: product.name,
        stockQuantity: product.stockQuantity,
        warrantyPeriodInMonths: product.warrantyPeriodInMonths,
        lowStock: product.stockQuantity < 10
      }));
      res.json(inventory);
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: 'Failed to generate inventory report' });
    }
  },

  // GET /admin/reports/performance
  getPerformanceReport: async (req, res) => {
    try {
      // Top-selling products
      const orderItems = await prisma.orderItem.findMany({
        include: { product: true, order: { include: { user: true } } }
      });
      const productSales = {};
      const userSales = {};
      orderItems.forEach(item => {
        // By product
        if (!productSales[item.productId]) {
          productSales[item.productId] = {
            productId: item.productId,
            productName: item.product.name,
            totalSold: 0
          };
        }
        productSales[item.productId].totalSold += item.quantity;
        // By user
        const user = item.order.user;
        if (!userSales[user.id]) {
          userSales[user.id] = {
            userId: user.id,
            userName: user.name,
            userRole: user.role,
            totalSold: 0
          };
        }
        userSales[user.id].totalSold += item.quantity;
      });
      // Sort and get top 5
      const topProducts = Object.values(productSales).sort((a, b) => b.totalSold - a.totalSold).slice(0, 5);
      const topUsers = Object.values(userSales).sort((a, b) => b.totalSold - a.totalSold).slice(0, 5);
      res.json({ topProducts, topUsers });
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: 'Failed to generate performance report' });
    }
  },
};

module.exports = reportController; 