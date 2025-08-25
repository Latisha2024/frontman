const express = require('express');
const router = express.Router();

const authenticate = require('../../middlewares/auth');
const authorizeRoles = require('../../middlewares/roleCheck');
const pointController = require('../../controllers/pointController');

/**
 * @swagger
 * tags:
 *   name: Admin Points
 *   description: Admin management of point transactions
 */

router.use(authenticate);
router.use(authorizeRoles('Admin'));

/**
 * @swagger
 * /admin/points:
 *   get:
 *     summary: View all point transactions
 *     tags: [Admin Points]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: userId
 *         schema:
 *           type: string
 *         description: Filter by user ID
 *       - in: query
 *         name: type
 *         schema:
 *           type: string
 *           enum: [credit, debit]
 *         description: Filter by transaction type
 *     responses:
 *       200:
 *         description: List of point transactions
 *       500:
 *         description: Failed to fetch transactions
 */
router.get('/', pointController.getAllTransactions);

/**
 * @swagger
 * /admin/points/adjust:
 *   post:
 *     summary: Adjust points for a user (credit or debit)
 *     tags: [Admin Points]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       description: Details for adjusting points
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - userId
 *               - type
 *               - amount
 *             properties:
 *               userId:
 *                 type: string
 *               type:
 *                 type: string
 *                 enum: [credit, debit]
 *               amount:
 *                 type: number
 *               reason:
 *                 type: string
 *     responses:
 *       200:
 *         description: Points adjusted successfully
 *       400:
 *         description: Invalid input
 *       500:
 *         description: Failed to adjust points
 */
router.post('/adjust', pointController.adjustPoints);

module.exports = router;
