const express = require('express');
const router = express.Router();

const authenticate = require('../../middlewares/auth');
const authorizeRoles = require('../../middlewares/roleCheck');
const stockController = require('../../controllers/stockController');

/**
 * @swagger
 * tags:
 *   name: Distributor Stock
 *   description: View and manage assigned stock
 */

router.use(authenticate);
router.use(authorizeRoles('Distributor'));

/**
 * @swagger
 * /distributor/stock:
 *   get:
 *     summary: Get stock assigned to the distributor
 *     tags: [Distributor Stock]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: List of assigned stock
 *       401:
 *         description: Unauthorized
 *       500:
 *         description: Server error
 */
router.get('/', stockController.getAssignedStock);

/**
 * @swagger
 * /distributor/stock/{id}:
 *   put:
 *     summary: Update status of a specific stock item
 *     tags: [Distributor Stock]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: string
 *         required: true
 *         description: ID of the stock item
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               status:
 *                 type: string
 *             example:
 *               status: "Delivered"
 *     responses:
 *       200:
 *         description: Stock status updated
 *       400:
 *         description: Invalid input
 *       404:
 *         description: Stock item not found
 *       500:
 *         description: Server error
 */
router.put('/:id', stockController.updateStockStatus);

module.exports = router;
