const express = require('express');
const router = express.Router();

const authenticate = require('../../middlewares/auth');
const authorizeRoles = require('../../middlewares/roleCheck');
const orderController = require('../../controllers/orderController');

/**
 * @swagger
 * tags:
 *   name: Distributor Orders
 *   description: Order placement and viewing for Distributors
 */

router.use(authenticate);
router.use(authorizeRoles('Distributor'));

/**
 * @swagger
 * /distributor/order:
 *   post:
 *     summary: Place a new order
 *     tags: [Distributor Orders]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               items:
 *                 type: array
 *                 description: Array of order items
 *                 items:
 *                   type: object
 *                   properties:
 *                     productId:
 *                       type: string
 *                     quantity:
 *                       type: integer
 *                 example:
 *                   - productId: "prod123"
 *                     quantity: 5
 *     responses:
 *       201:
 *         description: Order placed successfully
 *       400:
 *         description: Invalid input (e.g. no items)
 *       500:
 *         description: Internal server error
 */
router.post('/', orderController.placeOrder);

/**
 * @swagger
 * /distributor/order:
 *   get:
 *     summary: Get all my orders
 *     tags: [Distributor Orders]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: List of orders
 *       401:
 *         description: Unauthorized
 *       500:
 *         description: Server error
 */
router.get('/', orderController.getMyOrders);

module.exports = router;
