const { PrismaClient } = require('@prisma/client');
const prisma = require('../prisma/prisma');

const invoiceController = {
  generateInvoice: async (req, res) => {
    const { orderId } = req.params;

    try {
      // Check if invoice already exists
      const existing = await prisma.invoice.findUnique({
        where: { orderId }
      });

      if (existing) {
        return res.status(400).json({ message: 'Invoice already generated for this order' });
      }

      // Fetch the order with items
      const order = await prisma.order.findUnique({
        where: { id: orderId },
        include: {
          orderItems: true
        }
      });

      if (!order) {
        return res.status(404).json({ message: 'Order not found' });
      }

      // Calculate total amount
      const totalAmount = order.orderItems.reduce((sum, item) => {
        return sum + item.unitPrice * item.quantity;
      }, 0);

      // Simulate PDF URL generation
      const pdfUrl = `https://invoices.example.com/invoice_${order.id}.pdf`;

      // Create the invoice
      const invoice = await prisma.invoice.create({
        data: {
          orderId,
          invoiceDate: new Date(),
          totalAmount,
          pdfUrl
        }
      });

      res.status(201).json({ message: 'Invoice generated', invoice });
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: 'Invoice generation failed', error: err.message });
    }
  },
  getInvoice: async (req, res) => {
  const { orderId } = req.params;

  try {
    const invoice = await prisma.invoice.findUnique({
      where: { orderId },
      include: {
        order: {
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
          }
        }
      }
    });

    if (!invoice) {
      return res.status(404).json({ message: 'Invoice not found' });
    }

    res.json(invoice);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Failed to fetch invoice', error: err.message });
  }
},
  // GET /admin/invoices
  getAllInvoices: async (req, res) => {
    try {
      const { orderId, userId, startDate, endDate } = req.query;
      const where = {};
      if (orderId) where.orderId = orderId;
      if (startDate || endDate) {
        where.invoiceDate = {};
        if (startDate) where.invoiceDate.gte = new Date(startDate);
        if (endDate) where.invoiceDate.lte = new Date(endDate);
      }
      const invoices = await prisma.invoice.findMany({
        where,
        include: {
          order: {
            include: {
              user: { select: { id: true, name: true, email: true, role: true } },
              orderItems: {
                include: { product: { select: { name: true, price: true } } }
              }
            }
          }
        },
        orderBy: { invoiceDate: 'desc' }
      });
      // Optionally filter by userId
      const filtered = userId ? invoices.filter(inv => inv.order.user.id === userId) : invoices;
      res.json(filtered);
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: 'Failed to fetch invoices' });
    }
  },

  // GET /admin/invoices/:id
  getInvoiceById: async (req, res) => {
    try {
      const { id } = req.params;
      const invoice = await prisma.invoice.findUnique({
        where: { id },
        include: {
          order: {
            include: {
              user: { select: { id: true, name: true, email: true, role: true } },
              orderItems: {
                include: { product: { select: { name: true, price: true } } }
              }
            }
          }
        }
      });
      if (!invoice) return res.status(404).json({ message: 'Invoice not found' });
      res.json(invoice);
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: 'Failed to fetch invoice' });
    }
  },
};

module.exports = invoiceController;
