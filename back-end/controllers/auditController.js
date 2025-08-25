const prisma = require('../prisma/prisma');

const auditController = {
  // GET /admin/audit-logs
  getAuditLogs: async (req, res) => {
    try {
      const { userId, action, resource, startDate, endDate } = req.query;
      const where = {};
      if (userId) where.userId = userId;
      if (action) where.action = action;
      if (resource) where.resource = resource;
      if (startDate || endDate) {
        where.timestamp = {};
        if (startDate) where.timestamp.gte = new Date(startDate);
        if (endDate) where.timestamp.lte = new Date(endDate);
      }
      const logs = await prisma.auditLog.findMany({
        where,
        include: {
          user: { select: { id: true, name: true, email: true, role: true } }
        },
        orderBy: { timestamp: 'desc' }
      });
      res.json(logs);
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: 'Failed to fetch audit logs' });
    }
  },

  // POST /admin/audit-logs
  createAuditLog: async (req, res) => {
    try {
      const { userId, action, resource, details } = req.body;
      const log = await prisma.auditLog.create({
        data: {
          userId,
          action,
          resource,
          details: details || null,
          timestamp: new Date()
        }
      });
      res.status(201).json({ message: 'Audit log created', log });
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: 'Failed to create audit log' });
    }
  }
};

module.exports = auditController; 