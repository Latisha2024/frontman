const { PrismaClient } = require('@prisma/client');
const prisma = require('../prisma/prisma');

const accountantController = {
  // Financial Logs APIs
  
  // Get all financial logs
  getAllFinancialLogs: async (req, res) => {
    try {
      const { type, startDate, endDate, category, page = 1, limit = 10 } = req.query;
      
      const where = {};
      
      if (type) where.type = type;
      if (category) where.category = category;
      if (startDate || endDate) {
        where.createdAt = {};
        if (startDate) where.createdAt.gte = new Date(startDate);
        if (endDate) where.createdAt.lte = new Date(endDate);
      }

      const skip = (parseInt(page) - 1) * parseInt(limit);
      
      const [financialLogs, total] = await Promise.all([
        prisma.financialLog.findMany({
          where,
          include: {
            createdByUser: {
              select: {
                id: true,
                name: true,
                email: true,
                role: true
              }
            }
          },
          orderBy: { createdAt: 'desc' },
          skip,
          take: parseInt(limit)
        }),
        prisma.financialLog.count({ where })
      ]);

      res.json({
        financialLogs,
        pagination: {
          page: parseInt(page),
          limit: parseInt(limit),
          total,
          pages: Math.ceil(total / parseInt(limit))
        }
      });
    } catch (err) {
      console.error('getAllFinancialLogs error:', err);
      res.status(500).json({ message: 'Failed to fetch financial logs', error: err.message });
    }
  },

  // Create new financial log
  createFinancialLog: async (req, res) => {
    try {
      const { type, amount, description, category, reference } = req.body;
      const createdBy = req.user.id;

      if (!type || !amount || !description) {
        return res.status(400).json({ 
          message: 'Type, amount, and description are required' 
        });
      }

      if (!['Income', 'Expense', 'Transfer', 'Adjustment'].includes(type)) {
        return res.status(400).json({ 
          message: 'Invalid type. Must be Income, Expense, Transfer, or Adjustment' 
        });
      }

      if (amount <= 0) {
        return res.status(400).json({ 
          message: 'Amount must be positive' 
        });
      }

      const financialLog = await prisma.financialLog.create({
        data: {
          type,
          amount: parseFloat(amount),
          description,
          category: category || null,
          reference: reference || null,
          createdBy
        },
        include: {
          createdByUser: {
            select: {
              id: true,
              name: true,
              email: true,
              role: true
            }
          }
        }
      });

      res.status(201).json({ 
        message: 'Financial log created successfully',
        financialLog 
      });
    } catch (err) {
      console.error('createFinancialLog error:', err);
      res.status(500).json({ message: 'Failed to create financial log', error: err.message });
    }
  },

  // Delete financial log
  deleteFinancialLog: async (req, res) => {
    try {
      const { id } = req.params;

      const financialLog = await prisma.financialLog.findUnique({
        where: { id }
      });

      if (!financialLog) {
        return res.status(404).json({ message: 'Financial log not found' });
      }

      await prisma.financialLog.delete({
        where: { id }
      });

      res.json({ message: 'Financial log deleted successfully' });
    } catch (err) {
      console.error('deleteFinancialLog error:', err);
      res.status(500).json({ message: 'Failed to delete financial log', error: err.message });
    }
  },

  // Invoice APIs

  // Get all invoices
  getAllInvoices: async (req, res) => {
    try {
      const { status, startDate, endDate, userId, page = 1, limit = 10 } = req.query;
      
      const where = {};
      
      if (status) where.status = status;
      if (startDate || endDate) {
        where.invoiceDate = {};
        if (startDate) where.invoiceDate.gte = new Date(startDate);
        if (endDate) where.invoiceDate.lte = new Date(endDate);
      }

      const skip = (parseInt(page) - 1) * parseInt(limit);
      
      const [invoices, total] = await Promise.all([
        prisma.invoice.findMany({
          where,
          include: {
            order: {
              include: {
                user: { 
                  select: { 
                    id: true, 
                    name: true, 
                    email: true, 
                    role: true 
                  } 
                },
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
          },
          orderBy: { invoiceDate: 'desc' },
          skip,
          take: parseInt(limit)
        }),
        prisma.invoice.count({ where })
      ]);

      // Filter by userId if provided
      const filteredInvoices = userId ? 
        invoices.filter(invoice => invoice.order.user.id === userId) : 
        invoices;

      res.json({
        invoices: filteredInvoices,
        pagination: {
          page: parseInt(page),
          limit: parseInt(limit),
          total,
          pages: Math.ceil(total / parseInt(limit))
        }
      });
    } catch (err) {
      console.error('getAllInvoices error:', err);
      res.status(500).json({ message: 'Failed to fetch invoices', error: err.message });
    }
  },

  // Create new invoice (manual creation)
  createInvoice: async (req, res) => {
    try {
      const { userId, totalAmount, items, description, dueDate } = req.body;

      if (!userId || !totalAmount || !items || !Array.isArray(items)) {
        return res.status(400).json({ 
          message: 'Missing required fields or invalid items format' 
        });
      }

      if (items.length === 0) {
        return res.status(400).json({ message: 'Items array cannot be empty' });
      }

      // Validate each item
      for (const item of items) {
        if (!item.productName || !item.quantity || !item.unitPrice) {
          return res.status(400).json({ 
            message: 'Each item must have productName, quantity, and unitPrice' 
          });
        }
        if (item.quantity <= 0 || item.unitPrice <= 0) {
          return res.status(400).json({ 
            message: 'Quantity and unitPrice must be positive' 
          });
        }
      }

      // Verify user exists
      const user = await prisma.user.findUnique({
        where: { id: userId }
      });

      if (!user) {
        return res.status(404).json({ message: 'User not found' });
      }

      // Calculate total from items to validate
      const calculatedTotal = items.reduce((sum, item) => sum + (item.quantity * item.unitPrice), 0);
      
      if (Math.abs(calculatedTotal - totalAmount) > 0.01) {
        return res.status(400).json({ 
          message: 'Total amount does not match calculated total from items',
          calculatedTotal: calculatedTotal,
          providedTotal: totalAmount
        });
      }

      // Create order for the invoice
      const order = await prisma.order.create({
        data: {
          userId,
          status: 'Completed',
          orderDate: new Date()
        }
      });

      // Create order items with custom products
      const orderItems = [];
      for (const item of items) {
        const customProduct = await prisma.product.create({
          data: {
            name: item.productName,
            price: item.unitPrice,
            stockQuantity: 0,
            warrantyPeriodInMonths: 0
          }
        });

        const orderItem = await prisma.orderItem.create({
          data: {
            orderId: order.id,
            productId: customProduct.id,
            quantity: item.quantity,
            unitPrice: item.unitPrice
          }
        });

        orderItems.push(orderItem);
      }

      // Create the invoice
      const invoice = await prisma.invoice.create({
        data: {
          orderId: order.id,
          invoiceDate: new Date(),
          totalAmount,
          pdfUrl: `https://invoices.example.com/manual_invoice_${order.id}.pdf`,
          status: 'Draft',
          dueDate: dueDate ? new Date(dueDate) : null
        },
        include: {
          order: {
            include: {
              user: { 
                select: { 
                  id: true, 
                  name: true, 
                  email: true, 
                  role: true 
                } 
              },
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

      res.status(201).json({ 
        message: 'Invoice created successfully',
        invoice 
      });
    } catch (err) {
      console.error('createInvoice error:', err);
      res.status(500).json({ message: 'Failed to create invoice', error: err.message });
    }
  },

  // Send invoice (mark as sent)
  sendInvoice: async (req, res) => {
    try {
      const { id } = req.params;

      const invoice = await prisma.invoice.findUnique({
        where: { id }
      });

      if (!invoice) {
        return res.status(404).json({ message: 'Invoice not found' });
      }

      if (invoice.status === 'Paid') {
        return res.status(400).json({ message: 'Cannot send an already paid invoice' });
      }

      const updatedInvoice = await prisma.invoice.update({
        where: { id },
        data: {
          status: 'Sent',
          sentAt: new Date()
        },
        include: {
          order: {
            include: {
              user: { 
                select: { 
                  id: true, 
                  name: true, 
                  email: true, 
                  role: true 
                } 
              },
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

      res.json({ 
        message: 'Invoice sent successfully',
        invoice: updatedInvoice 
      });
    } catch (err) {
      console.error('sendInvoice error:', err);
      res.status(500).json({ message: 'Failed to send invoice', error: err.message });
    }
  },

  // Verify payment (mark invoice as paid)
  verifyPayment: async (req, res) => {
    try {
      const { id } = req.params;
      const { paymentMethod, paymentReference } = req.body;

      const invoice = await prisma.invoice.findUnique({
        where: { id }
      });

      if (!invoice) {
        return res.status(404).json({ message: 'Invoice not found' });
      }

      if (invoice.status === 'Paid') {
        return res.status(400).json({ message: 'Invoice is already marked as paid' });
      }

      const updatedInvoice = await prisma.invoice.update({
        where: { id },
        data: {
          status: 'Paid',
          paidAt: new Date()
        },
        include: {
          order: {
            include: {
              user: { 
                select: { 
                  id: true, 
                  name: true, 
                  email: true, 
                  role: true 
                } 
              },
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

      // Create a financial log for the payment
      await prisma.financialLog.create({
        data: {
          type: 'Income',
          amount: invoice.totalAmount,
          description: `Payment received for invoice ${invoice.id}`,
          category: 'Invoice Payment',
          reference: invoice.id,
          createdBy: req.user.id
        }
      });

      res.json({ 
        message: 'Payment verified and invoice marked as paid',
        invoice: updatedInvoice 
      });
    } catch (err) {
      console.error('verifyPayment error:', err);
      res.status(500).json({ message: 'Failed to verify payment', error: err.message });
    }
  }
};

module.exports = accountantController;
