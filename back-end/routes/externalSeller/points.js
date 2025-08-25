const express = require('express');
const router = express.Router();

const authorizeRoles = require('../../middlewares/roleCheck');
const authenticate = require('../../middlewares/auth');
const pointController = require('../../controllers/pointController');

/**
 * @swagger
 * tags:
 *   name: External Seller Points
 *   description: Points and rewards for External Sellers
 */

router.use(authenticate);
router.use(authorizeRoles('ExternalSeller'));

/**
 * @swagger
 * /user/points:
 *   get:
 *     summary: Get External Seller's point transaction history
 *     tags: [External Seller Points]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: List of transactions
 *       401:
 *         description: Unauthorized or invalid token
 *       500:
 *         description: Server error while fetching transactions
 */
router.get('/', pointController.getMyTransactions);

/**
 * @swagger
 * /user/points/claim:
 *   post:
 *     summary: Claim reward points
 *     tags: [External Seller Points]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               points:
 *                 type: number
 *                 example: 100
 *     responses:
 *       200:
 *         description: Points claimed successfully
 *       400:
 *         description: Invalid request or insufficient points
 *       401:
 *         description: Unauthorized
 *       500:
 *         description: Server error while claiming points
 */
router.post('/claim', pointController.claimPoints);

module.exports = router;
