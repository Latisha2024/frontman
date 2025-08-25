const { PrismaClient } = require('@prisma/client');
const prisma = require('../prisma/prisma');

const orderController = {
  placeOrder: async (req, res) => {
    const userId = req.user.id;
    const { items } = req.body; // [{ productId, quantity }]
  
    try {
      if (!items || !Array.isArray(items) || items.length === 0) {
        return res.status(400).json({ message: 'No items provided' });
      }
  
      await prisma.$transaction(async (tx) => {
        const productIds = items.map(item => item.productId);
  
        const products = await tx.product.findMany({
          where: { id: { in: productIds } }
        });
  
        const orderItemsData = items.map(item => {
          const product = products.find(p => p.id === item.productId);
          if (!product) throw new Error(`Invalid product ID: ${item.productId}`);
  
          if (product.stockQuantity < item.quantity) {
            throw new Error(`Not enough stock for ${product.name}`);
          }
  
          return {
            productId: item.productId,
            quantity: item.quantity,
            unitPrice: product.price
          };
        });
  
        // Deduct product stock
        for (const item of orderItemsData) {
          await tx.product.update({
            where: { id: item.productId },
            data: {
              stockQuantity: {
                decrement: item.quantity
              }
            }
          });
        }
  
        // Create order and order items
        const order = await tx.order.create({
          data: {
            userId,
            status: 'Pending',
            orderDate: new Date(),
            orderItems: {
              create: orderItemsData
            }
          },
          include: {
            orderItems: true
          }
        });
  
        res.status(201).json({ message: 'Order placed', order });
      });
    } catch (err) {
      console.error('Order Error:', err);
      res.status(500).json({ message: 'Order placement failed', error: err.message });
    }
  },
  

  getMyOrders: async (req, res) => {
  const userId = req.user.id;

  try {
    const orders = await prisma.order.findMany({
      where: { userId },
      include: {
        orderItems: {
          include: {
            product: {
              select: {
                name: true,
                price: true
              }
            }
          }
        }
      },
      orderBy: {
        orderDate: 'desc'
      }
    });

    // Optional: Add computed total amount
    const formatted = orders.map(order => {
      const totalAmount = order.orderItems.reduce((sum, item) => {
        return sum + item.unitPrice * item.quantity;
      }, 0);

      return {
        id: order.id,
        orderDate: order.orderDate,
        status: order.status,
        totalAmount,
        items: order.orderItems.map(item => ({
          productName: item.product.name,
          quantity: item.quantity,
          unitPrice: item.unitPrice
        }))
      };
    });

    res.json(formatted);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Failed to fetch orders' });
  }
},

  // GET /admin/orders
  getAllOrders: async (req, res) => {
    try {
      const { status, userId } = req.query;
      const where = {};
      if (status) where.status = status;
      if (userId) where.userId = userId;
      const orders = await prisma.order.findMany({
        where,
        include: {
          user: { select: { id: true, name: true, email: true, role: true } },
          orderItems: {
            include: {
              product: { select: { name: true, price: true } }
            }
          },
          invoice: true
        },
        orderBy: { orderDate: 'desc' }
      });
      res.json(orders);
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: 'Failed to fetch orders' });
    }
  },

  // GET /admin/orders/:id
  getOrderById: async (req, res) => {
    try {
      const { id } = req.params;
      const order = await prisma.order.findUnique({
        where: { id },
        include: {
          user: { select: { id: true, name: true, email: true, role: true } },
          orderItems: {
            include: {
              product: { select: { name: true, price: true } }
            }
          },
          invoice: true
        }
      });
      if (!order) return res.status(404).json({ message: 'Order not found' });
      res.json(order);
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: 'Failed to fetch order' });
    }
  },

};

module.exports = orderController;
