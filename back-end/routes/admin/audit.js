const express = require('express');
const router = express.Router();

const authenticate = require('../../middlewares/auth');
const authorizeRoles = require('../../middlewares/roleCheck');
const auditController = require('../../controllers/auditController');

/**
 * @swagger
 * tags:
 *   name: Admin Audit Logs
 *   description: View and create audit logs (Admin only)
 */

router.use(authenticate);
router.use(authorizeRoles('Admin'));

/**
 * @swagger
 * /admin/audit-logs:
 *   get:
 *     summary: Get all audit logs
 *     tags: [Admin Audit Logs]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Audit logs retrieved
 *       500:
 *         description: Failed to retrieve audit logs
 */
router.get('/', auditController.getAuditLogs);

/**
 * @swagger
 * /admin/audit-logs:
 *   post:
 *     summary: Create a new audit log
 *     tags: [Admin Audit Logs]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - action
 *               - actorId
 *             properties:
 *               action:
 *                 type: string
 *                 example: "Created Product"
 *               actorId:
 *                 type: string
 *                 example: "user_id"
 *               metadata:
 *                 type: object
 *                 example: { productId: "123", oldValue: null, newValue: "New Product" }
 *     responses:
 *       201:
 *         description: Audit log created
 *       400:
 *         description: Invalid data
 *       500:
 *         description: Server error
 */
router.post('/', auditController.createAuditLog);

module.exports = router;
